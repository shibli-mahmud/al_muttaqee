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
  String get ramadanMode => 'Ramadan mode';

  @override
  String get importantDates => 'Important dates';
}
