import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/local/db/app_database.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// Reads and writes the prayer log.
///
/// Everything here is keyed by local calendar day, never by timestamp: "did I
/// pray Asr today" is a question about the day the user is living in, not about
/// a UTC instant, and a user who travels across a timezone should not lose a
/// tick.
class PrayerLogRepository {
  PrayerLogRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.to;

  final AppDatabase _database;

  Database get _db => _database.db;

  /// The log for one day, as a prayer→status map.
  Future<DayLog> dayLog(DateTime date) async {
    final key = dateKey(date);
    final rows = await _db.query(
      AppDatabase.tablePrayerLog,
      where: 'date = ?',
      whereArgs: [key],
    );

    return DayLog(
      date: dayOf(date),
      statuses: {
        for (final row in rows.map(PrayerLogEntry.fromRow))
          row.prayer: row.status,
      },
    );
  }

  /// Every day in [month] that has at least one row, keyed by day-of-month.
  /// Days with nothing logged are simply absent — the heatmap treats a missing
  /// key as an empty day, so there is no need to store zeroes.
  Future<Map<int, DayLog>> monthLog(DateTime month) async {
    final first = DateTime(month.year, month.month);
    final next = DateTime(month.year, month.month + 1);

    final rows = await _db.query(
      AppDatabase.tablePrayerLog,
      where: 'date >= ? AND date < ?',
      whereArgs: [dateKey(first), dateKey(next)],
    );

    final byDay = <int, Map<PrayerName, PrayerLogStatus>>{};
    for (final entry in rows.map(PrayerLogEntry.fromRow)) {
      byDay.putIfAbsent(entry.date.day, () => {})[entry.prayer] = entry.status;
    }

    return {
      for (final day in byDay.keys)
        day: DayLog(
          date: DateTime(month.year, month.month, day),
          statuses: byDay[day]!,
        ),
    };
  }

  /// Logs [prayer] on [date]. Replaces any existing row for that pair, so
  /// re-logging a prayer as qada after it was marked missed just works.
  Future<void> log(
    DateTime date,
    PrayerName prayer, {
    PrayerLogStatus status = PrayerLogStatus.prayed,
  }) async {
    final entry = PrayerLogEntry(
      date: dayOf(date),
      prayer: prayer,
      status: status,
      loggedAt: DateTime.now(),
    );
    await _db.insert(
      AppDatabase.tablePrayerLog,
      entry.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Removes the row for [prayer] on [date] — the undo half of a tracker tap.
  /// Deleting rather than writing a `missed` row keeps "I mis-tapped" and "I
  /// genuinely missed this" distinguishable in the history.
  Future<void> unlog(DateTime date, PrayerName prayer) async {
    await _db.delete(
      AppDatabase.tablePrayerLog,
      where: 'date = ? AND prayer = ?',
      whereArgs: [dateKey(date), prayer.name],
    );
  }

  /// The current and longest all-five streaks.
  ///
  /// Today is excluded from breaking the streak while it is still running: at
  /// nine in the morning nobody has prayed Isha, and showing `টানা ০ দিন`
  /// then would punish the user for the time of day.
  Future<TrackerSummary> summary({
    required DateTime today,
    required int prayersPossibleToday,
  }) async {
    final month = DateTime(today.year, today.month);
    final monthRows = await monthLog(month);

    var monthCompleted = 0;
    for (final entry in monthRows.entries) {
      if (entry.key > today.day) continue;
      monthCompleted += entry.value.completed;
    }
    final monthPossible =
        (today.day - 1) * trackedPrayers.length + prayersPossibleToday;

    // A year of history is enough to draw any streak worth showing, and keeps
    // this a single bounded query rather than a full table scan.
    final windowStart = dayOf(today).subtract(const Duration(days: 365));
    final rows = await _db.query(
      AppDatabase.tablePrayerLog,
      where: 'date >= ?',
      whereArgs: [dateKey(windowStart)],
    );

    final completedPerDay = <String, int>{};
    for (final entry in rows.map(PrayerLogEntry.fromRow)) {
      if (!entry.counts) continue;
      final key = dateKey(entry.date);
      completedPerDay[key] = (completedPerDay[key] ?? 0) + 1;
    }

    bool full(DateTime day) =>
        (completedPerDay[dateKey(day)] ?? 0) >= trackedPrayers.length;

    final startOfToday = dayOf(today);
    var cursor = full(startOfToday)
        ? startOfToday
        : startOfToday.subtract(const Duration(days: 1));

    var current = 0;
    while (full(cursor)) {
      current++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var longest = current;
    var run = 0;
    for (var day = windowStart;
        !day.isAfter(startOfToday);
        day = day.add(const Duration(days: 1))) {
      if (full(day)) {
        run++;
        if (run > longest) longest = run;
      } else {
        run = 0;
      }
    }

    return TrackerSummary(
      currentStreak: current,
      longestStreak: longest,
      monthCompleted: monthCompleted,
      monthPossible: monthPossible,
    );
  }
}
