import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/local/db/app_database.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart'
    show dateKey, dayOf;
import 'package:al_muttaqee/src/module/quran/models/quran_library_models.dart';

/// The reader's own marks on the Quran: bookmarks, notes, and how much has
/// been read each day.
///
/// The text itself comes from the `quran_flutter` package and never changes;
/// this is only the part that belongs to the user, which is why it lives in
/// the same database as their prayer log and is backed up with it.
class QuranLibraryRepository {
  QuranLibraryRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.to;

  final AppDatabase _database;

  Database get _db => _database.db;

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  Future<List<AyahRef>> bookmarks() async {
    final rows = await _db.query(
      AppDatabase.tableQuranBookmark,
      orderBy: 'surah, ayah',
    );
    return rows
        .map((row) => AyahRef(row['surah']! as int, row['ayah']! as int))
        .toList(growable: false);
  }

  Future<bool> isBookmarked(AyahRef ref) async {
    final rows = await _db.query(
      AppDatabase.tableQuranBookmark,
      where: 'surah = ? AND ayah = ?',
      whereArgs: [ref.surah, ref.ayah],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// Returns the new state, so the caller does not have to read back.
  Future<bool> toggleBookmark(AyahRef ref) async {
    if (await isBookmarked(ref)) {
      await _db.delete(
        AppDatabase.tableQuranBookmark,
        where: 'surah = ? AND ayah = ?',
        whereArgs: [ref.surah, ref.ayah],
      );
      return false;
    }
    await _db.insert(
      AppDatabase.tableQuranBookmark,
      {
        'surah': ref.surah,
        'ayah': ref.ayah,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  // ── Notes ─────────────────────────────────────────────────────────────────

  Future<Map<AyahRef, String>> notes() async {
    final rows = await _db.query(AppDatabase.tableQuranNote);
    return {
      for (final row in rows)
        AyahRef(row['surah']! as int, row['ayah']! as int):
            row['body']! as String,
    };
  }

  Future<String?> note(AyahRef ref) async {
    final rows = await _db.query(
      AppDatabase.tableQuranNote,
      where: 'surah = ? AND ayah = ?',
      whereArgs: [ref.surah, ref.ayah],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['body'] as String?;
  }

  /// Writing an empty note deletes it — that is what clearing the field means,
  /// and an empty note in a list is just a broken-looking row.
  Future<void> saveNote(AyahRef ref, String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty) {
      await _db.delete(
        AppDatabase.tableQuranNote,
        where: 'surah = ? AND ayah = ?',
        whereArgs: [ref.surah, ref.ayah],
      );
      return;
    }
    await _db.insert(
      AppDatabase.tableQuranNote,
      {
        'surah': ref.surah,
        'ayah': ref.ayah,
        'body': trimmed,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── Reading progress ──────────────────────────────────────────────────────

  Future<ReadingDay> today() => dayProgress(DateTime.now());

  Future<ReadingDay> dayProgress(DateTime date) async {
    final rows = await _db.query(
      AppDatabase.tableReadingProgress,
      where: 'date = ?',
      whereArgs: [dateKey(date)],
      limit: 1,
    );
    if (rows.isEmpty) return ReadingDay.empty(dayOf(date));
    return ReadingDay.fromRow(rows.first);
  }

  /// Records ayahs read. Upserted so two reads in the same second cannot lose
  /// one to a race.
  Future<void> recordRead({
    required int ayahs,
    required int seconds,
    required AyahRef at,
  }) async {
    await _db.rawInsert(
      '''
      INSERT INTO ${AppDatabase.tableReadingProgress}
        (date, ayahs_read, seconds_read, last_surah, last_ayah)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(date) DO UPDATE SET
        ayahs_read   = ayahs_read + excluded.ayahs_read,
        seconds_read = seconds_read + excluded.seconds_read,
        last_surah   = excluded.last_surah,
        last_ayah    = excluded.last_ayah
      ''',
      [dateKey(DateTime.now()), ayahs, seconds, at.surah, at.ayah],
    );
  }

  /// The last [days] days, newest first, for the plan heatmap.
  Future<List<ReadingDay>> recent({int days = 30}) async {
    final today = dayOf(DateTime.now());
    final from = today.subtract(Duration(days: days - 1));

    final rows = await _db.query(
      AppDatabase.tableReadingProgress,
      where: 'date >= ?',
      whereArgs: [dateKey(from)],
    );
    final byDate = {
      for (final row in rows) row['date']! as String: ReadingDay.fromRow(row),
    };

    return [
      for (var i = 0; i < days; i++)
        () {
          final date = today.subtract(Duration(days: i));
          return byDate[dateKey(date)] ?? ReadingDay.empty(date);
        }(),
    ];
  }
}
