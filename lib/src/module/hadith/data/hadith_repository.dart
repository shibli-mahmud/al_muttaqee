import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/db/hadith_database.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';

/// Reads the bundled hadith corpus.
///
/// Everything here is offline and local. The previous build fetched from
/// `alquranbd.com/api/`, which now returns 404 for every path, so in practice
/// the hadith screen only ever showed the twelve-entry sample that shipped as
/// its fallback. A bundled database removes the dependency entirely: hadith is
/// reference material, it does not change, and it is exactly the kind of thing
/// that has to work on a train with no signal.
class HadithRepository {
  HadithRepository({HadithDatabase? database, PreferenceManager? preferences})
      : _database = database ?? HadithDatabase.to,
        _prefs = preferences ?? PreferenceManagerImpl.to;

  final HadithDatabase _database;
  final PreferenceManager _prefs;

  Future<Database> get _db async {
    await _database.open();
    return _database.db;
  }

  /// Every collection, in the order the design lists them.
  Future<List<HadithBook>> books() async {
    final db = await _db;
    final rows = await db.query('book', orderBy: 'ordinal');
    return rows.map(HadithBook.fromRow).toList(growable: false);
  }

  Future<HadithBook?> book(String slug) async {
    final db = await _db;
    final rows = await db.query(
      'book',
      where: 'slug = ?',
      whereArgs: [slug],
      limit: 1,
    );
    return rows.isEmpty ? null : HadithBook.fromRow(rows.first);
  }

  /// The kitab list for one collection. Chapters with nothing in them are
  /// dropped — a few editions carry an empty introduction section, and a row
  /// that opens onto nothing reads as a bug.
  Future<List<HadithChapter>> chapters(String book) async {
    final db = await _db;
    final rows = await db.query(
      'chapter',
      where: 'book = ? AND hadith_count > 0',
      whereArgs: [book],
      orderBy: 'number',
    );
    return rows.map(HadithChapter.fromRow).toList(growable: false);
  }

  Future<List<Hadith>> hadiths(String book, int chapter) async {
    final db = await _db;
    final rows = await db.query(
      'hadith',
      where: 'book = ? AND chapter = ?',
      whereArgs: [book, chapter],
      orderBy: 'number',
    );
    return rows.map(Hadith.fromRow).toList(growable: false);
  }

  Future<Hadith?> hadith(String book, int number) async {
    final db = await _db;
    final rows = await db.query(
      'hadith',
      where: 'book = ? AND number = ?',
      whereArgs: [book, number],
      limit: 1,
    );
    return rows.isEmpty ? null : Hadith.fromRow(rows.first);
  }

  /// Full-text search over the Bangla text.
  ///
  /// The query is quoted as an FTS5 string literal rather than passed through:
  /// a user typing `"` or `*` would otherwise either crash the parser or
  /// silently run a different search than they asked for.
  Future<List<HadithHit>> search(String query, {int limit = 60}) async {
    final terms = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) => '"${t.replaceAll('"', '""')}"')
        .toList();
    if (terms.isEmpty) return const [];

    final db = await _db;
    final rows = await db.rawQuery(
      '''
      SELECT h.book, h.number, h.chapter, h.arabic, h.bengali, h.grade,
             b.name_bn AS book_name, c.name_bn AS chapter_name
      FROM hadith_fts f
      JOIN hadith  h ON h.id = f.rowid
      JOIN book    b ON b.slug = h.book
      LEFT JOIN chapter c ON c.book = h.book AND c.number = h.chapter
      WHERE hadith_fts MATCH ?
      ORDER BY bm25(hadith_fts), b.ordinal, h.number
      LIMIT ?
      ''',
      [terms.join(' '), limit],
    );

    return rows
        .map(
          (row) => HadithHit(
            hadith: Hadith.fromRow(row),
            bookName: (row['book_name'] as String?) ?? '',
            chapterName: (row['chapter_name'] as String?) ?? '',
          ),
        )
        .toList(growable: false);
  }

  /// The hadith for the home card and the হাদিস hero.
  ///
  /// Picked by day-of-year from the curated forty so every user sees the same
  /// one on the same day, and so the daily card is always something short and
  /// well known rather than a three-page isnad from the middle of Bukhari.
  Future<HadithHit?> hadithOfTheDay([DateTime? date]) async {
    final db = await _db;
    final today = date ?? DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;

    final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM hadith WHERE book = ?',
            ['nawawi'],
          ),
        ) ??
        0;
    if (count == 0) return null;

    final rows = await db.rawQuery(
      '''
      SELECT h.book, h.number, h.chapter, h.arabic, h.bengali, h.grade,
             b.name_bn AS book_name, c.name_bn AS chapter_name
      FROM hadith h
      JOIN book b ON b.slug = h.book
      LEFT JOIN chapter c ON c.book = h.book AND c.number = h.chapter
      WHERE h.book = 'nawawi'
      ORDER BY h.number
      LIMIT 1 OFFSET ?
      ''',
      [dayOfYear % count],
    );
    if (rows.isEmpty) return null;

    return HadithHit(
      hadith: Hadith.fromRow(rows.first),
      bookName: (rows.first['book_name'] as String?) ?? '',
      chapterName: (rows.first['chapter_name'] as String?) ?? '',
    );
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  Future<List<String>> bookmarkIds() =>
      _prefs.getStringList(AppStrings.spHadithBookmarks);

  Future<bool> isBookmarked(String id) async =>
      (await bookmarkIds()).contains(id);

  Future<List<String>> toggleBookmark(String id) async {
    final ids = List<String>.from(await bookmarkIds());
    if (!ids.remove(id)) ids.add(id);
    await _prefs.setStringList(AppStrings.spHadithBookmarks, ids);
    return ids;
  }

  /// Resolves saved ids back into readable hits, dropping any whose hadith no
  /// longer exists — a corpus update could renumber, and a bookmark list with
  /// blank rows in it is worse than a shorter one.
  Future<List<HadithHit>> bookmarks() async {
    final ids = await bookmarkIds();
    if (ids.isEmpty) return const [];

    final db = await _db;
    final hits = <HadithHit>[];
    for (final id in ids) {
      final parts = id.split(':');
      if (parts.length != 2) continue;
      final number = int.tryParse(parts[1]);
      if (number == null) continue;

      final rows = await db.rawQuery(
        '''
        SELECT h.book, h.number, h.chapter, h.arabic, h.bengali, h.grade,
               b.name_bn AS book_name, c.name_bn AS chapter_name
        FROM hadith h
        JOIN book b ON b.slug = h.book
        LEFT JOIN chapter c ON c.book = h.book AND c.number = h.chapter
        WHERE h.book = ? AND h.number = ?
        LIMIT 1
        ''',
        [parts[0], number],
      );
      if (rows.isEmpty) continue;

      hits.add(
        HadithHit(
          hadith: Hadith.fromRow(rows.first),
          bookName: (rows.first['book_name'] as String?) ?? '',
          chapterName: (rows.first['chapter_name'] as String?) ?? '',
        ),
      );
    }
    return hits;
  }
}
