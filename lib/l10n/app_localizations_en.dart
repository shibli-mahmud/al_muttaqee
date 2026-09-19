// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get quran => 'Quran';

  @override
  String get qibla => 'Qibla';

  @override
  String get tasbih => 'Tasbih';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get bangla => 'Bangla';

  @override
  String get preparingQiblaCompass => 'Preparing Qibla compass...';

  @override
  String get locationAccessRequired => 'Location access required';

  @override
  String get locationAccessMessage => 'Please enable location services and grant permission so we can calculate the direction of Qibla from your current position.';

  @override
  String get compassCalibrationMessage => 'Compass needs calibration. Move your device in the figure-8 pattern below to improve accuracy.';

  @override
  String get moveDeviceLikeThis => 'Move device like this';

  @override
  String get qiblaDirection => 'Qibla Direction';

  @override
  String get qiblaDirectionHint => 'Point the arrow towards the top of your device to face Qibla.';

  @override
  String qiblaHeadingFormat(Object qibla, Object heading) {
    return 'Qibla: $qibla°  |  Heading: $heading°';
  }

  @override
  String get deviceLevelMessage => 'Device is level — center the bubble in the circle';

  @override
  String tiltMessage(Object tilt) {
    return 'Tilt: $tilt° — center the bubble to level the device';
  }

  @override
  String get levelIndicator => 'Level indicator (center bubble)';

  @override
  String get tasbihTapToCount => 'Tap the circle to count';

  @override
  String get tasbihSwipeHorizontal => 'Swipe left → right to count';

  @override
  String get tasbihSwipeVertical => 'Swipe up ↑ to count';

  @override
  String get tasbihOrientationLeftRight => 'Left–Right';

  @override
  String get tasbihOrientationUpDown => 'Up–Down';

  @override
  String get tasbihResetRound => 'Reset round';

  @override
  String get tasbihResetAll => 'Reset all';

  @override
  String tasbihRoundsTotal(Object rounds, Object total) {
    return '$rounds round(s) • $total total';
  }

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get preparingPrayerTimes => 'Calculating prayer times...';

  @override
  String get prayerTimesLoadError => 'Could not load prayer times.';

  @override
  String get prayerTimesLocationFallback => 'Using default location (Dhaka). Grant location for accurate times.';

  @override
  String get nextPrayer => 'Next prayer';

  @override
  String get currentPrayer => 'Current prayer';

  @override
  String get timeRemaining => 'Time remaining';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerSettings => 'Prayer settings';

  @override
  String get calculationMethod => 'Calculation method';

  @override
  String get hanafiMadhab => 'Hanafi madhab (later Asr)';

  @override
  String get manualOffsets => 'Manual offsets (minutes)';

  @override
  String get methodKarachi => 'Karachi (University of Islamic Sciences)';

  @override
  String get methodMwl => 'Muslim World League';

  @override
  String get methodEgyptian => 'Egyptian General Authority';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodNorthAmerica => 'ISNA (North America)';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodSingapore => 'Singapore';

  @override
  String get methodTurkiye => 'Türkiye (Diyanet)';

  @override
  String get hadithOfTheDay => 'Hadith of the Day';

  @override
  String get duaOfTheDay => 'Dua of the Day';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get continueReading => 'Continue Reading';

  @override
  String get masjidFinder => 'Masjid Finder';

  @override
  String get gregorianDate => 'Gregorian';

  @override
  String get hijriDate => 'Hijri';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get sources => 'Sources';

  @override
  String get search => 'Search';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get bookmarked => 'Bookmarked';

  @override
  String get hadith => 'Hadith';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get calendar => 'Calendar';

  @override
  String get zakat => 'Zakat';

  @override
  String get supportApp => 'Support this app';

  @override
  String get proUnlock => 'Unlock Pro';

  @override
  String get offlineDownload => 'Download for offline';

  @override
  String get reciter => 'Reciter';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get repeatAyah => 'Repeat ayah';

  @override
  String get repeatSurah => 'Repeat surah';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String distanceKm(Object distance) {
    return '$distance km';
  }

  @override
  String get sehriEnds => 'Sehri ends';

  @override
  String get iftar => 'Iftar';

  @override
  String ratesLastUpdated(Object date) {
    return 'Rates last updated: $date';
  }

  @override
  String get zakatDue => 'Zakat due';

  @override
  String get nisabThreshold => 'Nisab threshold';

  @override
  String get permissionRationaleLocation => 'Location is used for Qibla, prayer times, and finding nearby mosques.';

  @override
  String get permissionRationaleNotifications => 'Notifications remind you of prayer times and daily duas.';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get salatAlerts => 'Prayer alerts';

  @override
  String get duaReminders => 'Dua reminders';

  @override
  String get globalNotifications => 'All notifications';

  @override
  String get narrator => 'Narrator';

  @override
  String get chapter => 'Chapter';

  @override
  String get noResults => 'No results found';

  @override
  String get hadithAllChapters => 'All chapters';

  @override
  String get hadithBukhari => 'Sahih al-Bukhari';

  @override
  String get hadithMuslim => 'Sahih Muslim';

  @override
  String get hadithAbuDaud => 'Sunan Abu Dawud';

  @override
  String get hadithIbnMajah => 'Sunan Ibn Majah';

  @override
  String get hadithTirmidhi => 'Jami` at-Tirmidhi';

  @override
  String get hadithSourcesAttribution => 'Islamic Foundation Bangladesh / alquranbd';

  @override
  String get ramadanMode => 'Ramadan mode';

  @override
  String get importantDates => 'Important dates';

  @override
  String get mapsApiKeyRequired => 'Add Google Maps and Places API keys to .env to show nearby mosques.';

  @override
  String get noNearbyMasjids => 'No nearby mosques found.';

  @override
  String get proBenefits => 'Support development with offline downloads for all reciters and full Hadith search and bookmarks. Quran text, Prayer Times, Qibla and Tasbih stay free.';

  @override
  String get proUnlocked => 'Pro unlocked';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get supportDescription => 'Make an optional Sadaqah contribution to support the app.';

  @override
  String get storeUnavailable => 'The store is unavailable. Try again in a configured test or production environment.';

  @override
  String get debugProUnlock => 'Debug Pro unlock';

  @override
  String get ashura => 'Ashura';

  @override
  String get ramadanStart => 'Ramadan begins';

  @override
  String get laylatulQadr => 'Estimated Laylatul Qadr night';

  @override
  String get eidAlFitr => 'Eid al-Fitr';

  @override
  String get eidAlAdha => 'Eid al-Adha';

  @override
  String get cash => 'Cash';

  @override
  String get goldGrams => 'Gold (grams)';

  @override
  String get silverGrams => 'Silver (grams)';

  @override
  String get businessAssets => 'Business assets';

  @override
  String get debtsOwedToYou => 'Debts owed to you';

  @override
  String get debtsYouOwe => 'Debts you owe';

  @override
  String get useGoldNisab => 'Use gold nisab (85g)';

  @override
  String get quranLastRead => 'Last read';

  @override
  String get quranNoLastReadYet => 'You have not started reading yet';

  @override
  String get quranStartReading => 'Start reading';

  @override
  String get quranContinueReading => 'Continue reading';

  @override
  String get quranSurahTab => 'Surah';

  @override
  String get quranParaTab => 'Para';

  @override
  String quranParaLabel(int number) {
    return 'Para $number';
  }

  @override
  String get quranRevelationMeccan => 'Meccan';

  @override
  String get quranRevelationMedinan => 'Medinan';

  @override
  String quranAyahNumberLabel(int number) {
    return 'Ayah $number';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navQuran => 'Quran';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navTasbih => 'Tasbih';

  @override
  String get navMore => 'More';

  @override
  String get greeting => 'Assalamu alaikum';

  @override
  String get nextPrayerOverline => 'Next prayer';

  @override
  String currentWindowOverline(Object prayer) {
    return '$prayer is in now';
  }

  @override
  String windowStartsWithJamaat(Object start, Object jamaat) {
    return 'Starts $start · Jamaat $jamaat';
  }

  @override
  String windowStartsAt(Object start) {
    return 'Starts $start';
  }

  @override
  String nextPrayerStartsIn(Object prayer, Object remaining) {
    return '$prayer starts in $remaining';
  }

  @override
  String get locationUnknown => 'Choose location';

  @override
  String get notificationsSemantic => 'Notifications';

  @override
  String get todayLabel => 'Today';

  @override
  String get hijriLabel => 'Hijri';

  @override
  String get todaysPrayers => 'Today\'s prayers';

  @override
  String streakDays(Object count) {
    return '$count day streak';
  }

  @override
  String get streakNone => 'Start a streak';

  @override
  String get continueReadingOverline => 'Continue reading';

  @override
  String readingProgressLine(Object ayah, Object percent) {
    return 'Ayah $ayah · $percent of today\'s goal';
  }

  @override
  String get readingNotStarted => 'Start reading';

  @override
  String get quickAccessOverline => 'Quick access';

  @override
  String get tileQibla => 'Qibla';

  @override
  String get tileMasjid => 'Masjid';

  @override
  String get tileDua => 'Dua';

  @override
  String get tileZakat => 'Zakat';

  @override
  String get tileHadith => 'Hadith';

  @override
  String get tileCalendar => 'Calendar';

  @override
  String get tileRamadan => 'Ramadan';

  @override
  String get tileNames99 => '99 Names';

  @override
  String get tileWidget => 'Widgets';

  @override
  String get iftarDua => 'Iftar dua';

  @override
  String get comingSoonBody => 'This is coming soon.';

  @override
  String get prayerScreenTitle => 'Prayer';

  @override
  String dateToday(Object weekday) {
    return 'Today · $weekday';
  }

  @override
  String remainingOverline(Object prayer) {
    return '$prayer in';
  }

  @override
  String jamaatAndEnd(Object jamaat, Object end) {
    return 'Jamaat $jamaat · ends $end';
  }

  @override
  String jamaatOnly(Object jamaat) {
    return 'Jamaat $jamaat';
  }

  @override
  String endsAt(Object end) {
    return 'Ends $end';
  }

  @override
  String nextWindowWithJamaat(Object jamaat) {
    return 'Next · jamaat $jamaat';
  }

  @override
  String get nextWindow => 'Next up';

  @override
  String get runningNow => 'In now';

  @override
  String get jamaatUnknown => 'Jamaat time not set';

  @override
  String monthTracker(Object month) {
    return '$month tracker';
  }

  @override
  String get legendAllFive => 'All five';

  @override
  String get legendPartial => 'Partial';

  @override
  String get legendPending => 'Ahead';

  @override
  String get calculationAndOffsets => 'Calculation & adjustments';

  @override
  String get adhanAndReminders => 'Adhan & reminders';

  @override
  String get madhabOverline => 'Madhab';

  @override
  String get hanafiAsr => 'Hanafi — later Asr';

  @override
  String get offsetsOverline => 'Minute adjustments';

  @override
  String get offsetsExplainer => 'Nudge each window a few minutes to match your local masjid.';

  @override
  String minutesValue(Object minutes) {
    return '$minutes min';
  }

  @override
  String get jamaatOverline => 'Jamaat times';

  @override
  String get jamaatExplainer => 'Jamaat times differ by masjid — set the ones you attend.';

  @override
  String get notSet => 'Not set';

  @override
  String get clearValue => 'Clear';

  @override
  String get perPrayerOverline => 'For each prayer';

  @override
  String get otherRemindersOverline => 'Other';

  @override
  String get reminderJumua => 'Jumu\'ah reminder';

  @override
  String get reminderTahajjud => 'Tahajjud call';

  @override
  String get reminderDailyHadith => 'Daily hadith notification';

  @override
  String get testAdhanSound => 'Test the adhan sound';

  @override
  String get adhanModeAdhan => 'Adhan';

  @override
  String get adhanModeSilent => 'Silent';

  @override
  String get adhanModeOff => 'Off';

  @override
  String get adhanModeSilentLong => 'Silent notification';

  @override
  String get adhanModeOffLong => 'Turned off';

  @override
  String get adhanSoundDefault => 'Device sound';

  @override
  String get adhanSoundMakkah => 'Makkah adhan';

  @override
  String get adhanSoundMadinah => 'Madinah adhan';

  @override
  String get adhanSoundMishary => 'Mishary Rashid';

  @override
  String get adhanSoundOverline => 'Adhan sound';

  @override
  String get adhanModeOverline => 'How to notify';

  @override
  String get preOffsetOverline => 'How early';

  @override
  String get preOffsetOnTime => 'On time';

  @override
  String preOffsetMinutes(Object minutes) {
    return '$minutes min early';
  }

  @override
  String adhanSummaryWithOffset(Object sound, Object minutes) {
    return '$sound · $minutes min early';
  }

  @override
  String get exactAlarmOkTitle => 'Allowed to ring on time';

  @override
  String get exactAlarmOkBody => 'Exact alarms and battery exemption are both on.';

  @override
  String get exactAlarmWarnTitle => 'To hear the adhan on time';

  @override
  String get exactAlarmWarnBody => 'Exclude the app from battery saver, or the adhan may ring late.';

  @override
  String get notificationsBlockedBody => 'Notifications are blocked, so no adhan will ring.';

  @override
  String get exactAlarmBlockedBody => 'Exact alarms are off, so the adhan may ring a few minutes late.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get onboardingTagline => 'Prayer, Quran and daily dhikr —\nall in one place.';

  @override
  String get onboardingLanguageOverline => 'Choose a language · ভাষা';

  @override
  String get onboardingLanguageNote => 'You can change this any time from More → Language. Arabic and translation fonts are set separately.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String onboardingStep(Object current, Object total) {
    return '$current / $total';
  }

  @override
  String get onboardingLocationTitle => 'Accurate times\nneed your location';

  @override
  String get onboardingLocationBody => 'Prayer times come from the sun where you are. Your location stays on your phone and is never sent anywhere.';

  @override
  String get onboardingReasonTimes => 'Prayer windows and countdowns to the minute';

  @override
  String get onboardingReasonQibla => 'An accurate Qibla direction';

  @override
  String get onboardingReasonMasjid => 'Nearby masjids and their jamaat times';

  @override
  String get onboardingAllowLocation => 'Allow location';

  @override
  String get onboardingPickCity => 'Pick a city yourself';

  @override
  String get onboardingCityHint => 'Dhaka, Chattogram…';

  @override
  String get onboardingCityTitle => 'Choose a city';

  @override
  String get onboardingRemindersTitle => 'Which prayers should\nwe remind you about?';

  @override
  String get onboardingRemindersBody => 'Choose adhan, silent or off for each prayer separately.';

  @override
  String get onboardingFinish => 'Finish';

  @override
  String get moreTitle => 'More';

  @override
  String get settingsOverline => 'Settings';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingLocation => 'Location';

  @override
  String get settingCalculation => 'Calculation method';

  @override
  String get settingFonts => 'Fonts & reading';

  @override
  String get settingNightMode => 'Night mode';

  @override
  String get settingOfflineDownloads => 'Offline downloads';

  @override
  String get settingAbout => 'About';

  @override
  String get nightModeAuto => 'Automatic';

  @override
  String megabytes(Object size) {
    return '$size MB';
  }

  @override
  String get retry => 'Try again';

  @override
  String get locationDeniedTitle => 'No location';

  @override
  String get locationDeniedBody => 'Showing Dhaka\'s times without location permission. Pick your city or allow location.';

  @override
  String get methodKarachiShort => 'Karachi';

  @override
  String get cancel => 'Cancel';

  @override
  String get copyHadith => 'Copy';

  @override
  String get copiedToClipboard => 'Copied';

  @override
  String get hadithCollectionsOverline => 'Collections';

  @override
  String hadithCollectionMeta(Object chapters, Object hadiths) {
    return '$chapters chapters · $hadiths hadiths';
  }

  @override
  String hadithChapterMeta(Object count) {
    return '$count hadiths';
  }

  @override
  String hadithCuratedSubtitle(Object count) {
    return 'Start with $count selected hadiths';
  }

  @override
  String get hadithStartHere => 'Start';

  @override
  String get hadithSearchTitle => 'Search hadith';

  @override
  String get hadithSearchHint => 'Search in Bangla';

  @override
  String get hadithSearchPrompt => 'Type a topic in Bangla — prayer, fasting, charity.';

  @override
  String hadithSearchCount(Object count) {
    return '$count hadiths found';
  }

  @override
  String get hadithBookmarksTitle => 'Saved hadiths';

  @override
  String get hadithNoBookmarks => 'You have not saved any hadith yet.';

  @override
  String get hadithBrowseCollections => 'Browse collections';

  @override
  String get hadithPreparing => 'Preparing the hadith collection — this takes a moment the first time.';

  @override
  String get hadithLoadFailedTitle => 'Could not open the hadith collection';

  @override
  String get hadithLoadFailedBody => 'This can happen when storage is low. Free some space and try again.';

  @override
  String get hadithAttribution => 'Translations and gradings come from open hadith datasets. Tell us if you spot an error.';

  @override
  String tasbihTimes(Object count) {
    return '$count times';
  }

  @override
  String get tasbihCountAction => 'Count';

  @override
  String get tasbihTodayTotal => 'Today';

  @override
  String get tasbihRounds => 'Rounds';

  @override
  String get tasbihStreak => 'Streak';

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihResetTitle => 'Reset the count?';

  @override
  String get tasbihResetBody => 'Today\'s count for this dhikr will be cleared. Earlier days are kept.';

  @override
  String get tasbihSetGoal => 'Set a goal';

  @override
  String get tasbihHaptics => 'Vibration';

  @override
  String get tasbihHistoryTitle => 'Dhikr history';

  @override
  String get tasbihLast30Days => 'Last 30 days';

  @override
  String get tasbihDaysCounted => 'Days';

  @override
  String get tasbihTotalCounted => 'Total dhikr';

  @override
  String get tasbihNoHistory => 'You have not counted any dhikr yet.';

  @override
  String get tasbihStartCounting => 'Start counting';

  @override
  String tasbihOfTarget(Object done, Object target) {
    return '$done / $target';
  }

  @override
  String get qiblaRecalibrate => 'Recalibrate';

  @override
  String get qiblaAligned => 'Straight ahead — facing the qibla';

  @override
  String qiblaTurnLeft(Object degrees) {
    return 'Turn $degrees° left';
  }

  @override
  String qiblaTurnRight(Object degrees) {
    return 'Turn $degrees° right';
  }

  @override
  String get qiblaDistanceLabel => 'Distance to Makkah';

  @override
  String qiblaKilometres(Object value) {
    return '$value km';
  }

  @override
  String get qiblaAccuracyLabel => 'Accuracy';

  @override
  String get qiblaAccuracyHigh => 'High';

  @override
  String get qiblaAccuracyMedium => 'Medium';

  @override
  String get qiblaAccuracyLow => 'Low';

  @override
  String get qiblaAccuracyUnknown => 'Unknown';

  @override
  String get qiblaCalibrationHint => 'Compass accuracy is low. Move the phone in a figure-8 a few times and stay clear of metal.';

  @override
  String get qiblaLocationServiceOff => 'Location services are off. Turn them on to find the qibla.';

  @override
  String get qiblaLocationDenied => 'The qibla direction needs location permission.';

  @override
  String get qiblaCompassUnavailable => 'No compass was found on this phone.';

  @override
  String get masjidKeyMissingTitle => 'Map is not set up';

  @override
  String get masjidLocationNeeded => 'Finding nearby masjids needs location permission.';

  @override
  String masjidCountWithin(Object count, Object radius) {
    return '$count masjids within $radius km';
  }

  @override
  String masjidWalkMinutes(Object minutes) {
    return '$minutes min walk';
  }

  @override
  String masjidStraightLine(Object metres) {
    return '$metres m as the crow flies';
  }

  @override
  String get masjidSortDistance => 'Distance';

  @override
  String get masjidSortJamaat => 'Jamaat time';

  @override
  String get masjidSortJumua => 'Jumu\'ah';

  @override
  String get masjidShowRoute => 'Directions';

  @override
  String get masjidSetJamaat => 'Set times';

  @override
  String get masjidAddJamaatPrompt => 'Know the times? Add them';

  @override
  String get masjidJamaatExplainer => 'Jamaat times differ by masjid. Add the ones you know — you will be the one using them.';

  @override
  String get quranBookmarkTab => 'Bookmarks';

  @override
  String get quranNoBookmarks => 'You have not saved any ayah yet.';

  @override
  String get quranSearchHint => 'Surah name or number';

  @override
  String quranAyahCount(Object count) {
    return '$count ayahs';
  }

  @override
  String get quranPlayingNow => 'Playing';

  @override
  String get quranTypeSettings => 'Text settings';

  @override
  String get quranArabicSize => 'Arabic size';

  @override
  String get quranTranslationSize => 'Translation size';

  @override
  String get quranShowTranslation => 'Show translation';

  @override
  String get quranAddBookmark => 'Bookmark';

  @override
  String get quranRemoveBookmark => 'Remove bookmark';

  @override
  String get quranWriteNote => 'Write a note';

  @override
  String get quranEditNote => 'Edit note';

  @override
  String get quranPlayFromHere => 'Play from here';

  @override
  String get quranCopyAyah => 'Copy';

  @override
  String get quranNoteHint => 'Your note about this ayah…';

  @override
  String get quranSaveNote => 'Save note';

  @override
  String get quranPlanTitle => 'Daily reading plan';

  @override
  String get quranTodaysGoal => 'Today\'s goal';

  @override
  String get quranAyahUnit => 'ayahs';

  @override
  String get quranMinutesUnit => 'min';

  @override
  String get quranNoPlanYet => 'No plan yet';

  @override
  String get quranPickAPlanPrompt => 'Choose a plan below.';

  @override
  String get quranGoalDone => 'Today\'s goal is done — alhamdulillah.';

  @override
  String quranRemainingToday(Object ayahs, Object minutes) {
    return '$ayahs ayahs left — about $minutes min';
  }

  @override
  String get quranLast30Days => 'Last 30 days';

  @override
  String get quranChoosePlan => 'Choose a plan';

  @override
  String get quranStartTodaysReading => 'Start today\'s reading';

  @override
  String quranPlanProgress(Object done, Object target) {
    return '$done / $target ayahs of today\'s goal';
  }

  @override
  String quranPlanMinutesProgress(Object done, Object target) {
    return '$done / $target min read today';
  }

  @override
  String quranPlanAyahs(Object count) {
    return '$count ayahs a day';
  }

  @override
  String quranPlanAyahsDetail(Object months) {
    return 'A khatm in about $months months';
  }

  @override
  String quranPlanPara(Object count) {
    return '$count para a day';
  }

  @override
  String get quranPlanParaDetail => 'A khatm in Ramadan — 30 days';

  @override
  String quranPlanMinutes(Object count) {
    return '$count min a day';
  }

  @override
  String get quranPlanMinutesDetail => 'Measured in time, not ayahs';

  @override
  String get quranPlanWeekly => 'Surah al-Kahf on Fridays';

  @override
  String get quranPlanWeeklyDetail => 'A weekly habit';

  @override
  String get duaFeaturedOverline => 'Dua of the day';

  @override
  String get duaRightNowOverline => 'Useful right now';

  @override
  String get duaCategoriesOverline => 'Categories';

  @override
  String duaCount(Object count) {
    return '$count';
  }

  @override
  String get duaAttribution => 'Every dua comes from the supplication chapters of Bukhari, Muslim, Ibn Majah and an-Nasa\'i, with its source shown.';

  @override
  String get ramadanUntilIftar => 'Until iftar';

  @override
  String get ramadanUntilSehri => 'Until sehri ends';

  @override
  String ramadanCountdownLabel(Object day, Object subject) {
    return 'Day $day · $subject';
  }

  @override
  String get ramadanRozaTracker => 'Fast tracker';

  @override
  String ramadanKeptRatio(Object kept, Object total) {
    return '$kept / $total kept';
  }

  @override
  String get ramadanKept => 'Kept';

  @override
  String get ramadanMissed => 'Missed';

  @override
  String get ramadanTaraweeh => 'Taraweeh';

  @override
  String ramadanTaraweehDone(Object rakats, Object streak) {
    return '$rakats rakats today · $streak day streak';
  }

  @override
  String get ramadanTaraweehPending => 'Not prayed yet today';

  @override
  String get ramadanKhatmProgress => 'Khatm progress';

  @override
  String get ramadanFitraZakat => 'Fitra & zakat';

  @override
  String get ramadanShare => 'Share';

  @override
  String get ramadanShareSchedule => 'Share the Ramadan schedule';

  @override
  String get zakatAssetsOverline => 'Assets';

  @override
  String get zakatDeductionsOverline => 'Deductions';

  @override
  String get zakatCash => 'Cash & bank';

  @override
  String get zakatGold => 'Gold';

  @override
  String get zakatSilver => 'Silver';

  @override
  String get zakatBusiness => 'Business stock';

  @override
  String get zakatInvestments => 'Investments & shares';

  @override
  String get zakatDebts => 'Debts owed';

  @override
  String get zakatExpenses => 'Pending expenses';

  @override
  String get zakatAddCategory => 'Add another category';

  @override
  String get zakatRemoveCategory => 'Remove this category';

  @override
  String get zakatCategoryNameHint => 'Category name';

  @override
  String zakatBhori(Object value) {
    return '$value bhori';
  }

  @override
  String get zakatBhoriUnit => 'bhori';

  @override
  String get zakatEnterBhori => 'Enter the weight in bhori';

  @override
  String get zakatEnterTaka => 'Enter the amount in taka';

  @override
  String zakatRatePerBhori(Object rate) {
    return 'Today\'s rate · $rate per bhori';
  }

  @override
  String get zakatSaveAmount => 'Save';

  @override
  String get zakatNisabGold => 'Nisab (gold)';

  @override
  String get zakatNisabSilver => 'Nisab (silver)';

  @override
  String get zakatGoldPerBhori => 'Gold / bhori';

  @override
  String get zakatSilverPerBhori => 'Silver / bhori';

  @override
  String get zakatUseGoldNisab => 'Use the gold nisab';

  @override
  String get zakatNisabExplainer => 'The silver nisab is lower, so more people qualify — it is the cautious default.';

  @override
  String get zakatTotalWealth => 'Zakatable wealth';

  @override
  String get zakatPayableOverline => 'Zakat payable · 2.5%';

  @override
  String get zakatBelowNisab => 'Below nisab — zakat is not due';

  @override
  String get zakatHelp => 'About zakat';

  @override
  String get zakatHelpBody => 'Zakat is 2.5% of wealth held above nisab for a lunar year. Metal rates change daily, so check them before calculating. This is a helper, not a fatwa — ask a scholar for complex cases.';

  @override
  String get zakatRatesUnavailableTitle => 'Rates unavailable';

  @override
  String get zakatRatesUnavailableBody => 'Could not fetch today\'s metal rates, so nisab cannot be calculated. Check your connection and try again.';

  @override
  String get calendarEventsOverline => 'This month';

  @override
  String get calendarNoEvents => 'No special days this month.';

  @override
  String get calendarAdjustTitle => 'Adjust the Hijri date';

  @override
  String get calendarAdjustBody => 'The calculated date can differ by a day from the moon sighting announcement. Match it here.';

  @override
  String get calendarOffsetMinus => 'One day earlier';

  @override
  String get calendarOffsetNone => 'As calculated';

  @override
  String get calendarOffsetPlus => 'One day later';

  @override
  String get calendarMawlid => 'Mawlid an-Nabi';

  @override
  String get calendarShabeMeraj => 'Shab-e-Mi\'raj';

  @override
  String get calendarShabeBarat => 'Shab-e-Barat';

  @override
  String get calendarArafah => 'Day of Arafah';
}
