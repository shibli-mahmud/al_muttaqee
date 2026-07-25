import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules salat alerts and dua reminders. Reschedules on each cold start.
class NotificationService extends GetxService {
  static NotificationService get to => Get.find<NotificationService>();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final PreferenceManager _prefs;

  NotificationService({PreferenceManager? prefs})
      : _prefs = prefs ?? PreferenceManagerImpl.to;

  final globalEnabled = true.obs;
  final duaRemindersEnabled = true.obs;
  final prayerToggles = <PrayerName, bool>{
    PrayerName.fajr: true,
    PrayerName.dhuhr: true,
    PrayerName.asr: true,
    PrayerName.maghrib: true,
    PrayerName.isha: true,
  }.obs;

  bool _initialized = false;

  Future<NotificationService> init() async {
    if (_initialized) return this;
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.local);
    } catch (_) {
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
    await _loadPrefs();
    _initialized = true;
    return this;
  }

  Future<void> _createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        'salat_alerts',
        'Prayer alerts',
        description: 'Notifications for daily prayer times',
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        'dua_reminders',
        'Dua reminders',
        description: 'Morning, evening, and night dua reminders',
        importance: Importance.defaultImportance,
      ),
    );
  }

  Future<void> _loadPrefs() async {
    globalEnabled.value = await _prefs.getBool(
      AppStrings.spNotifGlobal,
      defaultValue: true,
    );
    duaRemindersEnabled.value = await _prefs.getBool(
      AppStrings.spNotifDua,
      defaultValue: true,
    );
    for (final p in [
      PrayerName.fajr,
      PrayerName.dhuhr,
      PrayerName.asr,
      PrayerName.maghrib,
      PrayerName.isha,
    ]) {
      prayerToggles[p] = await _prefs.getBool(
        '${AppStrings.spNotifPrayerPrefix}.${p.name}',
        defaultValue: true,
      );
    }
    prayerToggles.refresh();
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    return (granted ?? false) || (iosGranted ?? false);
  }

  Future<void> setGlobal(bool value) async {
    globalEnabled.value = value;
    await _prefs.setBool(AppStrings.spNotifGlobal, value);
    if (!value) {
      await _plugin.cancelAll();
    } else {
      await rescheduleAll();
    }
  }

  Future<void> setDuaReminders(bool value) async {
    duaRemindersEnabled.value = value;
    await _prefs.setBool(AppStrings.spNotifDua, value);
    await rescheduleAll();
  }

  Future<void> setPrayerToggle(PrayerName prayer, bool value) async {
    prayerToggles[prayer] = value;
    prayerToggles.refresh();
    await _prefs.setBool(
      '${AppStrings.spNotifPrayerPrefix}.${prayer.name}',
      value,
    );
    await rescheduleAll();
  }

  Future<void> rescheduleAll() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
    if (!globalEnabled.value) return;

    if (Get.isRegistered<PrayerTimesController>()) {
      final prayer = PrayerTimesController.to;
      final times = prayer.dayTimes.value;
      if (times != null) {
        await _scheduleSalat(times.prayers);
      }
    }

    if (duaRemindersEnabled.value) {
      await _scheduleDuaReminders();
    }
  }

  Future<void> _scheduleSalat(List<PrayerTimeEntry> prayers) async {
    for (final entry in prayers) {
      if (entry.name == PrayerName.sunrise) continue;
      if (prayerToggles[entry.name] != true) continue;
      if (!entry.time.isAfter(DateTime.now())) continue;

      final id = 100 + entry.name.index;
      final scheduled = tz.TZDateTime.from(entry.time, tz.local);
      try {
        await _plugin.zonedSchedule(
          id: id,
          title: _prayerTitle(entry.name),
          body: 'It is time for ${_prayerTitle(entry.name)}',
          scheduledDate: scheduled,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'salat_alerts',
              'Prayer alerts',
              channelDescription: 'Notifications for daily prayer times',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e) {
        debugPrint('NotificationService salat schedule error: $e');
      }
    }
  }

  Future<void> _scheduleDuaReminders() async {
    final now = tz.TZDateTime.now(tz.local);
    final slots = <(int, int, int, String, String)>[
      (201, 6, 30, 'Morning azkar', 'Remember Allah this morning'),
      (202, 17, 30, 'Evening azkar', 'Remember Allah this evening'),
      (203, 21, 30, 'Before sleep', 'Recite your bedtime dua'),
    ];

    for (final slot in slots) {
      var when = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        slot.$2,
        slot.$3,
      );
      if (!when.isAfter(now)) {
        when = when.add(const Duration(days: 1));
      }
      try {
        await _plugin.zonedSchedule(
          id: slot.$1,
          title: slot.$4,
          body: slot.$5,
          scheduledDate: when,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'dua_reminders',
              'Dua reminders',
              channelDescription: 'Morning, evening, and night dua reminders',
              importance: Importance.defaultImportance,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e) {
        debugPrint('NotificationService dua schedule error: $e');
      }
    }
  }

  String _prayerTitle(PrayerName name) {
    return switch (name) {
      PrayerName.fajr => 'Fajr',
      PrayerName.sunrise => 'Sunrise',
      PrayerName.dhuhr => 'Dhuhr',
      PrayerName.asr => 'Asr',
      PrayerName.maghrib => 'Maghrib',
      PrayerName.isha => 'Isha',
    };
  }
}
