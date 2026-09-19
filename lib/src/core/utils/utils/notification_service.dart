import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/notifications/data/adhan_settings_repository.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// Schedules the adhan.
///
/// This is the most important non-visual thing the app does: a user who is not
/// reminded on time has no reason to keep it installed. Three decisions shape
/// the implementation.
///
/// **A rolling seven-day window, not one day.** Android will not hold an
/// unbounded queue of alarms and the app cannot count on being launched daily,
/// so it schedules a week ahead and refills the window on every launch, every
/// settings change and every location change. A user who does not open the app
/// for six days still hears the adhan on the sixth.
///
/// **Exact alarms, and honesty when they are not available.** When the OS has
/// withheld exact-alarm permission the schedule degrades to inexact rather than
/// silently failing, and [permissions] reports it so frame ১২ can say so in
/// plain Bangla. Firing ten minutes late with no explanation is the top
/// complaint in this category and it is always the app that gets blamed.
///
/// **One channel per adhan sound.** Android 8 fixed a notification's sound to
/// its channel, so changing the recording means moving to a different channel;
/// they are all created up front.
class NotificationService extends GetxService {
  static NotificationService get to => Get.find<NotificationService>();

  NotificationService({
    AdhanSettingsRepository? settings,
    FlutterLocalNotificationsPlugin? plugin,
  })  : _settings = settings ?? AdhanSettingsRepository(),
        _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final AdhanSettingsRepository _settings;

  static const MethodChannel _alarmChannel =
      MethodChannel('com.shibli.al_muttaqee/alarm_permissions');

  /// How far ahead the rolling window reaches.
  static const int scheduleHorizonDays = 7;

  /// Notification id space. Prayer alerts occupy
  /// `_prayerIdBase + dayOffset * 10 + prayer.index`, which is bounded by
  /// 1000..1069 and cannot collide with the [ExtraReminder] ids at 900.
  static const int _prayerIdBase = 1000;

  final adhanSettings = <PrayerName, AdhanSetting>{}.obs;
  final reminders = <ExtraReminder, bool>{}.obs;
  final permissions = const AlarmPermissionState.unknown().obs;

  /// The master switch on আরও. Off cancels everything.
  final globalEnabled = true.obs;

  bool _initialized = false;

