import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// How a prayer announces itself.
enum AdhanMode {
  /// Full adhan audio at alarm volume.
  adhan,

  /// A notification with the device's default notification sound.
  silent,

  /// Nothing at all.
  off,
}

/// The adhan recordings the app can play.
///
/// Each maps to an Android raw resource and an iOS bundled sound file. On
/// Android 8+ a notification's sound is fixed by its *channel*, not by the
/// notification, so every sound needs its own channel — see
/// [AdhanSound.channelId].
enum AdhanSound {
  /// The system notification sound. Always available, needs no bundled audio,
  /// and is the fallback when a recording is missing.
  systemDefault,
  makkah,
  madinah,
  mishary;

  /// The raw resource / bundled file name, without extension.
  String? get resourceName => switch (this) {
        AdhanSound.systemDefault => null,
        AdhanSound.makkah => 'adhan_makkah',
        AdhanSound.madinah => 'adhan_madinah',
        AdhanSound.mishary => 'adhan_mishary',
      };

  /// One channel per sound, because Android will not let a channel's sound be
  /// changed after it is created. Changing the sound means moving the
  /// notification to a different channel.
  String get channelId => 'salat_${name.toLowerCase()}';
}

/// What the user chose for one prayer.
class AdhanSetting {
  const AdhanSetting({
    required this.mode,
    required this.sound,
    required this.preOffsetMinutes,
  });

  const AdhanSetting.defaults()
      : mode = AdhanMode.adhan,
        sound = AdhanSound.systemDefault,
        preOffsetMinutes = 0;

  final AdhanMode mode;
  final AdhanSound sound;

  /// Minutes *before* the window opens to fire. Zero fires on time.
  ///
  /// The pre-adhan reminder is the one people actually act on — being told the
  /// window has opened is useful, being told five minutes early is what gets
  /// someone to a masjid.
  final int preOffsetMinutes;

  bool get isSilent => mode == AdhanMode.silent;
  bool get isOff => mode == AdhanMode.off;

  AdhanSetting copyWith({
    AdhanMode? mode,
    AdhanSound? sound,
    int? preOffsetMinutes,
  }) =>
      AdhanSetting(
        mode: mode ?? this.mode,
        sound: sound ?? this.sound,
        preOffsetMinutes: preOffsetMinutes ?? this.preOffsetMinutes,
      );
}

/// Reminders that are not tied to one of the five windows.
enum ExtraReminder {
  /// Friday, ahead of Jumu'ah.
  jumua,

  /// The last third of the night.
  tahajjud,

  /// The daily hadith.
  dailyHadith;

  /// Stable notification ids. Kept well clear of the per-prayer range so a
  /// reshuffle of [PrayerName] can never collide with one of these.
  int get notificationId => switch (this) {
        ExtraReminder.jumua => 900,
        ExtraReminder.tahajjud => 901,
        ExtraReminder.dailyHadith => 902,
      };
}

/// Whether the OS will actually let the adhan fire on time.
///
/// This is surfaced to the user rather than kept internal. If exact alarms are
/// unavailable the app says so plainly instead of firing late and silently —
/// a late adhan with no explanation is the top complaint in this category, and
/// it is the app that gets blamed, not the battery saver that caused it.
class AlarmPermissionState {
  const AlarmPermissionState({
    required this.notificationsGranted,
    required this.exactAlarmsAllowed,
    required this.batteryOptimisationIgnored,
  });

  const AlarmPermissionState.unknown()
      : notificationsGranted = false,
        exactAlarmsAllowed = false,
        batteryOptimisationIgnored = false;

  final bool notificationsGranted;
  final bool exactAlarmsAllowed;
  final bool batteryOptimisationIgnored;

  bool get allGranted =>
      notificationsGranted && exactAlarmsAllowed && batteryOptimisationIgnored;

  AlarmPermissionState copyWith({
    bool? notificationsGranted,
    bool? exactAlarmsAllowed,
    bool? batteryOptimisationIgnored,
  }) =>
      AlarmPermissionState(
        notificationsGranted: notificationsGranted ?? this.notificationsGranted,
        exactAlarmsAllowed: exactAlarmsAllowed ?? this.exactAlarmsAllowed,
        batteryOptimisationIgnored:
            batteryOptimisationIgnored ?? this.batteryOptimisationIgnored,
      );
}
