import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @tasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get bangla;

  /// No description provided for @preparingQiblaCompass.
  ///
  /// In en, this message translates to:
  /// **'Preparing Qibla compass...'**
  String get preparingQiblaCompass;

  /// No description provided for @locationAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Location access required'**
  String get locationAccessRequired;

  /// No description provided for @locationAccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services and grant permission so we can calculate the direction of Qibla from your current position.'**
  String get locationAccessMessage;

  /// No description provided for @compassCalibrationMessage.
  ///
  /// In en, this message translates to:
  /// **'Compass needs calibration. Move your device in the figure-8 pattern below to improve accuracy.'**
  String get compassCalibrationMessage;

  /// No description provided for @moveDeviceLikeThis.
  ///
  /// In en, this message translates to:
  /// **'Move device like this'**
  String get moveDeviceLikeThis;

  /// No description provided for @qiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaDirection;

  /// No description provided for @qiblaDirectionHint.
  ///
  /// In en, this message translates to:
  /// **'Point the arrow towards the top of your device to face Qibla.'**
  String get qiblaDirectionHint;

  /// No description provided for @qiblaHeadingFormat.
  ///
  /// In en, this message translates to:
  /// **'Qibla: {qibla}°  |  Heading: {heading}°'**
  String qiblaHeadingFormat(Object qibla, Object heading);

  /// No description provided for @deviceLevelMessage.
  ///
  /// In en, this message translates to:
  /// **'Device is level — center the bubble in the circle'**
  String get deviceLevelMessage;

  /// No description provided for @tiltMessage.
  ///
  /// In en, this message translates to:
  /// **'Tilt: {tilt}° — center the bubble to level the device'**
  String tiltMessage(Object tilt);

  /// No description provided for @levelIndicator.
  ///
  /// In en, this message translates to:
  /// **'Level indicator (center bubble)'**
  String get levelIndicator;

  /// No description provided for @tasbihTapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap the circle to count'**
  String get tasbihTapToCount;

  /// No description provided for @tasbihSwipeHorizontal.
  ///
  /// In en, this message translates to:
  /// **'Swipe left → right to count'**
  String get tasbihSwipeHorizontal;

  /// No description provided for @tasbihSwipeVertical.
  ///
  /// In en, this message translates to:
  /// **'Swipe up ↑ to count'**
  String get tasbihSwipeVertical;

  /// No description provided for @tasbihOrientationLeftRight.
  ///
  /// In en, this message translates to:
  /// **'Left–Right'**
  String get tasbihOrientationLeftRight;

  /// No description provided for @tasbihOrientationUpDown.
  ///
  /// In en, this message translates to:
  /// **'Up–Down'**
  String get tasbihOrientationUpDown;

  /// No description provided for @tasbihResetRound.
  ///
  /// In en, this message translates to:
  /// **'Reset round'**
  String get tasbihResetRound;

  /// No description provided for @tasbihResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get tasbihResetAll;

  /// No description provided for @tasbihRoundsTotal.
  ///
  /// In en, this message translates to:
  /// **'{rounds} round(s) • {total} total'**
  String tasbihRoundsTotal(Object rounds, Object total);

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @preparingPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Calculating prayer times...'**
  String get preparingPrayerTimes;

  /// No description provided for @prayerTimesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load prayer times.'**
  String get prayerTimesLoadError;

  /// No description provided for @prayerTimesLocationFallback.
  ///
  /// In en, this message translates to:
  /// **'Using default location (Dhaka). Grant location for accurate times.'**
  String get prayerTimesLocationFallback;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayer;

  /// No description provided for @currentPrayer.
  ///
  /// In en, this message translates to:
  /// **'Current prayer'**
  String get currentPrayer;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get timeRemaining;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer settings'**
  String get prayerSettings;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get calculationMethod;

  /// No description provided for @hanafiMadhab.
  ///
  /// In en, this message translates to:
  /// **'Hanafi madhab (later Asr)'**
  String get hanafiMadhab;

  /// No description provided for @manualOffsets.
  ///
  /// In en, this message translates to:
  /// **'Manual offsets (minutes)'**
  String get manualOffsets;

  /// No description provided for @methodKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi (University of Islamic Sciences)'**
  String get methodKarachi;

  /// No description provided for @methodMwl.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get methodMwl;

  /// No description provided for @methodEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority'**
  String get methodEgyptian;

  /// No description provided for @methodUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm al-Qura'**
  String get methodUmmAlQura;

  /// No description provided for @methodNorthAmerica.
  ///
  /// In en, this message translates to:
  /// **'ISNA (North America)'**
  String get methodNorthAmerica;

  /// No description provided for @methodDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get methodDubai;

  /// No description provided for @methodQatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get methodQatar;

  /// No description provided for @methodKuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get methodKuwait;

  /// No description provided for @methodSingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get methodSingapore;

  /// No description provided for @methodTurkiye.
  ///
  /// In en, this message translates to:
  /// **'Türkiye (Diyanet)'**
  String get methodTurkiye;

  /// No description provided for @hadithOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Hadith of the Day'**
  String get hadithOfTheDay;

  /// No description provided for @duaOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Dua of the Day'**
  String get duaOfTheDay;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccess;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @masjidFinder.
  ///
  /// In en, this message translates to:
  /// **'Masjid Finder'**
  String get masjidFinder;

  /// No description provided for @gregorianDate.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get gregorianDate;

  /// No description provided for @hijriDate.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get hijriDate;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get bookmarked;

  /// No description provided for @hadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get hadith;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @zakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get zakat;

  /// No description provided for @supportApp.
  ///
  /// In en, this message translates to:
  /// **'Support this app'**
  String get supportApp;

  /// No description provided for @proUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro'**
  String get proUnlock;

  /// No description provided for @offlineDownload.
  ///
  /// In en, this message translates to:
  /// **'Download for offline'**
  String get offlineDownload;

  /// No description provided for @reciter.
  ///
  /// In en, this message translates to:
  /// **'Reciter'**
  String get reciter;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @repeatAyah.
  ///
  /// In en, this message translates to:
  /// **'Repeat ayah'**
  String get repeatAyah;

  /// No description provided for @repeatSurah.
  ///
  /// In en, this message translates to:
  /// **'Repeat surah'**
  String get repeatSurah;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get playbackSpeed;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String distanceKm(Object distance);

  /// No description provided for @sehriEnds.
  ///
  /// In en, this message translates to:
  /// **'Sehri ends'**
  String get sehriEnds;

  /// No description provided for @iftar.
  ///
  /// In en, this message translates to:
  /// **'Iftar'**
  String get iftar;

  /// No description provided for @ratesLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rates last updated: {date}'**
  String ratesLastUpdated(Object date);

  /// No description provided for @zakatDue.
  ///
  /// In en, this message translates to:
  /// **'Zakat due'**
  String get zakatDue;

  /// No description provided for @nisabThreshold.
  ///
  /// In en, this message translates to:
  /// **'Nisab threshold'**
  String get nisabThreshold;

  /// No description provided for @permissionRationaleLocation.
  ///
  /// In en, this message translates to:
  /// **'Location is used for Qibla, prayer times, and finding nearby mosques.'**
  String get permissionRationaleLocation;

  /// No description provided for @permissionRationaleNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications remind you of prayer times and daily duas.'**
  String get permissionRationaleNotifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @salatAlerts.
  ///
  /// In en, this message translates to:
  /// **'Prayer alerts'**
  String get salatAlerts;

  /// No description provided for @duaReminders.
  ///
  /// In en, this message translates to:
  /// **'Dua reminders'**
  String get duaReminders;

  /// No description provided for @globalNotifications.
  ///
  /// In en, this message translates to:
  /// **'All notifications'**
  String get globalNotifications;

  /// No description provided for @narrator.
  ///
  /// In en, this message translates to:
  /// **'Narrator'**
  String get narrator;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @hadithAllChapters.
  ///
  /// In en, this message translates to:
  /// **'All chapters'**
  String get hadithAllChapters;

  /// No description provided for @hadithBukhari.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari'**
  String get hadithBukhari;

  /// No description provided for @hadithMuslim.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim'**
  String get hadithMuslim;

  /// No description provided for @hadithAbuDaud.
  ///
  /// In en, this message translates to:
  /// **'Sunan Abu Dawud'**
  String get hadithAbuDaud;

  /// No description provided for @hadithIbnMajah.
  ///
  /// In en, this message translates to:
  /// **'Sunan Ibn Majah'**
  String get hadithIbnMajah;

  /// No description provided for @hadithTirmidhi.
  ///
  /// In en, this message translates to:
  /// **'Jami` at-Tirmidhi'**
  String get hadithTirmidhi;

  /// No description provided for @hadithSourcesAttribution.
  ///
  /// In en, this message translates to:
  /// **'Islamic Foundation Bangladesh / alquranbd'**
  String get hadithSourcesAttribution;

  /// No description provided for @ramadanMode.
  ///
  /// In en, this message translates to:
  /// **'Ramadan mode'**
  String get ramadanMode;

  /// No description provided for @importantDates.
  ///
  /// In en, this message translates to:
  /// **'Important dates'**
  String get importantDates;

  /// No description provided for @mapsApiKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Add Google Maps and Places API keys to .env to show nearby mosques.'**
  String get mapsApiKeyRequired;

  /// No description provided for @noNearbyMasjids.
  ///
  /// In en, this message translates to:
  /// **'No nearby mosques found.'**
  String get noNearbyMasjids;

  /// No description provided for @proBenefits.
  ///
  /// In en, this message translates to:
  /// **'Support development with offline downloads for all reciters and full Hadith search and bookmarks. Quran text, Prayer Times, Qibla and Tasbih stay free.'**
  String get proBenefits;

  /// No description provided for @proUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Pro unlocked'**
  String get proUnlocked;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Make an optional Sadaqah contribution to support the app.'**
  String get supportDescription;

  /// No description provided for @storeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The store is unavailable. Try again in a configured test or production environment.'**
  String get storeUnavailable;

  /// No description provided for @debugProUnlock.
  ///
  /// In en, this message translates to:
  /// **'Debug Pro unlock'**
  String get debugProUnlock;

  /// No description provided for @ashura.
  ///
  /// In en, this message translates to:
  /// **'Ashura'**
  String get ashura;

  /// No description provided for @ramadanStart.
  ///
  /// In en, this message translates to:
  /// **'Ramadan begins'**
  String get ramadanStart;

  /// No description provided for @laylatulQadr.
  ///
  /// In en, this message translates to:
  /// **'Estimated Laylatul Qadr night'**
  String get laylatulQadr;

  /// No description provided for @eidAlFitr.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr'**
  String get eidAlFitr;

  /// No description provided for @eidAlAdha.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha'**
  String get eidAlAdha;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @goldGrams.
  ///
  /// In en, this message translates to:
  /// **'Gold (grams)'**
  String get goldGrams;

  /// No description provided for @silverGrams.
  ///
  /// In en, this message translates to:
  /// **'Silver (grams)'**
  String get silverGrams;

  /// No description provided for @businessAssets.
  ///
  /// In en, this message translates to:
  /// **'Business assets'**
  String get businessAssets;

  /// No description provided for @debtsOwedToYou.
  ///
  /// In en, this message translates to:
  /// **'Debts owed to you'**
  String get debtsOwedToYou;

  /// No description provided for @debtsYouOwe.
  ///
  /// In en, this message translates to:
  /// **'Debts you owe'**
  String get debtsYouOwe;

  /// No description provided for @useGoldNisab.
  ///
  /// In en, this message translates to:
  /// **'Use gold nisab (85g)'**
  String get useGoldNisab;

  /// No description provided for @quranLastRead.
  ///
  /// In en, this message translates to:
  /// **'Last read'**
  String get quranLastRead;

  /// No description provided for @quranNoLastReadYet.
  ///
  /// In en, this message translates to:
  /// **'You have not started reading yet'**
  String get quranNoLastReadYet;

  /// No description provided for @quranStartReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get quranStartReading;

  /// No description provided for @quranContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get quranContinueReading;

  /// No description provided for @quranSurahTab.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get quranSurahTab;

  /// No description provided for @quranParaTab.
  ///
  /// In en, this message translates to:
  /// **'Para'**
  String get quranParaTab;

  /// No description provided for @quranParaLabel.
  ///
  /// In en, this message translates to:
  /// **'Para {number}'**
  String quranParaLabel(int number);

  /// No description provided for @quranRevelationMeccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quranRevelationMeccan;

  /// No description provided for @quranRevelationMedinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quranRevelationMedinan;

  /// No description provided for @quranAyahNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Ayah {number}'**
  String quranAyahNumberLabel(int number);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
