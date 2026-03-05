import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_bn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('bn'),
  ];

  // Common navigation & labels
  String get home;
  String get quran;
  String get qibla;
  String get tasbih;
  String get language;
  String get english;
  String get bangla;

  // Qibla
  String get preparingQiblaCompass;
  String get locationAccessRequired;
  String get locationAccessMessage;
  String get compassCalibrationMessage;
  String get moveDeviceLikeThis;
  String get qiblaDirection;
  String get qiblaDirectionHint;
  String qiblaHeadingFormat(double qibla, double heading);
  String get deviceLevelMessage;
  String tiltMessage(double tilt);
  String get levelIndicator;

  // Quran
  String get quranLastRead;
  String get quranContinueReading;
  String get quranStartReading;
  String get quranNoLastReadYet;
  String get quranSurahTab;
  String get quranParaTab;
  String get quranSurahLabel;
  String get quranParaLabel;
  String quranAyahNumberLabel(int ayahNumber);
  String get quranRevelationMeccan;
  String get quranRevelationMedinan;

  // Tasbih
  String get tasbihTapToCount;
  String get tasbihSwipeHorizontal;
  String get tasbihSwipeVertical;
  String get tasbihOrientationLeftRight;
  String get tasbihOrientationUpDown;
  String get tasbihResetRound;
  String get tasbihResetAll;
  String tasbihRoundsTotal(int rounds, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'bn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'bn':
      return AppLocalizationsBn();
  }
  return AppLocalizationsEn();
}
