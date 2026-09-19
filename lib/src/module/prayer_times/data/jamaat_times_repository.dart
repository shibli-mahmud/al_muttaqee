import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// The user's jamaat times, one per prayer.
///
/// In Bangladesh the question is rarely "when does the window open" — it is
/// "when is jamaat at my masjid", and that answer is a property of the masjid,
/// not of the sun. So it cannot be calculated; it has to be told to the app,
/// and then it belongs on every prayer row.
///
/// Phase 1 stores a single set for the masjid the user attends, held as
/// `HH:mm` local-clock strings rather than timestamps because a jamaat time is
/// a standing appointment that repeats daily. The per-masjid, crowd-sourced
/// version arrives with the masjid finder in a later phase; this repository is
/// the seam it will grow from.
class JamaatTimesRepository {
  JamaatTimesRepository({PreferenceManager? prefs})
      : _prefs = prefs ?? PreferenceManagerImpl.to;

  final PreferenceManager _prefs;

  String _key(PrayerName prayer) =>
      '${AppStrings.spJamaatTimePrefix}.${prayer.name}';

  /// Reads every stored jamaat time. Prayers the user has not set are absent.
  Future<Map<PrayerName, JamaatTime>> readAll() async {
    final result = <PrayerName, JamaatTime>{};
    for (final prayer in trackedPrayers) {
      final raw = await _prefs.getString(_key(prayer));
      final parsed = JamaatTime.tryParse(raw);
      if (parsed != null) result[prayer] = parsed;
    }
    return result;
  }

  Future<void> set(PrayerName prayer, JamaatTime? time) async {
    if (time == null) {
      await _prefs.remove(_key(prayer));
      return;
    }
    await _prefs.setString(_key(prayer), time.toStorage());
  }
}

/// A wall-clock time of day, with no date attached.
class JamaatTime {
  const JamaatTime(this.hour, this.minute);

  final int hour;
  final int minute;

  /// Parses `HH:mm`. Returns null for an empty or malformed value rather than
  /// throwing — a corrupted preference should degrade to "not set", not crash
  /// the prayer list.
  static JamaatTime? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return JamaatTime(hour, minute);
  }

  String toStorage() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// The jamaat time placed on a given day, so it can be formatted and
  /// compared against the prayer times for that date.
  DateTime on(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour, minute);

  @override
  bool operator ==(Object other) =>
      other is JamaatTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}
