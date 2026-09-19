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

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// No description provided for @navTasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get navTasbih;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum'**
  String get greeting;

  /// No description provided for @nextPrayerOverline.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayerOverline;

  /// No description provided for @currentWindowOverline.
  ///
  /// In en, this message translates to:
  /// **'{prayer} is in now'**
  String currentWindowOverline(Object prayer);

  /// No description provided for @windowStartsWithJamaat.
  ///
  /// In en, this message translates to:
  /// **'Starts {start} · Jamaat {jamaat}'**
  String windowStartsWithJamaat(Object start, Object jamaat);

  /// No description provided for @windowStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Starts {start}'**
  String windowStartsAt(Object start);

  /// No description provided for @nextPrayerStartsIn.
  ///
  /// In en, this message translates to:
  /// **'{prayer} starts in {remaining}'**
  String nextPrayerStartsIn(Object prayer, Object remaining);

  /// No description provided for @locationUnknown.
  ///
  /// In en, this message translates to:
  /// **'Choose location'**
  String get locationUnknown;

  /// No description provided for @notificationsSemantic.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSemantic;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @hijriLabel.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get hijriLabel;

  /// No description provided for @todaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prayers'**
  String get todaysPrayers;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDays(Object count);

  /// No description provided for @streakNone.
  ///
  /// In en, this message translates to:
  /// **'Start a streak'**
  String get streakNone;

  /// No description provided for @continueReadingOverline.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReadingOverline;

  /// No description provided for @readingProgressLine.
  ///
  /// In en, this message translates to:
  /// **'Ayah {ayah} · {percent} of today\'s goal'**
  String readingProgressLine(Object ayah, Object percent);

  /// No description provided for @readingNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get readingNotStarted;

  /// No description provided for @quickAccessOverline.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccessOverline;

  /// No description provided for @tileQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get tileQibla;

  /// No description provided for @tileMasjid.
  ///
  /// In en, this message translates to:
  /// **'Masjid'**
  String get tileMasjid;

  /// No description provided for @tileDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get tileDua;

  /// No description provided for @tileZakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get tileZakat;

  /// No description provided for @tileHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get tileHadith;

  /// No description provided for @tileCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tileCalendar;

  /// No description provided for @tileRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get tileRamadan;

  /// No description provided for @tileNames99.
  ///
  /// In en, this message translates to:
  /// **'99 Names'**
  String get tileNames99;

  /// No description provided for @tileWidget.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get tileWidget;

  /// No description provided for @iftarDua.
  ///
  /// In en, this message translates to:
  /// **'Iftar dua'**
  String get iftarDua;

  /// No description provided for @comingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'This is coming soon.'**
  String get comingSoonBody;

  /// No description provided for @prayerScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get prayerScreenTitle;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today · {weekday}'**
  String dateToday(Object weekday);

  /// No description provided for @remainingOverline.
  ///
  /// In en, this message translates to:
  /// **'{prayer} in'**
  String remainingOverline(Object prayer);

  /// No description provided for @jamaatAndEnd.
  ///
  /// In en, this message translates to:
  /// **'Jamaat {jamaat} · ends {end}'**
  String jamaatAndEnd(Object jamaat, Object end);

  /// No description provided for @jamaatOnly.
  ///
  /// In en, this message translates to:
  /// **'Jamaat {jamaat}'**
  String jamaatOnly(Object jamaat);

  /// No description provided for @endsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends {end}'**
  String endsAt(Object end);

  /// No description provided for @nextWindowWithJamaat.
  ///
  /// In en, this message translates to:
  /// **'Next · jamaat {jamaat}'**
  String nextWindowWithJamaat(Object jamaat);

  /// No description provided for @nextWindow.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get nextWindow;

  /// No description provided for @runningNow.
  ///
  /// In en, this message translates to:
  /// **'In now'**
  String get runningNow;

  /// No description provided for @jamaatUnknown.
  ///
  /// In en, this message translates to:
  /// **'Jamaat time not set'**
  String get jamaatUnknown;

  /// No description provided for @monthTracker.
  ///
  /// In en, this message translates to:
  /// **'{month} tracker'**
  String monthTracker(Object month);

  /// No description provided for @legendAllFive.
  ///
  /// In en, this message translates to:
  /// **'All five'**
  String get legendAllFive;

  /// No description provided for @legendPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get legendPartial;

  /// No description provided for @legendPending.
  ///
  /// In en, this message translates to:
  /// **'Ahead'**
  String get legendPending;

  /// No description provided for @calculationAndOffsets.
  ///
  /// In en, this message translates to:
  /// **'Calculation & adjustments'**
  String get calculationAndOffsets;

  /// No description provided for @adhanAndReminders.
  ///
  /// In en, this message translates to:
  /// **'Adhan & reminders'**
  String get adhanAndReminders;

  /// No description provided for @madhabOverline.
  ///
  /// In en, this message translates to:
  /// **'Madhab'**
  String get madhabOverline;

  /// No description provided for @hanafiAsr.
  ///
  /// In en, this message translates to:
  /// **'Hanafi — later Asr'**
  String get hanafiAsr;

  /// No description provided for @offsetsOverline.
  ///
  /// In en, this message translates to:
  /// **'Minute adjustments'**
  String get offsetsOverline;

  /// No description provided for @offsetsExplainer.
  ///
  /// In en, this message translates to:
  /// **'Nudge each window a few minutes to match your local masjid.'**
  String get offsetsExplainer;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesValue(Object minutes);

  /// No description provided for @jamaatOverline.
  ///
  /// In en, this message translates to:
  /// **'Jamaat times'**
  String get jamaatOverline;

  /// No description provided for @jamaatExplainer.
  ///
  /// In en, this message translates to:
  /// **'Jamaat times differ by masjid — set the ones you attend.'**
  String get jamaatExplainer;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @clearValue.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearValue;

  /// No description provided for @perPrayerOverline.
  ///
  /// In en, this message translates to:
  /// **'For each prayer'**
  String get perPrayerOverline;

  /// No description provided for @otherRemindersOverline.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherRemindersOverline;

  /// No description provided for @reminderJumua.
  ///
  /// In en, this message translates to:
  /// **'Jumu\'ah reminder'**
  String get reminderJumua;

  /// No description provided for @reminderTahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud call'**
  String get reminderTahajjud;

  /// No description provided for @reminderDailyHadith.
  ///
  /// In en, this message translates to:
  /// **'Daily hadith notification'**
  String get reminderDailyHadith;

  /// No description provided for @testAdhanSound.
  ///
  /// In en, this message translates to:
  /// **'Test the adhan sound'**
  String get testAdhanSound;

  /// No description provided for @adhanModeAdhan.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get adhanModeAdhan;

  /// No description provided for @adhanModeSilent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get adhanModeSilent;

  /// No description provided for @adhanModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get adhanModeOff;

  /// No description provided for @adhanModeSilentLong.
  ///
  /// In en, this message translates to:
  /// **'Silent notification'**
  String get adhanModeSilentLong;

  /// No description provided for @adhanModeOffLong.
  ///
  /// In en, this message translates to:
  /// **'Turned off'**
  String get adhanModeOffLong;

  /// No description provided for @adhanSoundDefault.
  ///
  /// In en, this message translates to:
  /// **'Device sound'**
  String get adhanSoundDefault;

  /// No description provided for @adhanSoundMakkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah adhan'**
  String get adhanSoundMakkah;

  /// No description provided for @adhanSoundMadinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah adhan'**
  String get adhanSoundMadinah;

  /// No description provided for @adhanSoundMishary.
  ///
  /// In en, this message translates to:
  /// **'Mishary Rashid'**
  String get adhanSoundMishary;

  /// No description provided for @adhanSoundOverline.
  ///
  /// In en, this message translates to:
  /// **'Adhan sound'**
  String get adhanSoundOverline;

  /// No description provided for @adhanModeOverline.
  ///
  /// In en, this message translates to:
  /// **'How to notify'**
  String get adhanModeOverline;

  /// No description provided for @preOffsetOverline.
  ///
  /// In en, this message translates to:
  /// **'How early'**
  String get preOffsetOverline;

  /// No description provided for @preOffsetOnTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get preOffsetOnTime;

  /// No description provided for @preOffsetMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min early'**
  String preOffsetMinutes(Object minutes);

  /// No description provided for @adhanSummaryWithOffset.
  ///
  /// In en, this message translates to:
  /// **'{sound} · {minutes} min early'**
  String adhanSummaryWithOffset(Object sound, Object minutes);

  /// No description provided for @exactAlarmOkTitle.
  ///
  /// In en, this message translates to:
  /// **'Allowed to ring on time'**
  String get exactAlarmOkTitle;

  /// No description provided for @exactAlarmOkBody.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms and battery exemption are both on.'**
  String get exactAlarmOkBody;

  /// No description provided for @exactAlarmWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'To hear the adhan on time'**
  String get exactAlarmWarnTitle;

  /// No description provided for @exactAlarmWarnBody.
  ///
  /// In en, this message translates to:
  /// **'Exclude the app from battery saver, or the adhan may ring late.'**
  String get exactAlarmWarnBody;

  /// No description provided for @notificationsBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked, so no adhan will ring.'**
  String get notificationsBlockedBody;

  /// No description provided for @exactAlarmBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms are off, so the adhan may ring a few minutes late.'**
  String get exactAlarmBlockedBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @onboardingTagline.
  ///
  /// In en, this message translates to:
  /// **'Prayer, Quran and daily dhikr —\nall in one place.'**
  String get onboardingTagline;

  /// No description provided for @onboardingLanguageOverline.
  ///
  /// In en, this message translates to:
  /// **'Choose a language · ভাষা'**
  String get onboardingLanguageOverline;

  /// No description provided for @onboardingLanguageNote.
  ///
  /// In en, this message translates to:
  /// **'You can change this any time from More → Language. Arabic and translation fonts are set separately.'**
  String get onboardingLanguageNote;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String onboardingStep(Object current, Object total);

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate times\nneed your location'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Prayer times come from the sun where you are. Your location stays on your phone and is never sent anywhere.'**
  String get onboardingLocationBody;

  /// No description provided for @onboardingReasonTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer windows and countdowns to the minute'**
  String get onboardingReasonTimes;

  /// No description provided for @onboardingReasonQibla.
  ///
  /// In en, this message translates to:
  /// **'An accurate Qibla direction'**
  String get onboardingReasonQibla;

  /// No description provided for @onboardingReasonMasjid.
  ///
  /// In en, this message translates to:
  /// **'Nearby masjids and their jamaat times'**
  String get onboardingReasonMasjid;

  /// No description provided for @onboardingAllowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get onboardingAllowLocation;

  /// No description provided for @onboardingPickCity.
  ///
  /// In en, this message translates to:
  /// **'Pick a city yourself'**
  String get onboardingPickCity;

  /// No description provided for @onboardingCityHint.
  ///
  /// In en, this message translates to:
  /// **'Dhaka, Chattogram…'**
  String get onboardingCityHint;

  /// No description provided for @onboardingCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a city'**
  String get onboardingCityTitle;

  /// No description provided for @onboardingRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Which prayers should\nwe remind you about?'**
  String get onboardingRemindersTitle;

  /// No description provided for @onboardingRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Choose adhan, silent or off for each prayer separately.'**
  String get onboardingRemindersBody;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onboardingFinish;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @settingsOverline.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsOverline;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @settingLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get settingLocation;

  /// No description provided for @settingCalculation.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get settingCalculation;

  /// No description provided for @settingFonts.
  ///
  /// In en, this message translates to:
  /// **'Fonts & reading'**
  String get settingFonts;

  /// No description provided for @settingNightMode.
  ///
  /// In en, this message translates to:
  /// **'Night mode'**
  String get settingNightMode;

  /// No description provided for @settingOfflineDownloads.
  ///
  /// In en, this message translates to:
  /// **'Offline downloads'**
  String get settingOfflineDownloads;

  /// No description provided for @settingAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingAbout;

  /// No description provided for @nightModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get nightModeAuto;

  /// No description provided for @megabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String megabytes(Object size);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @locationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get locationDeniedTitle;

  /// No description provided for @locationDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Showing Dhaka\'s times without location permission. Pick your city or allow location.'**
  String get locationDeniedBody;

  /// No description provided for @methodKarachiShort.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get methodKarachiShort;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @copyHadith.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyHadith;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copiedToClipboard;

  /// No description provided for @hadithCollectionsOverline.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get hadithCollectionsOverline;

  /// No description provided for @hadithCollectionMeta.
  ///
  /// In en, this message translates to:
  /// **'{chapters} chapters · {hadiths} hadiths'**
  String hadithCollectionMeta(Object chapters, Object hadiths);

  /// No description provided for @hadithChapterMeta.
  ///
  /// In en, this message translates to:
  /// **'{count} hadiths'**
  String hadithChapterMeta(Object count);

  /// No description provided for @hadithCuratedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with {count} selected hadiths'**
  String hadithCuratedSubtitle(Object count);

  /// No description provided for @hadithStartHere.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get hadithStartHere;

  /// No description provided for @hadithSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search hadith'**
  String get hadithSearchTitle;

  /// No description provided for @hadithSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search in Bangla'**
  String get hadithSearchHint;

  /// No description provided for @hadithSearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type a topic in Bangla — prayer, fasting, charity.'**
  String get hadithSearchPrompt;

  /// No description provided for @hadithSearchCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hadiths found'**
  String hadithSearchCount(Object count);

  /// No description provided for @hadithBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved hadiths'**
  String get hadithBookmarksTitle;

  /// No description provided for @hadithNoBookmarks.
  ///
  /// In en, this message translates to:
  /// **'You have not saved any hadith yet.'**
  String get hadithNoBookmarks;

  /// No description provided for @hadithBrowseCollections.
  ///
  /// In en, this message translates to:
  /// **'Browse collections'**
  String get hadithBrowseCollections;

  /// No description provided for @hadithPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing the hadith collection — this takes a moment the first time.'**
  String get hadithPreparing;

  /// No description provided for @hadithLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not open the hadith collection'**
  String get hadithLoadFailedTitle;

  /// No description provided for @hadithLoadFailedBody.
  ///
  /// In en, this message translates to:
  /// **'This can happen when storage is low. Free some space and try again.'**
  String get hadithLoadFailedBody;

  /// No description provided for @hadithAttribution.
  ///
  /// In en, this message translates to:
  /// **'Translations and gradings come from open hadith datasets. Tell us if you spot an error.'**
  String get hadithAttribution;

  /// No description provided for @tasbihTimes.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String tasbihTimes(Object count);

  /// No description provided for @tasbihCountAction.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get tasbihCountAction;

  /// No description provided for @tasbihTodayTotal.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasbihTodayTotal;

  /// No description provided for @tasbihRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get tasbihRounds;

  /// No description provided for @tasbihStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get tasbihStreak;

  /// No description provided for @tasbihReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasbihReset;

  /// No description provided for @tasbihResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the count?'**
  String get tasbihResetTitle;

  /// No description provided for @tasbihResetBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s count for this dhikr will be cleared. Earlier days are kept.'**
  String get tasbihResetBody;

  /// No description provided for @tasbihSetGoal.
  ///
  /// In en, this message translates to:
  /// **'Set a goal'**
  String get tasbihSetGoal;

  /// No description provided for @tasbihHaptics.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get tasbihHaptics;

  /// No description provided for @tasbihHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhikr history'**
  String get tasbihHistoryTitle;

  /// No description provided for @tasbihLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get tasbihLast30Days;

  /// No description provided for @tasbihDaysCounted.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get tasbihDaysCounted;

  /// No description provided for @tasbihTotalCounted.
  ///
  /// In en, this message translates to:
  /// **'Total dhikr'**
  String get tasbihTotalCounted;

  /// No description provided for @tasbihNoHistory.
  ///
  /// In en, this message translates to:
  /// **'You have not counted any dhikr yet.'**
  String get tasbihNoHistory;

  /// No description provided for @tasbihStartCounting.
  ///
  /// In en, this message translates to:
  /// **'Start counting'**
  String get tasbihStartCounting;

  /// No description provided for @tasbihOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{done} / {target}'**
  String tasbihOfTarget(Object done, Object target);

  /// No description provided for @qiblaRecalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get qiblaRecalibrate;

  /// No description provided for @qiblaAligned.
  ///
  /// In en, this message translates to:
  /// **'Straight ahead — facing the qibla'**
  String get qiblaAligned;

  /// No description provided for @qiblaTurnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn {degrees}° left'**
  String qiblaTurnLeft(Object degrees);

  /// No description provided for @qiblaTurnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn {degrees}° right'**
  String qiblaTurnRight(Object degrees);

  /// No description provided for @qiblaDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance to Makkah'**
  String get qiblaDistanceLabel;

  /// No description provided for @qiblaKilometres.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String qiblaKilometres(Object value);

  /// No description provided for @qiblaAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get qiblaAccuracyLabel;

  /// No description provided for @qiblaAccuracyHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get qiblaAccuracyHigh;

  /// No description provided for @qiblaAccuracyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get qiblaAccuracyMedium;

  /// No description provided for @qiblaAccuracyLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get qiblaAccuracyLow;

  /// No description provided for @qiblaAccuracyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get qiblaAccuracyUnknown;

  /// No description provided for @qiblaCalibrationHint.
  ///
  /// In en, this message translates to:
  /// **'Compass accuracy is low. Move the phone in a figure-8 a few times and stay clear of metal.'**
  String get qiblaCalibrationHint;

  /// No description provided for @qiblaLocationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn them on to find the qibla.'**
  String get qiblaLocationServiceOff;

  /// No description provided for @qiblaLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'The qibla direction needs location permission.'**
  String get qiblaLocationDenied;

  /// No description provided for @qiblaCompassUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No compass was found on this phone.'**
  String get qiblaCompassUnavailable;

  /// No description provided for @masjidKeyMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Map is not set up'**
  String get masjidKeyMissingTitle;

  /// No description provided for @masjidLocationNeeded.
  ///
  /// In en, this message translates to:
  /// **'Finding nearby masjids needs location permission.'**
  String get masjidLocationNeeded;

  /// No description provided for @masjidCountWithin.
  ///
  /// In en, this message translates to:
  /// **'{count} masjids within {radius} km'**
  String masjidCountWithin(Object count, Object radius);

  /// No description provided for @masjidWalkMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk'**
  String masjidWalkMinutes(Object minutes);

  /// No description provided for @masjidStraightLine.
  ///
  /// In en, this message translates to:
  /// **'{metres} m as the crow flies'**
  String masjidStraightLine(Object metres);

  /// No description provided for @masjidSortDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get masjidSortDistance;

  /// No description provided for @masjidSortJamaat.
  ///
  /// In en, this message translates to:
  /// **'Jamaat time'**
  String get masjidSortJamaat;

  /// No description provided for @masjidSortJumua.
  ///
  /// In en, this message translates to:
  /// **'Jumu\'ah'**
  String get masjidSortJumua;

  /// No description provided for @masjidShowRoute.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get masjidShowRoute;

  /// No description provided for @masjidSetJamaat.
  ///
  /// In en, this message translates to:
  /// **'Set times'**
  String get masjidSetJamaat;

  /// No description provided for @masjidAddJamaatPrompt.
  ///
  /// In en, this message translates to:
  /// **'Know the times? Add them'**
  String get masjidAddJamaatPrompt;

  /// No description provided for @masjidJamaatExplainer.
  ///
  /// In en, this message translates to:
  /// **'Jamaat times differ by masjid. Add the ones you know — you will be the one using them.'**
  String get masjidJamaatExplainer;

  /// No description provided for @quranBookmarkTab.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get quranBookmarkTab;

  /// No description provided for @quranNoBookmarks.
  ///
  /// In en, this message translates to:
  /// **'You have not saved any ayah yet.'**
  String get quranNoBookmarks;

  /// No description provided for @quranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Surah name or number'**
  String get quranSearchHint;

  /// No description provided for @quranAyahCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ayahs'**
  String quranAyahCount(Object count);

  /// No description provided for @quranPlayingNow.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get quranPlayingNow;

  /// No description provided for @quranTypeSettings.
  ///
  /// In en, this message translates to:
  /// **'Text settings'**
  String get quranTypeSettings;

  /// No description provided for @quranArabicSize.
  ///
  /// In en, this message translates to:
  /// **'Arabic size'**
  String get quranArabicSize;

  /// No description provided for @quranTranslationSize.
  ///
  /// In en, this message translates to:
  /// **'Translation size'**
  String get quranTranslationSize;

  /// No description provided for @quranShowTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show translation'**
  String get quranShowTranslation;

  /// No description provided for @quranAddBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get quranAddBookmark;

  /// No description provided for @quranRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get quranRemoveBookmark;

  /// No description provided for @quranWriteNote.
  ///
  /// In en, this message translates to:
  /// **'Write a note'**
  String get quranWriteNote;

  /// No description provided for @quranEditNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get quranEditNote;

  /// No description provided for @quranPlayFromHere.
  ///
  /// In en, this message translates to:
  /// **'Play from here'**
  String get quranPlayFromHere;

  /// No description provided for @quranCopyAyah.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get quranCopyAyah;

  /// No description provided for @quranNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Your note about this ayah…'**
  String get quranNoteHint;

  /// No description provided for @quranSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get quranSaveNote;

  /// No description provided for @quranPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reading plan'**
  String get quranPlanTitle;

  /// No description provided for @quranTodaysGoal.
  ///
  /// In en, this message translates to:
  /// **'Today\'s goal'**
  String get quranTodaysGoal;

  /// No description provided for @quranAyahUnit.
  ///
  /// In en, this message translates to:
  /// **'ayahs'**
  String get quranAyahUnit;

  /// No description provided for @quranMinutesUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get quranMinutesUnit;

  /// No description provided for @quranNoPlanYet.
  ///
  /// In en, this message translates to:
  /// **'No plan yet'**
  String get quranNoPlanYet;

  /// No description provided for @quranPickAPlanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan below.'**
  String get quranPickAPlanPrompt;

  /// No description provided for @quranGoalDone.
  ///
  /// In en, this message translates to:
  /// **'Today\'s goal is done — alhamdulillah.'**
  String get quranGoalDone;

  /// No description provided for @quranRemainingToday.
  ///
  /// In en, this message translates to:
  /// **'{ayahs} ayahs left — about {minutes} min'**
  String quranRemainingToday(Object ayahs, Object minutes);

  /// No description provided for @quranLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get quranLast30Days;

  /// No description provided for @quranChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get quranChoosePlan;

  /// No description provided for @quranStartTodaysReading.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s reading'**
  String get quranStartTodaysReading;

  /// No description provided for @quranPlanProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {target} ayahs of today\'s goal'**
  String quranPlanProgress(Object done, Object target);

  /// No description provided for @quranPlanMinutesProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {target} min read today'**
  String quranPlanMinutesProgress(Object done, Object target);

  /// No description provided for @quranPlanAyahs.
  ///
  /// In en, this message translates to:
  /// **'{count} ayahs a day'**
  String quranPlanAyahs(Object count);

  /// No description provided for @quranPlanAyahsDetail.
  ///
  /// In en, this message translates to:
  /// **'A khatm in about {months} months'**
  String quranPlanAyahsDetail(Object months);

  /// No description provided for @quranPlanPara.
  ///
  /// In en, this message translates to:
  /// **'{count} para a day'**
  String quranPlanPara(Object count);

  /// No description provided for @quranPlanParaDetail.
  ///
  /// In en, this message translates to:
  /// **'A khatm in Ramadan — 30 days'**
  String get quranPlanParaDetail;

  /// No description provided for @quranPlanMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min a day'**
  String quranPlanMinutes(Object count);

  /// No description provided for @quranPlanMinutesDetail.
  ///
  /// In en, this message translates to:
  /// **'Measured in time, not ayahs'**
  String get quranPlanMinutesDetail;

  /// No description provided for @quranPlanWeekly.
  ///
  /// In en, this message translates to:
  /// **'Surah al-Kahf on Fridays'**
  String get quranPlanWeekly;

  /// No description provided for @quranPlanWeeklyDetail.
  ///
  /// In en, this message translates to:
  /// **'A weekly habit'**
  String get quranPlanWeeklyDetail;

  /// No description provided for @duaFeaturedOverline.
  ///
  /// In en, this message translates to:
  /// **'Dua of the day'**
  String get duaFeaturedOverline;

  /// No description provided for @duaRightNowOverline.
  ///
  /// In en, this message translates to:
  /// **'Useful right now'**
  String get duaRightNowOverline;

  /// No description provided for @duaCategoriesOverline.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get duaCategoriesOverline;

  /// No description provided for @duaCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String duaCount(Object count);

  /// No description provided for @duaAttribution.
  ///
  /// In en, this message translates to:
  /// **'Every dua comes from the supplication chapters of Bukhari, Muslim, Ibn Majah and an-Nasa\'i, with its source shown.'**
  String get duaAttribution;

  /// No description provided for @ramadanUntilIftar.
  ///
  /// In en, this message translates to:
  /// **'Until iftar'**
  String get ramadanUntilIftar;

  /// No description provided for @ramadanUntilSehri.
  ///
  /// In en, this message translates to:
  /// **'Until sehri ends'**
  String get ramadanUntilSehri;

  /// No description provided for @ramadanCountdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day} · {subject}'**
  String ramadanCountdownLabel(Object day, Object subject);

  /// No description provided for @ramadanRozaTracker.
  ///
  /// In en, this message translates to:
  /// **'Fast tracker'**
  String get ramadanRozaTracker;

  /// No description provided for @ramadanKeptRatio.
  ///
  /// In en, this message translates to:
  /// **'{kept} / {total} kept'**
  String ramadanKeptRatio(Object kept, Object total);

  /// No description provided for @ramadanKept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get ramadanKept;

  /// No description provided for @ramadanMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get ramadanMissed;

  /// No description provided for @ramadanTaraweeh.
  ///
  /// In en, this message translates to:
  /// **'Taraweeh'**
  String get ramadanTaraweeh;

  /// No description provided for @ramadanTaraweehDone.
  ///
  /// In en, this message translates to:
  /// **'{rakats} rakats today · {streak} day streak'**
  String ramadanTaraweehDone(Object rakats, Object streak);

  /// No description provided for @ramadanTaraweehPending.
  ///
  /// In en, this message translates to:
  /// **'Not prayed yet today'**
  String get ramadanTaraweehPending;

  /// No description provided for @ramadanKhatmProgress.
  ///
  /// In en, this message translates to:
  /// **'Khatm progress'**
  String get ramadanKhatmProgress;

  /// No description provided for @ramadanFitraZakat.
  ///
  /// In en, this message translates to:
  /// **'Fitra & zakat'**
  String get ramadanFitraZakat;

  /// No description provided for @ramadanShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get ramadanShare;

  /// No description provided for @ramadanShareSchedule.
  ///
  /// In en, this message translates to:
  /// **'Share the Ramadan schedule'**
  String get ramadanShareSchedule;

  /// No description provided for @zakatAssetsOverline.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get zakatAssetsOverline;

  /// No description provided for @zakatDeductionsOverline.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get zakatDeductionsOverline;

  /// No description provided for @zakatCash.
  ///
  /// In en, this message translates to:
  /// **'Cash & bank'**
  String get zakatCash;

  /// No description provided for @zakatGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get zakatGold;

  /// No description provided for @zakatSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get zakatSilver;

  /// No description provided for @zakatBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business stock'**
  String get zakatBusiness;

  /// No description provided for @zakatInvestments.
  ///
  /// In en, this message translates to:
  /// **'Investments & shares'**
  String get zakatInvestments;

  /// No description provided for @zakatDebts.
  ///
  /// In en, this message translates to:
  /// **'Debts owed'**
  String get zakatDebts;

  /// No description provided for @zakatExpenses.
  ///
  /// In en, this message translates to:
  /// **'Pending expenses'**
  String get zakatExpenses;

  /// No description provided for @zakatAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add another category'**
  String get zakatAddCategory;

  /// No description provided for @zakatRemoveCategory.
  ///
  /// In en, this message translates to:
  /// **'Remove this category'**
  String get zakatRemoveCategory;

  /// No description provided for @zakatCategoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get zakatCategoryNameHint;

  /// No description provided for @zakatBhori.
  ///
  /// In en, this message translates to:
  /// **'{value} bhori'**
  String zakatBhori(Object value);

  /// No description provided for @zakatBhoriUnit.
  ///
  /// In en, this message translates to:
  /// **'bhori'**
  String get zakatBhoriUnit;

  /// No description provided for @zakatEnterBhori.
  ///
  /// In en, this message translates to:
  /// **'Enter the weight in bhori'**
  String get zakatEnterBhori;

  /// No description provided for @zakatEnterTaka.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount in taka'**
  String get zakatEnterTaka;

  /// No description provided for @zakatRatePerBhori.
  ///
  /// In en, this message translates to:
  /// **'Today\'s rate · {rate} per bhori'**
  String zakatRatePerBhori(Object rate);

  /// No description provided for @zakatSaveAmount.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get zakatSaveAmount;

  /// No description provided for @zakatNisabGold.
  ///
  /// In en, this message translates to:
  /// **'Nisab (gold)'**
  String get zakatNisabGold;

  /// No description provided for @zakatNisabSilver.
  ///
  /// In en, this message translates to:
  /// **'Nisab (silver)'**
  String get zakatNisabSilver;

  /// No description provided for @zakatGoldPerBhori.
  ///
  /// In en, this message translates to:
  /// **'Gold / bhori'**
  String get zakatGoldPerBhori;

  /// No description provided for @zakatSilverPerBhori.
  ///
  /// In en, this message translates to:
  /// **'Silver / bhori'**
  String get zakatSilverPerBhori;

  /// No description provided for @zakatUseGoldNisab.
  ///
  /// In en, this message translates to:
  /// **'Use the gold nisab'**
  String get zakatUseGoldNisab;

  /// No description provided for @zakatNisabExplainer.
  ///
  /// In en, this message translates to:
  /// **'The silver nisab is lower, so more people qualify — it is the cautious default.'**
  String get zakatNisabExplainer;

  /// No description provided for @zakatTotalWealth.
  ///
  /// In en, this message translates to:
  /// **'Zakatable wealth'**
  String get zakatTotalWealth;

  /// No description provided for @zakatPayableOverline.
  ///
  /// In en, this message translates to:
  /// **'Zakat payable · 2.5%'**
  String get zakatPayableOverline;

  /// No description provided for @zakatBelowNisab.
  ///
  /// In en, this message translates to:
  /// **'Below nisab — zakat is not due'**
  String get zakatBelowNisab;

  /// No description provided for @zakatHelp.
  ///
  /// In en, this message translates to:
  /// **'About zakat'**
  String get zakatHelp;

  /// No description provided for @zakatHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Zakat is 2.5% of wealth held above nisab for a lunar year. Metal rates change daily, so check them before calculating. This is a helper, not a fatwa — ask a scholar for complex cases.'**
  String get zakatHelpBody;

  /// No description provided for @zakatRatesUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Rates unavailable'**
  String get zakatRatesUnavailableTitle;

  /// No description provided for @zakatRatesUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch today\'s metal rates, so nisab cannot be calculated. Check your connection and try again.'**
  String get zakatRatesUnavailableBody;

  /// No description provided for @calendarEventsOverline.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get calendarEventsOverline;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No special days this month.'**
  String get calendarNoEvents;

  /// No description provided for @calendarAdjustTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust the Hijri date'**
  String get calendarAdjustTitle;

  /// No description provided for @calendarAdjustBody.
  ///
  /// In en, this message translates to:
  /// **'The calculated date can differ by a day from the moon sighting announcement. Match it here.'**
  String get calendarAdjustBody;

  /// No description provided for @calendarOffsetMinus.
  ///
  /// In en, this message translates to:
  /// **'One day earlier'**
  String get calendarOffsetMinus;

  /// No description provided for @calendarOffsetNone.
  ///
  /// In en, this message translates to:
  /// **'As calculated'**
  String get calendarOffsetNone;

  /// No description provided for @calendarOffsetPlus.
  ///
  /// In en, this message translates to:
  /// **'One day later'**
  String get calendarOffsetPlus;

  /// No description provided for @calendarMawlid.
  ///
  /// In en, this message translates to:
  /// **'Mawlid an-Nabi'**
  String get calendarMawlid;

  /// No description provided for @calendarShabeMeraj.
  ///
  /// In en, this message translates to:
  /// **'Shab-e-Mi\'raj'**
  String get calendarShabeMeraj;

  /// No description provided for @calendarShabeBarat.
  ///
  /// In en, this message translates to:
  /// **'Shab-e-Barat'**
  String get calendarShabeBarat;

  /// No description provided for @calendarArafah.
  ///
  /// In en, this message translates to:
  /// **'Day of Arafah'**
  String get calendarArafah;
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
