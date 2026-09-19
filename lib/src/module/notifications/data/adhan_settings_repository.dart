import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// Persistence for what the user chose on the আজান ও রিমাইন্ডার screen.
///
/// These are settings, not logs, so they live in `SharedPreferences` alongside
/// the calculation method rather than in the database.
class AdhanSettingsRepository {
  AdhanSettingsRepository({PreferenceManager? prefs})
      : _prefs = prefs ?? PreferenceManagerImpl.to;

  final PreferenceManager _prefs;

  /// Fajr defaults to five minutes early. It is the one window people
  /// reliably need warning for, and it is the one they are most likely to
  /// sleep through if the notification lands exactly on time.
  static const Map<PrayerName, AdhanSetting> _defaults = {
    PrayerName.fajr: AdhanSetting(
      mode: AdhanMode.adhan,
      sound: AdhanSound.systemDefault,
      preOffsetMinutes: 5,
    ),
  };

  String _modeKey(PrayerName p) => '${AppStrings.spAdhanModePrefix}.${p.name}';
  String _soundKey(PrayerName p) => '${AppStrings.spAdhanSoundPrefix}.${p.name}';
  String _offsetKey(PrayerName p) =>
      '${AppStrings.spAdhanOffsetPrefix}.${p.name}';
  String _reminderKey(ExtraReminder r) =>
      '${AppStrings.spReminderPrefix}.${r.name}';

  Future<Map<PrayerName, AdhanSetting>> readAll() async {
    final result = <PrayerName, AdhanSetting>{};
    for (final prayer in trackedPrayers) {
      final fallback = _defaults[prayer] ?? const AdhanSetting.defaults();

      final modeName =
          await _prefs.getString(_modeKey(prayer), defaultValue: fallback.mode.name);
      final soundName = await _prefs.getString(
        _soundKey(prayer),
        defaultValue: fallback.sound.name,
      );
      final offset = await _prefs.getInt(
        _offsetKey(prayer),
        defaultValue: fallback.preOffsetMinutes,
      );

      result[prayer] = AdhanSetting(
        mode: AdhanMode.values.firstWhere(
          (m) => m.name == modeName,
          orElse: () => fallback.mode,
        ),
        sound: AdhanSound.values.firstWhere(
          (s) => s.name == soundName,
          orElse: () => fallback.sound,
        ),
        preOffsetMinutes: offset,
      );
    }
    return result;
  }

  Future<void> write(PrayerName prayer, AdhanSetting setting) async {
    await _prefs.setString(_modeKey(prayer), setting.mode.name);
    await _prefs.setString(_soundKey(prayer), setting.sound.name);
    await _prefs.setInt(_offsetKey(prayer), setting.preOffsetMinutes);
  }

  /// Jumu'ah and the daily hadith default on; the tahajjud call does not —
  /// waking someone in the night is something they have to opt into.
  static const Map<ExtraReminder, bool> _reminderDefaults = {
    ExtraReminder.jumua: true,
    ExtraReminder.tahajjud: false,
    ExtraReminder.dailyHadith: true,
  };

  Future<Map<ExtraReminder, bool>> readReminders() async {
    final result = <ExtraReminder, bool>{};
    for (final reminder in ExtraReminder.values) {
      result[reminder] = await _prefs.getBool(
        _reminderKey(reminder),
        defaultValue: _reminderDefaults[reminder] ?? false,
      );
    }
    return result;
  }

  Future<void> writeReminder(ExtraReminder reminder, bool enabled) =>
      _prefs.setBool(_reminderKey(reminder), enabled);
}
