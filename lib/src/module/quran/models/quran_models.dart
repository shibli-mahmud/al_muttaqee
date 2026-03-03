import 'dart:ui';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/module/quran/data/surah_names_bangla.dart';
import 'package:quran_flutter/quran_flutter.dart';

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

  const ParaMeta({
    required this.number,
    required this.surahNumbers,
  });

  static ParaMeta fromPackage(Juz juz) {
    final keys = juz.surahVerses.keys.map((e) => e as int).toList()..sort();
    return ParaMeta(number: juz.number, surahNumbers: keys);
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
