import 'dart:convert';

import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// Jamaat times the user has recorded against a specific masjid.
///
/// This is the crowd-sourcing seam. Today every entry is local to the phone
/// that typed it; when there is a backend, this class gains a sync and nothing
/// above it changes. The insight it exists to serve is that in Bangladesh the
/// question is almost never "where is a masjid" — it is "when is jamaat", and
/// that answer cannot be computed, only told.
class MasjidJamaatStore {
  MasjidJamaatStore({PreferenceManager? prefs})
      : _prefs = prefs ?? PreferenceManagerImpl.to;

  final PreferenceManager _prefs;

  String _key(String masjidId) =>
      '${AppStrings.spMasjidJamaatPrefix}.$masjidId';

  Future<Map<PrayerName, JamaatTime>> read(String masjidId) async {
    final raw = await _prefs.getString(_key(masjidId));
    if (raw.isEmpty) return const {};

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <PrayerName, JamaatTime>{};
      for (final entry in decoded.entries) {
        final prayer = PrayerName.values
            .firstWhere((p) => p.name == entry.key, orElse: () => PrayerName.fajr);
        final time = JamaatTime.tryParse(entry.value as String?);
        if (time != null) result[prayer] = time;
      }
      return result;
    } catch (_) {
      // A malformed entry degrades to "not known", which the card handles.
      return const {};
    }
  }

  Future<void> write(
    String masjidId,
    Map<PrayerName, JamaatTime> times,
  ) async {
    if (times.isEmpty) {
      await _prefs.remove(_key(masjidId));
      return;
    }
    await _prefs.setString(
      _key(masjidId),
      jsonEncode({
        for (final entry in times.entries)
          entry.key.name: entry.value.toStorage(),
      }),
    );
  }

  Future<void> setPrayer(
    String masjidId,
    PrayerName prayer,
    JamaatTime? time,
  ) async {
    final current = Map<PrayerName, JamaatTime>.from(await read(masjidId));
    if (time == null) {
      current.remove(prayer);
    } else {
      current[prayer] = time;
    }
    await write(masjidId, current);
  }
}