  Future<NotificationService> init() async {
    if (_initialized) return this;

    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(await _resolveTimeZoneName()));
    } catch (_) {
      // The audience is overwhelmingly in Bangladesh, so that is the fallback
      // rather than UTC — a wrong-by-six-hours adhan is worse than no adhan.
      tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    await _createChannels();
    await reloadSettings();
    await refreshPermissions();

    _initialized = true;
    return this;
  }

  Future<String> _resolveTimeZoneName() async {
    // `tz.local` is UTC until told otherwise. There is no first-party way to
    // read the device zone, and pulling a package in for one string is not
    // worth it, so the offset is mapped for the zones this app actually serves
    // and everything else falls through to the catch above.
    final offset = DateTime.now().timeZoneOffset;
    return switch (offset.inMinutes) {
      360 => 'Asia/Dhaka',
      330 => 'Asia/Kolkata',
      300 => 'Asia/Karachi',
      420 => 'Asia/Bangkok',
      240 => 'Asia/Dubai',
      180 => 'Asia/Riyadh',
      0 => 'Europe/London',
      _ => tz.local.name,
    };
  }

  // ── Channels ──────────────────────────────────────────────────────────────

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  /// The channel a silent (notification-only) prayer alert uses.
  static const String silentChannelId = 'salat_silent';

  /// The channel for Jumu'ah, tahajjud and the daily hadith.
  static const String reminderChannelId = 'dua_reminders';

  Future<void> _createChannels() async {
    final android = _android;
    if (android == null) return;

    for (final sound in AdhanSound.values) {
      final resource = sound.resourceName;
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          sound.channelId,
          'Prayer alerts — ${sound.name}',
          description: 'Adhan at the start of each prayer window',
          importance: Importance.max,
          playSound: true,
          sound: resource == null
              ? null
              : RawResourceAndroidNotificationSound(resource),
          // USAGE_ALARM is what makes the adhan audible through Do Not
          // Disturb. A prayer time is an alarm, not a ping.
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
      );
    }

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        silentChannelId,
        'Prayer alerts — silent',
        description: 'A notification only, with no adhan',
        importance: Importance.high,
        playSound: false,
        enableVibration: true,
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        reminderChannelId,
        'Reminders',
        description: 'Jumu\'ah, tahajjud and the daily hadith',
        importance: Importance.defaultImportance,
      ),
    );
  }

  // ── Permissions ───────────────────────────────────────────────────────────

  /// Re-reads the three OS states that decide whether the adhan fires on time.
  Future<AlarmPermissionState> refreshPermissions() async {
    if (!Platform.isAndroid) {
      // iOS has one gate and no exact-alarm or battery concept, so once
      // notifications are allowed everything else is true by construction.
      final granted = await _requestIosPermissions(request: false);
      permissions.value = AlarmPermissionState(
        notificationsGranted: granted,
        exactAlarmsAllowed: true,
        batteryOptimisationIgnored: true,
      );
      return permissions.value;
    }

    final android = _android;
    final notificationsGranted = await android?.areNotificationsEnabled() ?? false;
    final exactAllowed = await android?.canScheduleExactNotifications() ?? false;
    final batteryIgnored = await _invokeBool('isIgnoringBatteryOptimizations');

    permissions.value = AlarmPermissionState(
      notificationsGranted: notificationsGranted,
      exactAlarmsAllowed: exactAllowed,
      batteryOptimisationIgnored: batteryIgnored,
    );
    return permissions.value;
  }

  /// Asks for notification permission. Returns the resulting state.
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      await _android?.requestNotificationsPermission();
    } else {
      await _requestIosPermissions(request: true);
    }
    await refreshPermissions();
    return permissions.value.notificationsGranted;
  }

  /// Asks for exact-alarm permission. On Android 12+ this opens a system
  /// screen rather than a dialog, so the result is only known once the user
  /// comes back — hence the refresh on return.
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    await _android?.requestExactAlarmsPermission();
    await refreshPermissions();
    return permissions.value.exactAlarmsAllowed;
  }

  /// Asks to be exempted from battery optimisation.
  Future<bool> requestBatteryExemption() async {
    if (!Platform.isAndroid) return true;
    await _invokeBool('requestIgnoreBatteryOptimizations');
    await refreshPermissions();
    return permissions.value.batteryOptimisationIgnored;
  }

  /// Opens whichever OS screen is standing between the user and a punctual
  /// adhan, most-blocking first.
  Future<void> openBlockingSetting() async {
    final state = permissions.value;
    if (!state.notificationsGranted) {
      await _invokeBool('openAppNotificationSettings');
      return;
    }
    if (!state.exactAlarmsAllowed) {
      await _invokeBool('openExactAlarmSettings');
      return;
    }
    await _invokeBool('openBatteryOptimizationSettings');
  }

  Future<bool> _invokeBool(String method) async {
    if (!Platform.isAndroid) return true;
    try {
      return await _alarmChannel.invokeMethod<bool>(method) ?? false;
    } on PlatformException catch (error) {
      debugPrint('NotificationService.$method: $error');
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> _requestIosPermissions({required bool request}) async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios == null) return false;
    if (!request) {
      final options = await ios.checkPermissions();
      return options?.isEnabled ?? false;
    }
    return await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  Future<void> reloadSettings() async {
    adhanSettings.value = await _settings.readAll();
    reminders.value = await _settings.readReminders();
  }

  Future<void> setAdhanSetting(PrayerName prayer, AdhanSetting setting) async {
    adhanSettings[prayer] = setting;
    adhanSettings.refresh();
    await _settings.write(prayer, setting);
    await rescheduleAll();
  }

  Future<void> setReminder(ExtraReminder reminder, bool enabled) async {
    reminders[reminder] = enabled;
    reminders.refresh();
    await _settings.writeReminder(reminder, enabled);
    await rescheduleAll();
  }

  Future<void> setGlobal(bool value) async {
    globalEnabled.value = value;
    if (!value) {
      await _plugin.cancelAll();
    } else {
      await rescheduleAll();
    }
  }

  // ── Scheduling ────────────────────────────────────────────────────────────

  /// Rebuilds the whole rolling window.
  ///
  /// Called on launch, after any settings change, and after the location or
  /// calculation method moves — all four invalidate every alarm already queued,
  /// so the window is torn down and rebuilt rather than patched.
  Future<void> rescheduleAll() async {
    if (!_initialized) return;

    await _plugin.cancelAll();
    if (!globalEnabled.value) return;

    await refreshPermissions();

    if (Get.isRegistered<PrayerTimesController>()) {
      await _schedulePrayerWindow(PrayerTimesController.to);
    }
    await _scheduleExtraReminders();
  }

  Future<void> _schedulePrayerWindow(PrayerTimesController prayer) async {
    final now = DateTime.now();

    for (var dayOffset = 0; dayOffset < scheduleHorizonDays; dayOffset++) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      final times = prayer.timesFor(date);
      if (times == null) continue;

      for (final entry in times.prayers) {
        if (entry.name == PrayerName.sunrise) continue;

        final setting =
            adhanSettings[entry.name] ?? const AdhanSetting.defaults();
        if (setting.isOff) continue;

        final fireAt =
            entry.time.subtract(Duration(minutes: setting.preOffsetMinutes));
        if (!fireAt.isAfter(now)) continue;

        await _schedule(
          id: _prayerIdBase + dayOffset * 10 + entry.name.index,
          title: _prayerTitle(entry.name),
          body: _prayerBody(entry.name, setting),
          when: fireAt,
          channelId: setting.isSilent
              ? silentChannelId
              : setting.sound.channelId,
          silent: setting.isSilent,
        );
      }
    }
  }

  Future<void> _scheduleExtraReminders() async {
    final now = tz.TZDateTime.now(tz.local);

    if (reminders[ExtraReminder.jumua] ?? false) {
      // 11:00 on the Friday of the coming week.
      var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
      final daysToFriday = (DateTime.friday - now.weekday + 7) % 7;
      when = when.add(Duration(days: daysToFriday));
      if (!when.isAfter(now)) when = when.add(const Duration(days: 7));
      await _schedule(
        id: ExtraReminder.jumua.notificationId,
        title: _bangla ? 'জুমার নামাজ' : "Jumu'ah",
        body: _bangla
            ? 'আজ জুমা — সময়মতো মসজিদে রওনা দিন।'
            : 'It is Friday — leave for the masjid in good time.',
        when: when.toLocal(),
        channelId: reminderChannelId,
        silent: false,
      );
    }

    if (reminders[ExtraReminder.tahajjud] ?? false) {
      await _scheduleDaily(
        id: ExtraReminder.tahajjud.notificationId,
        hour: 3,
        minute: 30,
        title: _bangla ? 'তাহাজ্জুদ' : 'Tahajjud',
        body: _bangla
            ? 'রাতের শেষ তৃতীয়াংশ — তাহাজ্জুদের সময়।'
            : 'The last third of the night — time for tahajjud.',
      );
    }

    if (reminders[ExtraReminder.dailyHadith] ?? false) {
      await _scheduleDaily(
        id: ExtraReminder.dailyHadith.notificationId,
        hour: 9,
        minute: 0,
        title: _bangla ? 'আজকের হাদিস' : "Today's hadith",
        body: _bangla
            ? 'আজকের হাদিসটি পড়ে নিন।'
            : "Read today's hadith.",
      );
    }
  }

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!when.isAfter(now)) when = when.add(const Duration(days: 1));

    await _schedule(
      id: id,
      title: title,
      body: body,
      when: when.toLocal(),
      channelId: reminderChannelId,
      silent: false,
      repeatDaily: true,
    );
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    required String channelId,
    required bool silent,
    bool repeatDaily = false,
  }) async {
    // Without exact-alarm permission the OS batches alarms to save power and
    // the adhan drifts. Degrading to inexact keeps the reminder rather than
    // dropping it, and frame ১২ tells the user why it may be late.
    final mode = permissions.value.exactAlarmsAllowed
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            silent ? 'Prayer alerts — silent' : 'Prayer alerts',
            channelDescription: 'Notifications for daily prayer times',
            importance: silent ? Importance.high : Importance.max,
            priority: silent ? Priority.high : Priority.max,
            category: AndroidNotificationCategory.alarm,
            playSound: !silent,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(presentSound: !silent),
        ),
        androidScheduleMode: mode,
        matchDateTimeComponents:
            repeatDaily ? DateTimeComponents.time : null,
      );
    } catch (error) {
      debugPrint('NotificationService: could not schedule $id — $error');
    }
  }

  /// Plays the selected adhan through the notification path, so the user hears
  /// exactly what will wake them rather than a preview at media volume.
  Future<void> previewAdhan(AdhanSound sound) async {
    await _plugin.show(
      id: 999,
      title: _prayerTitle(PrayerName.dhuhr),
      body: _bangla ? 'আজানের শব্দ পরীক্ষা' : 'Adhan sound test',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          sound.channelId,
          'Prayer alerts',
          importance: Importance.max,
          priority: Priority.max,
          category: AndroidNotificationCategory.alarm,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// Notification copy is built here rather than through `AppLocalizations`,
  /// which needs a `BuildContext`. Scheduling runs on every cold start and
  /// after every settings change, when there may be no widget tree to read a
  /// context from — so the locale is taken from [L10n] directly.
  bool get _bangla => L10n.isBangla(L10n.selectedLocale);

  String _prayerTitle(PrayerName name) => _bangla
      ? switch (name) {
          PrayerName.fajr => 'ফজর',
          PrayerName.sunrise => 'সূর্যোদয়',
          PrayerName.dhuhr => 'যোহর',
          PrayerName.asr => 'আসর',
          PrayerName.maghrib => 'মাগরিব',
          PrayerName.isha => 'ইশা',
        }
      : switch (name) {
          PrayerName.fajr => 'Fajr',
          PrayerName.sunrise => 'Sunrise',
          PrayerName.dhuhr => 'Dhuhr',
          PrayerName.asr => 'Asr',
          PrayerName.maghrib => 'Maghrib',
          PrayerName.isha => 'Isha',
        };

  String _prayerBody(PrayerName name, AdhanSetting setting) {
    final title = _prayerTitle(name);
    final early = setting.preOffsetMinutes > 0;

    if (!_bangla) {
      return early
          ? '$title starts in ${setting.preOffsetMinutes} minutes.'
          : 'It is now time for $title.';
    }

    // The Bangla genitive suffix attaches straight to the prayer name, so the
    // possessive form is built here rather than interpolated against a bare
    // suffix, which reads as a typo at the call site.
    final prayer = '${title}ের';
    if (early) {
      final minutes = localizeDigits('${setting.preOffsetMinutes}');
      return '$prayer ওয়াক্ত $minutes মিনিটে শুরু হচ্ছে।';
    }
    return 'এখন $prayer ওয়াক্ত।';
  }

  /// Everything currently queued — used by the settings screen to show that
  /// the window really is filled, and by tests.
  Future<List<PendingNotificationRequest>> pending() =>
      _plugin.pendingNotificationRequests();
}
