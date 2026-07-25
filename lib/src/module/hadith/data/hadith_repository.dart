import 'dart:convert';

import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/network/dio_network_provider.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';
import 'package:flutter/services.dart';

class HadithRepository {
  HadithRepository({PreferenceManager? preferences})
      : _preferences = preferences ?? PreferenceManagerImpl.to;

  final PreferenceManager _preferences;
  Map<String, dynamic>? _bundle;

  Future<List<HadithChapter>> loadChapters(HadithBook book) async {
    final cached = await _readRecords(_chaptersKey(book));
    if (cached.isNotEmpty) {
      return _chaptersFromRecords(cached);
    }

    try {
      final records = await _fetchRecords(book);
      if (records.isNotEmpty) return _chaptersFromRecords(records);
    } catch (_) {
      // Fall through to bundled offline data.
    }

    final bundle = await _loadBundle();
    final bookData = bundle[book.apiSlug] as Map<String, dynamic>?;
    final chapters = (bookData?['chapters'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    return _chaptersFromRecords(chapters);
  }

  Future<List<Hadith>> loadHadiths(HadithBook book, int chapter) async {
    final cached = await _readRecords(_hadithsKey(book, chapter));
    if (cached.isNotEmpty) {
      return _hadithsFromRecords(book, cached);
    }

    try {
      final records = await _fetchRecords(book, chapter: chapter);
      if (records.isNotEmpty) return _hadithsFromRecords(book, records);
    } catch (_) {
      // Fall through to bundled offline data.
    }

    final bundle = await _loadBundle();
    final bookData = bundle[book.apiSlug] as Map<String, dynamic>?;
    final hadithsMap = bookData?['hadiths'] as Map<String, dynamic>? ?? {};
    final list = (hadithsMap['$chapter'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    return _hadithsFromRecords(book, list);
  }

  List<HadithChapter> _chaptersFromRecords(List<Map<String, dynamic>> records) {
    final chapters = records
        .map(HadithChapter.fromJson)
        .where((chapter) => chapter.number > 0)
        .toList();
    final unique = <int, HadithChapter>{
      for (final chapter in chapters) chapter.number: chapter,
    };
    if (unique.isEmpty) return const [HadithChapter(number: 1, title: '')];
    return unique.values.toList()..sort((a, b) => a.number.compareTo(b.number));
  }

  List<Hadith> _hadithsFromRecords(
    HadithBook book,
    List<Map<String, dynamic>> records,
  ) {
    return records
        .map((record) => Hadith.fromJson(book, record))
        .where(
          (hadith) =>
              hadith.arabic.isNotEmpty ||
              hadith.bengali.isNotEmpty ||
              hadith.english.isNotEmpty,
        )
        .toList();
  }

  Future<Map<String, dynamic>> _loadBundle() async {
    if (_bundle != null) return _bundle!;
    final raw = await rootBundle.loadString('assets/data/hadith_bundle.json');
    _bundle = jsonDecode(raw) as Map<String, dynamic>;
    return _bundle!;
  }

  Future<List<Map<String, dynamic>>> _fetchRecords(
    HadithBook book, {
    int? chapter,
  }) async {
    final path = chapter == null
        ? '${AppStrings.urlHadithBase}/${book.apiSlug}'
        : '${AppStrings.urlHadithBase}/${book.apiSlug}/$chapter';
    final response = await NetworkProvider.httpDio.get(path);
    final records = _extractRecords(response.data);
    if (records.isNotEmpty) {
      await _preferences.setString(
        chapter == null ? _chaptersKey(book) : _hadithsKey(book, chapter),
        jsonEncode(response.data),
      );
    }
    return records;
  }

  Future<List<Map<String, dynamic>>> _readRecords(String key) async {
    final raw = await _preferences.getString(key);
    if (raw.isEmpty) return const [];
    try {
      return _extractRecords(jsonDecode(raw));
    } catch (_) {
      return const [];
    }
  }

  List<Map<String, dynamic>> _extractRecords(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (value is! Map) return const [];
    for (final key in ['data', 'hadiths', 'chapters', 'result', 'results']) {
      if (value.containsKey(key)) {
        final records = _extractRecords(value[key]);
        if (records.isNotEmpty) return records;
      }
    }
    return const [];
  }

  String _chaptersKey(HadithBook book) =>
      '${AppStrings.spHadithCachePrefix}.${book.apiSlug}.chapters';
  String _hadithsKey(HadithBook book, int chapter) =>
      '${AppStrings.spHadithCachePrefix}.${book.apiSlug}.chapter.$chapter';
}
