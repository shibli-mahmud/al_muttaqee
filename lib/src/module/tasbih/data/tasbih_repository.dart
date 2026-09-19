import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/local/db/app_database.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart'
    show dateKey, dayOf;
import 'package:al_muttaqee/src/module/tasbih/models/tasbih_models.dart';

/// Reads and writes the dhikr log.
///
/// Counts are stored per dhikr per day rather than as a running total, which
/// is what makes a streak, a history and a per-phrase breakdown possible
/// later without re-instrumenting the counter.
class TasbihRepository {
  TasbihRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.to;

  final AppDatabase _database;

  Database get _db => _database.db;

  Future<DhikrDay> day(DateTime date) async {
    final rows = await _db.query(
      AppDatabase.tableDhikrLog,
      where: 'date = ?',
      whereArgs: [dateKey(date)],
    );

    return DhikrDay(
      date: dayOf(date),
      counts: {
        for (final row in rows)
          row['dhikr']! as String: (row['count'] as int?) ?? 0,
      },
    );
  }

  /// Adds [delta] to a dhikr's count for today.
  ///
  /// An upsert rather than a read-modify-write, so rapid tapping cannot lose a
  /// count to a race between two in-flight writes.
  Future<void> add(String dhikrId, int delta, {DateTime? date}) async {
    final when = date ?? DateTime.now();
    await _db.rawInsert(
      '''
      INSERT INTO ${AppDatabase.tableDhikrLog} (date, dhikr, count, updated_at)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(date, dhikr) DO UPDATE SET
        count = MAX(0, count + excluded.count),
        updated_at = excluded.updated_at
      ''',
      [dateKey(when), dhikrId, delta, DateTime.now().toIso8601String()],
    );
  }

  /// Zeroes one dhikr for today — the reset button, which clears the round in
  /// progress rather than the user's history.
  Future<void> reset(String dhikrId, {DateTime? date}) async {
    await _db.delete(
      AppDatabase.tableDhikrLog,
      where: 'date = ? AND dhikr = ?',
      whereArgs: [dateKey(date ?? DateTime.now()), dhikrId],
    );
  }

  /// The last [days] days, newest first, for the history screen.
  Future<List<DhikrDay>> recent({int days = 30}) async {
    final today = dayOf(DateTime.now());
    final from = today.subtract(Duration(days: days - 1));

    final rows = await _db.query(
      AppDatabase.tableDhikrLog,
      where: 'date >= ?',
      whereArgs: [dateKey(from)],
    );

    final byDate = <String, Map<String, int>>{};
    for (final row in rows) {
      final key = row['date']! as String;
      byDate.putIfAbsent(key, () => {})[row['dhikr']! as String] =
          (row['count'] as int?) ?? 0;
    }

    return [
      for (var i = 0; i < days; i++)
        () {
          final date = today.subtract(Duration(days: i));
          final counts = byDate[dateKey(date)];
          return counts == null
              ? DhikrDay.empty(date)
              : DhikrDay(date: date, counts: counts);
        }(),
    ];
  }

  Future<TasbihSummary> summary({
    required String activeDhikr,
    required int target,
  }) async {
    final today = await day(DateTime.now());

    final allTime = Sqflite.firstIntValue(
          await _db.rawQuery(
            'SELECT COALESCE(SUM(count), 0) FROM ${AppDatabase.tableDhikrLog}',
          ),
        ) ??
        0;

    // A year is far more streak than anyone will show, and keeps this one
    // bounded query instead of a full scan.
    final windowStart = dayOf(DateTime.now()).subtract(
      const Duration(days: 365),
    );
    final rows = await _db.rawQuery(
      '''
      SELECT date, SUM(count) AS total
      FROM ${AppDatabase.tableDhikrLog}
      WHERE date >= ?
      GROUP BY date
      HAVING total > 0
      ''',
      [dateKey(windowStart)],
    );
    final active = {for (final row in rows) row['date']! as String};

    // Today only breaks the streak once it is over. Nobody has done their
    // dhikr at six in the morning, and showing টানা ০ দিন then would punish
    // the user for the time of day.
    final startOfToday = dayOf(DateTime.now());
    var cursor = active.contains(dateKey(startOfToday))
        ? startOfToday
        : startOfToday.subtract(const Duration(days: 1));

    var streak = 0;
    while (active.contains(dateKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return TasbihSummary(
      todayTotal: today.total,
      todayRounds: target <= 0 ? 0 : today.countOf(activeDhikr) ~/ target,
      streak: streak,
      allTime: allTime,
    );
  }
}
