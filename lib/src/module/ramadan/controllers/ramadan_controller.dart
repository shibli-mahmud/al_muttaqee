import 'dart:async';

import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/local/db/app_database.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart'
    show dateKey, dayOf;
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// রমজান মোড — frame ২০.
///
/// Available all year but surfaced during Ramadan. The countdown changes
/// subject at sunset: before Maghrib it counts to iftar, after it counts to
/// the end of sehri, because those are the only two times that matter and
/// which one you want is never ambiguous.
class RamadanController extends BaseController {
  static RamadanController get to => Get.find<RamadanController>();

  RamadanController({AppDatabase? database})
      : _database = database ?? AppDatabase.to;

  final AppDatabase _database;

  Database get _db => _database.db;

  final remaining = Duration.zero.obs;

  /// True while counting to iftar; false while counting to sehri's end.
  final countingToIftar = true.obs;

  /// Day of Ramadan, 1..30, or 0 outside it.
  final rozaDay = 0.obs;
  final isRamadan = false.obs;

  /// Day-of-Ramadan → kept.
  final rozaLog = <int, bool>{}.obs;
  final taraweehLog = <int, int>{}.obs;

  Timer? _ticker;

  PrayerTimesController? get _prayerTimes =>
      Get.isRegistered<PrayerTimesController>()
          ? PrayerTimesController.to
          : null;

  @override
  void onInit() {
    super.onInit();
    _readCalendar();
    _loadLog();
    _tick();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _readCalendar() {
    final hijri = HijriCalendar.fromDate(DateTime.now());
    isRamadan.value = hijri.hMonth == 9;
    rozaDay.value = isRamadan.value ? hijri.hDay : 0;
  }

  DateTime? get _sehriEnd {
    final times = _prayerTimes?.dayTimes.value;
    return times?.entryFor(PrayerName.fajr)?.time;
  }

  DateTime? get sehriEnd => _sehriEnd;

  DateTime? get iftar {
    final times = _prayerTimes?.dayTimes.value;
    return times?.entryFor(PrayerName.maghrib)?.time;
  }

  void _tick() {
    final maghrib = iftar;
    final fajr = _sehriEnd;
    if (maghrib == null || fajr == null) return;

    final now = DateTime.now();
    if (now.isBefore(maghrib)) {
      countingToIftar.value = true;
      remaining.value = maghrib.difference(now);
    } else {
      countingToIftar.value = false;
      // After sunset the next sehri ends at tomorrow's Fajr.
      final tomorrow = _prayerTimes
          ?.timesFor(DateTime(now.year, now.month, now.day + 1))
          ?.entryFor(PrayerName.fajr)
          ?.time;
      remaining.value =
          (tomorrow ?? fajr.add(const Duration(days: 1))).difference(now);
    }
  }

  // ── The fast log ──────────────────────────────────────────────────────────

  Future<void> _loadLog() async {
    if (!_database.isReady) return;
    try {
      final hijri = HijriCalendar.fromDate(DateTime.now());
      if (hijri.hMonth != 9) {
        // Outside Ramadan the grid is still shown, but empty — there is
        // nothing to read.
        rozaLog.clear();
        taraweehLog.clear();
        return;
      }

      final rows = await _db.query(AppDatabase.tableRozaLog);
      final kept = <int, bool>{};
      final taraweeh = <int, int>{};

      for (final row in rows) {
        final date = DateTime.parse(row['date']! as String);
        final entry = HijriCalendar.fromDate(date);
        if (entry.hMonth != 9 || entry.hYear != hijri.hYear) continue;
        kept[entry.hDay] = ((row['kept'] as int?) ?? 0) == 1;
        taraweeh[entry.hDay] = (row['taraweeh'] as int?) ?? 0;
      }

      rozaLog.assignAll(kept);
      taraweehLog.assignAll(taraweeh);
    } catch (e, st) {
      logger.e('RamadanController._loadLog: $e\n$st');
    }
  }

  /// Marks today's fast kept or not.
  ///
  /// Only today and days already past can be marked; a fast cannot be logged
  /// before it has been kept, and letting someone tick day 30 on day 3 would
  /// make the tracker meaningless.
  Future<void> toggleRoza(int day) async {
    if (!isRamadan.value || day > rozaDay.value) return;

    final next = !(rozaLog[day] ?? false);
    rozaLog[day] = next;
    rozaLog.refresh();

    final date = dayOf(DateTime.now()).subtract(
      Duration(days: rozaDay.value - day),
    );

    try {
      await _db.rawInsert(
        '''
        INSERT INTO ${AppDatabase.tableRozaLog} (date, kept, taraweeh, updated_at)
        VALUES (?, ?, COALESCE((SELECT taraweeh FROM ${AppDatabase.tableRozaLog} WHERE date = ?), 0), ?)
        ON CONFLICT(date) DO UPDATE SET
          kept = excluded.kept,
          updated_at = excluded.updated_at
        ''',
        [dateKey(date), next ? 1 : 0, dateKey(date),
         DateTime.now().toIso8601String()],
      );
    } catch (e, st) {
      logger.e('RamadanController.toggleRoza: $e\n$st');
      rozaLog[day] = !next;
      rozaLog.refresh();
    }
  }

  Future<void> setTaraweeh(int rakats) async {
    if (!isRamadan.value) return;
    final day = rozaDay.value;
    taraweehLog[day] = rakats;
    taraweehLog.refresh();

    try {
      await _db.rawInsert(
        '''
        INSERT INTO ${AppDatabase.tableRozaLog} (date, kept, taraweeh, updated_at)
        VALUES (?, COALESCE((SELECT kept FROM ${AppDatabase.tableRozaLog} WHERE date = ?), 0), ?, ?)
        ON CONFLICT(date) DO UPDATE SET
          taraweeh = excluded.taraweeh,
          updated_at = excluded.updated_at
        ''',
        [dateKey(DateTime.now()), dateKey(DateTime.now()), rakats,
         DateTime.now().toIso8601String()],
      );
    } catch (e, st) {
      logger.e('RamadanController.setTaraweeh: $e\n$st');
    }
  }

  int get rozaKept => rozaLog.values.where((kept) => kept).length;

  /// Consecutive nights of taraweeh, counting back from today.
  int get taraweehStreak {
    var streak = 0;
    for (var day = rozaDay.value; day >= 1; day--) {
      if ((taraweehLog[day] ?? 0) <= 0) break;
      streak++;
    }
    return streak;
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
