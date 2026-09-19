import 'dart:ui';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/module/quran/data/surah_names_bangla.dart';
import 'package:quran_flutter/quran_flutter.dart';

// Number formatting is app-wide now, not a Quran concern: every screen has to
// render Bengali numerals. It lives in core/utils and is re-exported here so
// the existing Quran call sites keep working unchanged.
export 'package:al_muttaqee/src/core/utils/utils/number_format.dart'
    show formatNumberWithLocale;

/// A Quran recitation edition served by Al Quran Cloud's CDN.
class QuranReciter {
  final String id;
  final String name;

  const QuranReciter({required this.id, required this.name});
}


/// App-level surah model built from [quran_flutter] [Surah].
/// Arabic and English from package; Bangla names from [surahNamesBangla].
class SurahMeta {
  final int number;
  final String arabicName;
  final String englishName;
  final String banglaName;
  final int ayahCount;
  final String revelationPlace;

  const SurahMeta({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.banglaName,
    required this.ayahCount,
    required this.revelationPlace,
  });

  static SurahMeta fromPackage(Surah s) {
    return SurahMeta(
      number: s.number,
      arabicName: s.name,
      englishName: s.nameEnglish,
      banglaName: surahNamesBangla[s.number] ?? s.nameEnglish,
      ayahCount: s.verseCount,
      revelationPlace: s.type.value,
    );
  }

  /// Whether the surah was revealed at Makkah. The package reports the place
  /// as a free string, so the check is normalised here rather than at every
  /// call site.
  bool get isMeccan =>
      revelationPlace.toLowerCase().startsWith('mecc') ||
      revelationPlace.toLowerCase().startsWith('makk');

  String localizedName(Locale locale) {
    if (L10n.isBangla(locale)) {
      return banglaName;
    }
    return englishName;
  }
}

/// Para (Juz) with the list of surah numbers it contains.
class ParaMeta {
  final int number;
  final List<int> surahNumbers;

  /// Where the para opens, so tapping it lands on the right ayah rather than
  /// at the top of whichever surah happens to be first.
  final int startSurahNumber;
  final int startVerseNumber;

  const ParaMeta({
    required this.number,
    required this.surahNumbers,
    required this.startSurahNumber,
    required this.startVerseNumber,
  });

  static ParaMeta fromPackage(Juz juz) {
    final keys = juz.surahVerses.keys.toList()..sort();
    final first = keys.isEmpty ? 1 : keys.first;
    return ParaMeta(
      number: juz.number,
      surahNumbers: keys,
      startSurahNumber: first,
      startVerseNumber: juz.surahVerses[first]?.startVerseNumber ?? 1,
    );
  }
}

/// Maps app locale to [QuranLanguage] for verse translations.
QuranLanguage? quranLanguageFromLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return QuranLanguage.english;
    case 'bn':
      return QuranLanguage.bengali;
    default:
      return QuranLanguage.english;
  }
}
