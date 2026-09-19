import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// The app's local database.
///
/// Settings stay in `SharedPreferences`; this is for the *logs* — one row per
/// prayer per day, per fast, per reading session. Those accumulate for years,
/// need to be queried by date range to draw a month heatmap or compute a
/// streak, and would be miserable to hold as a growing JSON blob in prefs.
///
/// Phase 1 creates only the prayer log. Later phases add their tables through
/// [_migrate], which is why the version is stepped rather than the schema being
/// dropped and recreated: a user's tracking history is the reason they stay,
/// and losing it on an update would be the worst possible bug in this feature.
class AppDatabase extends GetxService {
  static AppDatabase get to => Get.find<AppDatabase>();

  static const String fileName = 'al_muttaqee.db';
  static const int schemaVersion = 3;

  /// One prayer, one day: `{date, prayer, status, loggedAt}`.
  static const String tablePrayerLog = 'prayer_log';

  /// One dhikr, one day: how many times it was counted.
  static const String tableDhikrLog = 'dhikr_log';

  /// A saved ayah.
  static const String tableQuranBookmark = 'quran_bookmark';

  /// A note the user wrote against an ayah.
  static const String tableQuranNote = 'quran_note';

  /// Ayahs and minutes read, one row per day.
  static const String tableReadingProgress = 'reading_progress';

  /// One fast, one day, during Ramadan.
  static const String tableRozaLog = 'roza_log';

  Database? _db;

  Future<AppDatabase> init() async {
    if (_db != null) return this;
    final directory = await getDatabasesPath();
    _db = await openDatabase(
      p.join(directory, fileName),
      version: schemaVersion,
      onCreate: (db, version) => _migrate(db, 0, version),
      onUpgrade: (db, from, to) => _migrate(db, from, to),
    );
    return this;
  }

  Database get db {
    final database = _db;
    if (database == null) {
      throw StateError('AppDatabase.init() has not completed yet.');
    }
    return database;
  }

  bool get isReady => _db != null;

  static Future<void> _migrate(Database db, int from, int to) async {
    if (from < 1) {
      await db.execute('''
        CREATE TABLE $tablePrayerLog (
          date      TEXT NOT NULL,
          prayer    TEXT NOT NULL,
          status    TEXT NOT NULL,
          logged_at TEXT NOT NULL,
          PRIMARY KEY (date, prayer)
        )
      ''');
      // Every read is either "this day" or "this month", so the date column
      // carries the index.
      await db.execute(
        'CREATE INDEX idx_prayer_log_date ON $tablePrayerLog (date)',
      );
    }

    if (from < 2) {
      // The tasbih counter used to live only in memory, so closing the app
      // threw the day's dhikr away. One row per dhikr per day is enough to
      // rebuild every figure the counter shows — today's total, the rounds,
      // and the streak — without storing a row per tap.
      await db.execute('''
        CREATE TABLE $tableDhikrLog (
          date       TEXT NOT NULL,
          dhikr      TEXT NOT NULL,
          count      INTEGER NOT NULL DEFAULT 0,
          updated_at TEXT NOT NULL,
          PRIMARY KEY (date, dhikr)
        )
      ''');
      await db.execute(
        'CREATE INDEX idx_dhikr_log_date ON $tableDhikrLog (date)',
      );
    }

    if (from < 3) {
      // Bookmarks and notes are keyed by (surah, ayah) rather than by a
      // generated id, so saving the same ayah twice is a no-op instead of a
      // duplicate row.
      await db.execute('''
        CREATE TABLE $tableQuranBookmark (
          surah      INTEGER NOT NULL,
          ayah       INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          PRIMARY KEY (surah, ayah)
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableQuranNote (
          surah      INTEGER NOT NULL,
          ayah       INTEGER NOT NULL,
          body       TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          PRIMARY KEY (surah, ayah)
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableReadingProgress (
          date          TEXT PRIMARY KEY,
          ayahs_read    INTEGER NOT NULL DEFAULT 0,
          seconds_read  INTEGER NOT NULL DEFAULT 0,
          last_surah    INTEGER NOT NULL DEFAULT 0,
          last_ayah     INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableRozaLog (
          date       TEXT PRIMARY KEY,
          kept       INTEGER NOT NULL DEFAULT 0,
          taraweeh   INTEGER NOT NULL DEFAULT 0,
          updated_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
