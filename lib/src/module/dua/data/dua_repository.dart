import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/local/db/hadith_database.dart';
import 'package:al_muttaqee/src/module/dua/models/dua_models.dart';

/// Duas, drawn from the supplication chapters of the bundled hadith corpus.
///
/// There is no free, complete Bangla dua dataset to be had — the Hisnul Muslim
/// collections on offer are Arabic, English or French. But the corpus this app
/// already ships contains 440 narrated supplications with Arabic, Bangla and a
/// source, in the invocation chapters of five collections. Building on that
/// means every dua here is attributable, which for religious content matters
/// more than a hand-assembled list would.
class DuaRepository {
  DuaRepository({HadithDatabase? database})
      : _database = database ?? HadithDatabase.to;

  final HadithDatabase _database;

  Future<Database> get _db async {
    await _database.open();
    return _database.db;
  }

  /// The chapters this module reads from.
  static const List<DuaSource> sources = [
    DuaSource(book: 'bukhari', chapter: 80),
    DuaSource(book: 'muslim', chapter: 48),
    DuaSource(book: 'ibnmajah', chapter: 34),
    DuaSource(book: 'nasai', chapter: 50),
  ];

  String get _sourceFilter => sources
      .map((s) => "(h.book = '${s.book}' AND h.chapter = ${s.chapter})")
      .join(' OR ');

  /// The categories, with a live count of what is actually in each.
  Future<List<DuaCategory>> categories() async {
    final db = await _db;
    final result = <DuaCategory>[];

    for (final category in duaCategories) {
      final count = Sqflite.firstIntValue(
            await db.rawQuery(
              '''
              SELECT COUNT(*) FROM hadith h
              JOIN hadith_fts f ON f.rowid = h.id
              WHERE ($_sourceFilter) AND hadith_fts MATCH ?
              ''',
              [category.query],
            ),
          ) ??
          0;
      result.add(category.withCount(count));
    }

    return result.where((c) => c.count > 0).toList(growable: false);
  }

  /// Every dua matching a category.
  Future<List<Dua>> byCategory(DuaCategory category, {int limit = 40}) async {
    final db = await _db;
    final rows = await db.rawQuery(
      '''
      SELECT h.book, h.number, h.arabic, h.bengali, h.grade,
             b.name_bn AS book_name
      FROM hadith h
      JOIN hadith_fts f ON f.rowid = h.id
      JOIN book b ON b.slug = h.book
      WHERE ($_sourceFilter) AND hadith_fts MATCH ?
      ORDER BY bm25(hadith_fts)
      LIMIT ?
      ''',
      [category.query, limit],
    );
    return rows.map(Dua.fromRow).toList(growable: false);
  }

  /// The dua the screen opens on.
  ///
  /// Picked by day so it changes daily and is the same for everyone, and
  /// filtered to something short — an invocation that runs to half a page is a
  /// hadith about a dua, not a dua someone is going to say.
  Future<Dua?> featured([DateTime? date]) async {
    final db = await _db;
    final today = date ?? DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;

    final rows = await db.rawQuery(
      '''
      SELECT h.book, h.number, h.arabic, h.bengali, h.grade,
             b.name_bn AS book_name
      FROM hadith h
      JOIN book b ON b.slug = h.book
      WHERE ($_sourceFilter)
        AND LENGTH(h.arabic) BETWEEN 40 AND 260
        AND LENGTH(h.bengali) BETWEEN 40 AND 400
      ORDER BY h.book, h.number
      ''',
    );
    if (rows.isEmpty) return null;
    return Dua.fromRow(rows[dayOfYear % rows.length]);
  }
}
