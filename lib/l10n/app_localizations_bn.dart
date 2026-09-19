// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get home => 'হোম';

  @override
  String get quran => 'কুরআন';

  @override
  String get qibla => 'কিবলা';

  @override
  String get tasbih => 'তাসবিহ';

  @override
  String get language => 'ভাষা';

  @override
  String get english => 'ইংরেজি';

  @override
  String get bangla => 'বাংলা';

  @override
  String get preparingQiblaCompass => 'কিবলা কম্পাস প্রস্তুত করা হচ্ছে...';

  @override
  String get locationAccessRequired => 'অবস্থান অ্যাক্সেস প্রয়োজন';

  @override
  String get locationAccessMessage => 'কিবলার দিক নির্ণয়ের জন্য অনুগ্রহ করে লোকেশন সেবা চালু করুন এবং অনুমতি দিন।';

  @override
  String get compassCalibrationMessage => 'কম্পাস ক্যালিব্রেশন প্রয়োজন। নির্ভুলতা বাড়াতে নিচের আটের মতো ডিভাইস নাড়ান।';

  @override
  String get moveDeviceLikeThis => 'ডিভাইস এভাবে নাড়ান';

  @override
  String get qiblaDirection => 'কিবলার দিক';

  @override
  String get qiblaDirectionHint => 'কিবলার দিকে মুখ করতে ডিভাইসের উপরের দিকে তীরটি ধরুন।';

  @override
  String qiblaHeadingFormat(Object qibla, Object heading) {
    return 'কিবলা: $qibla°  |  হেডিং: $heading°';
  }

  @override
  String get deviceLevelMessage => 'ডিভাইস সমতল — বৃত্তের মাঝে বাবল সেন্টার করুন';

  @override
  String tiltMessage(Object tilt) {
    return 'হেলান: $tilt° — ডিভাইস সমতল করতে বাবল সেন্টার করুন';
  }

  @override
  String get levelIndicator => 'লেভেল ইন্ডিকেটর (কেন্দ্র বাবল)';

  @override
  String get tasbihTapToCount => 'গণনা করতে বৃত্তে ট্যাপ করুন';

  @override
  String get tasbihSwipeHorizontal => 'গণনা করতে বাম থেকে ডানে সোয়াইপ করুন';

  @override
  String get tasbihSwipeVertical => 'গণনা করতে উপরে সোয়াইপ করুন';

  @override
  String get tasbihOrientationLeftRight => 'বাম–ডান';

  @override
  String get tasbihOrientationUpDown => 'উপরে–নিচে';

  @override
  String get tasbihResetRound => 'রাউন্ড রিসেট';

  @override
  String get tasbihResetAll => 'সব রিসেট';

  @override
  String tasbihRoundsTotal(Object rounds, Object total) {
    return '$rounds রাউন্ড • $total মোট';
  }

  @override
  String get prayerTimes => 'নামাজের সময়';

  @override
  String get preparingPrayerTimes => 'নামাজের সময় গণনা করা হচ্ছে...';

  @override
  String get prayerTimesLoadError => 'নামাজের সময় লোড করা যায়নি।';

  @override
  String get prayerTimesLocationFallback => 'ডিফল্ট অবস্থান (ঢাকা) ব্যবহার করা হচ্ছে। সঠিক সময়ের জন্য লোকেশন দিন।';

  @override
  String get nextPrayer => 'পরবর্তী নামাজ';

  @override
  String get currentPrayer => 'বর্তমান নামাজ';

  @override
  String get timeRemaining => 'অবশিষ্ট সময়';

  @override
  String get prayerFajr => 'ফজর';

  @override
  String get prayerSunrise => 'সূর্যোদয়';

  @override
  String get prayerDhuhr => 'যোহর';

  @override
  String get prayerAsr => 'আসর';

  @override
  String get prayerMaghrib => 'মাগরিব';

  @override
  String get prayerIsha => 'ইশা';

  @override
  String get prayerSettings => 'নামাজ সেটিংস';

  @override
  String get calculationMethod => 'গণনা পদ্ধতি';

  @override
  String get hanafiMadhab => 'হানাফি মাজহাব (দেরি আসর)';

  @override
  String get manualOffsets => 'ম্যানুয়াল অফসেট (মিনিট)';

  @override
  String get methodKarachi => 'করাচি (ইউনিভার্সিটি অব ইসলামিক সায়েন্সেস)';

  @override
  String get methodMwl => 'মুসলিম ওয়ার্ল্ড লীগ';

  @override
  String get methodEgyptian => 'মিশরীয় জেনারেল অথরিটি';

  @override
  String get methodUmmAlQura => 'উম্মুল কুরা';

  @override
  String get methodNorthAmerica => 'আইএসএনএ (উত্তর আমেরিকা)';

  @override
  String get methodDubai => 'দুবাই';

  @override
  String get methodQatar => 'কাতার';

  @override
  String get methodKuwait => 'কুয়েত';

  @override
  String get methodSingapore => 'সিঙ্গাপুর';

  @override
  String get methodTurkiye => 'তুরস্ক (দিয়ানেত)';

  @override
  String get hadithOfTheDay => 'আজকের হাদিস';

  @override
  String get duaOfTheDay => 'আজকের দোয়া';

  @override
  String get quickAccess => 'দ্রুত প্রবেশ';

  @override
  String get continueReading => 'পড়া চালিয়ে যান';

  @override
  String get masjidFinder => 'মসজিদ খুঁজুন';

  @override
  String get gregorianDate => 'গ্রেগরিয়ান';

  @override
  String get hijriDate => 'হিজরি';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get sources => 'সূত্র';

  @override
  String get search => 'খুঁজুন';

  @override
  String get bookmark => 'বুকমার্ক';

  @override
  String get bookmarked => 'বুকমার্ক করা হয়েছে';

  @override
  String get hadith => 'হাদিস';

  @override
  String get settings => 'সেটিংস';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get calendar => 'ক্যালেন্ডার';

  @override
  String get zakat => 'যাকাত';

  @override
  String get supportApp => 'অ্যাপকে সাপোর্ট করুন';

  @override
  String get proUnlock => 'প্রো আনলক';

  @override
  String get offlineDownload => 'অফলাইনের জন্য ডাউনলোড';

  @override
  String get reciter => 'কারি';

  @override
  String get play => 'চালান';

  @override
  String get pause => 'থামান';

  @override
  String get repeatAyah => 'আয়াত পুনরাবৃত্তি';

  @override
  String get repeatSurah => 'সূরা পুনরাবৃত্তি';

  @override
  String get playbackSpeed => 'প্লেব্যাক স্পিড';

  @override
  String get openInMaps => 'ম্যাপে খুলুন';

  @override
  String distanceKm(Object distance) {
    return '$distance কিমি';
  }

  @override
  String get sehriEnds => 'সেহরি শেষ';

  @override
  String get iftar => 'ইফতার';

  @override
  String ratesLastUpdated(Object date) {
    return 'রেট সর্বশেষ আপডেট: $date';
  }

  @override
  String get zakatDue => 'যাকাত বাকি';

  @override
  String get nisabThreshold => 'নিসাব সীমা';

  @override
  String get permissionRationaleLocation => 'কিবলা, নামাজের সময় এবং কাছের মসজিদ খুঁজতে অবস্থান ব্যবহার করা হয়।';

  @override
  String get permissionRationaleNotifications => 'নামাজের সময় ও দৈনিক দোয়ার কথা মনে করিয়ে দিতে নোটিফিকেশন।';

  @override
  String get enableNotifications => 'নোটিফিকেশন চালু করুন';

  @override
  String get salatAlerts => 'নামাজ সতর্কতা';

  @override
  String get duaReminders => 'দোয়া রিমাইন্ডার';

  @override
  String get globalNotifications => 'সব নোটিফিকেশন';

  @override
  String get narrator => 'বর্ণনাকারী';

  @override
  String get chapter => 'অধ্যায়';

  @override
  String get noResults => 'কোনো ফলাফল নেই';

  @override
  String get hadithAllChapters => 'সব অধ্যায়';

  @override
  String get hadithBukhari => 'সহিহ আল-বুখারি';

  @override
  String get hadithMuslim => 'সহিহ মুসলিম';

  @override
  String get hadithAbuDaud => 'সুনান আবু দাউদ';

  @override
  String get hadithIbnMajah => 'সুনান ইবনে মাজাহ';

  @override
  String get hadithTirmidhi => 'জামে আত-তিরমিজি';

  @override
  String get hadithSourcesAttribution => 'ইসলামিক ফাউন্ডেশন বাংলাদেশ / আলকুরআনবিডি';

  @override
  String get ramadanMode => 'রমজান মোড';

  @override
  String get importantDates => 'গুরুত্বপূর্ণ তারিখ';

  @override
  String get mapsApiKeyRequired => 'কাছের মসজিদ দেখাতে .env-এ Google Maps ও Places API কী যোগ করুন।';

  @override
  String get noNearbyMasjids => 'কাছাকাছি কোনো মসজিদ পাওয়া যায়নি।';

  @override
  String get proBenefits => 'সব কারির অফলাইন ডাউনলোড এবং পূর্ণ হাদিস সার্চ ও বুকমার্ক পেতে উন্নয়নে সহায়তা করুন। কুরআন, নামাজের সময়, কিবলা ও তাসবিহ সবসময় ফ্রি থাকবে।';

  @override
  String get proUnlocked => 'প্রো আনলক হয়েছে';

  @override
  String get restorePurchases => 'ক্রয় পুনরুদ্ধার করুন';

  @override
  String get supportDescription => 'অ্যাপকে সহায়তা করতে ঐচ্ছিক সদকা অবদান রাখুন।';

  @override
  String get storeUnavailable => 'স্টোর পাওয়া যাচ্ছে না। কনফিগার করা টেস্ট বা প্রোডাকশন পরিবেশে চেষ্টা করুন।';

  @override
  String get debugProUnlock => 'ডিবাগ প্রো আনলক';

  @override
  String get ashura => 'আশুরা';

  @override
  String get ramadanStart => 'রমজান শুরু';

  @override
  String get laylatulQadr => 'সম্ভাব্য লাইলাতুল কদর';

  @override
  String get eidAlFitr => 'ঈদুল ফিতর';

  @override
  String get eidAlAdha => 'ঈদুল আজহা';

  @override
  String get cash => 'নগদ';

  @override
  String get goldGrams => 'স্বর্ণ (গ্রাম)';

  @override
  String get silverGrams => 'রূপা (গ্রাম)';

  @override
  String get businessAssets => 'ব্যবসার সম্পদ';

  @override
  String get debtsOwedToYou => 'আপনার পাওনা ঋণ';

  @override
  String get debtsYouOwe => 'আপনার দেনা';

  @override
  String get useGoldNisab => 'স্বর্ণ নিসাব ব্যবহার করুন (৮৫ গ্রাম)';

  @override
  String get quranLastRead => 'শেষ পড়া';

  @override
  String get quranNoLastReadYet => 'আপনি এখনো পড়া শুরু করেননি';

  @override
  String get quranStartReading => 'পড়া শুরু করুন';

  @override
  String get quranContinueReading => 'পড়া চালিয়ে যান';

  @override
  String get quranSurahTab => 'সূরা';

  @override
  String get quranParaTab => 'পারা';

  @override
  String quranParaLabel(int number) {
    return 'পারা $number';
  }

  @override
  String get quranRevelationMeccan => 'মক্কী';

  @override
  String get quranRevelationMedinan => 'মাদানী';

  @override
  String quranAyahNumberLabel(int number) {
    return 'আয়াত $number';
  }

  @override
  String get navHome => 'হোম';

  @override
  String get navQuran => 'কুরআন';

  @override
  String get navPrayer => 'নামাজ';

  @override
  String get navTasbih => 'তাসবিহ';

  @override
  String get navMore => 'আরও';

  @override
  String get greeting => 'আসসালামু আলাইকুম';

  @override
  String get nextPrayerOverline => 'পরের নামাজ';

  @override
  String currentWindowOverline(Object prayer) {
    return 'এখনই $prayerের ওয়াক্ত';
  }

  @override
  String windowStartsWithJamaat(Object start, Object jamaat) {
    return 'ওয়াক্ত শুরু $start · জামাত $jamaat';
  }

  @override
  String windowStartsAt(Object start) {
    return 'ওয়াক্ত শুরু $start';
  }

  @override
  String nextPrayerStartsIn(Object prayer, Object remaining) {
    return '$prayer শুরু $remaining';
  }

  @override
  String get locationUnknown => 'অবস্থান বাছুন';

  @override
  String get notificationsSemantic => 'বিজ্ঞপ্তি';

  @override
  String get todayLabel => 'আজ';

  @override
  String get hijriLabel => 'হিজরি';

  @override
  String get todaysPrayers => 'আজকের নামাজ';

  @override
  String streakDays(Object count) {
    return 'টানা $count দিন';
  }

  @override
  String get streakNone => 'শুরু করুন';

  @override
  String get continueReadingOverline => 'পড়া চালিয়ে যান';

  @override
  String readingProgressLine(Object ayah, Object percent) {
    return 'আয়াত $ayah · আজকের লক্ষ্যের $percent';
  }

  @override
  String get readingNotStarted => 'পড়া শুরু করুন';

  @override
  String get quickAccessOverline => 'দ্রুত প্রবেশ';

  @override
  String get tileQibla => 'কিবলা';

  @override
  String get tileMasjid => 'মসজিদ';

  @override
  String get tileDua => 'দুআ';

  @override
  String get tileZakat => 'যাকাত';

  @override
  String get tileHadith => 'হাদিস';

  @override
  String get tileCalendar => 'ক্যালেন্ডার';

  @override
  String get tileRamadan => 'রমজান';

  @override
  String get tileNames99 => '৯৯ নাম';

  @override
  String get tileWidget => 'উইজেট';

  @override
  String get iftarDua => 'ইফতারের দুআ';

  @override
  String get comingSoonBody => 'এই অংশটি শিগগিরই আসছে।';

  @override
  String get prayerScreenTitle => 'নামাজ';

  @override
  String dateToday(Object weekday) {
    return 'আজ · $weekday';
  }

  @override
  String remainingOverline(Object prayer) {
    return '$prayerের বাকি';
  }

  @override
  String jamaatAndEnd(Object jamaat, Object end) {
    return 'জামাত $jamaat · শেষ $end';
  }

  @override
  String jamaatOnly(Object jamaat) {
    return 'জামাত $jamaat';
  }

  @override
  String endsAt(Object end) {
    return 'শেষ $end';
  }

  @override
  String nextWindowWithJamaat(Object jamaat) {
    return 'পরের ওয়াক্ত · জামাত $jamaat';
  }

  @override
  String get nextWindow => 'পরের ওয়াক্ত';

  @override
  String get runningNow => 'এখন চলছে';

  @override
  String get jamaatUnknown => 'জামাতের সময় জানা নেই';

  @override
  String monthTracker(Object month) {
    return '$month ট্র্যাকার';
  }

  @override
  String get legendAllFive => '৫ ওয়াক্ত';

  @override
  String get legendPartial => 'আংশিক';

  @override
  String get legendPending => 'বাকি';

  @override
  String get calculationAndOffsets => 'হিসাব পদ্ধতি ও সমন্বয়';

  @override
  String get adhanAndReminders => 'আজান ও রিমাইন্ডার';

  @override
  String get madhabOverline => 'মাযহাব';

  @override
  String get hanafiAsr => 'হানাফি — আসর দেরিতে';

  @override
  String get offsetsOverline => 'মিনিট সমন্বয়';

  @override
  String get offsetsExplainer => 'স্থানীয় মসজিদের সময়ের সাথে মেলাতে প্রতিটি ওয়াক্ত কয়েক মিনিট আগে-পিছে করা যায়।';

  @override
  String minutesValue(Object minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get jamaatOverline => 'জামাতের সময়';

  @override
  String get jamaatExplainer => 'জামাতের সময় মসজিদভেদে আলাদা — নিজের মসজিদের সময় বসিয়ে নিন।';

  @override
  String get notSet => 'দেওয়া নেই';

  @override
  String get clearValue => 'মুছে ফেলুন';

  @override
  String get perPrayerOverline => 'প্রতি ওয়াক্তে';

  @override
  String get otherRemindersOverline => 'অন্যান্য';

  @override
  String get reminderJumua => 'জুমার রিমাইন্ডার';

  @override
  String get reminderTahajjud => 'তাহাজ্জুদ ডাক';

  @override
  String get reminderDailyHadith => 'আজকের হাদিস বিজ্ঞপ্তি';

  @override
  String get testAdhanSound => 'আজানের শব্দ পরীক্ষা করুন';

  @override
  String get adhanModeAdhan => 'আজান';

  @override
  String get adhanModeSilent => 'নীরব';

  @override
  String get adhanModeOff => 'বন্ধ';

  @override
  String get adhanModeSilentLong => 'নীরব বিজ্ঞপ্তি';

  @override
  String get adhanModeOffLong => 'বন্ধ আছে';

  @override
  String get adhanSoundDefault => 'ফোনের নিজস্ব শব্দ';

  @override
  String get adhanSoundMakkah => 'মক্কা আজান';

  @override
  String get adhanSoundMadinah => 'মদিনা আজান';

  @override
  String get adhanSoundMishary => 'মিশারি রশিদ';

  @override
  String get adhanSoundOverline => 'আজানের শব্দ';

  @override
  String get adhanModeOverline => 'কীভাবে জানাবে';

  @override
  String get preOffsetOverline => 'কত আগে জানাবে';

  @override
  String get preOffsetOnTime => 'ঠিক সময়ে';

  @override
  String preOffsetMinutes(Object minutes) {
    return '$minutes মিনিট আগে';
  }

  @override
  String adhanSummaryWithOffset(Object sound, Object minutes) {
    return '$sound · $minutes মিনিট আগে';
  }

  @override
  String get exactAlarmOkTitle => 'সঠিক সময়ে বাজার অনুমতি';

  @override
  String get exactAlarmOkBody => 'Exact alarm ও ব্যাটারি ছাড় — দুটোই চালু আছে।';

  @override
  String get exactAlarmWarnTitle => 'ঠিক সময়ে আজান শুনতে';

  @override
  String get exactAlarmWarnBody => 'ব্যাটারি সেভার থেকে অ্যাপটি বাদ দিতে হবে, নাহলে আজান দেরিতে বাজতে পারে।';

  @override
  String get notificationsBlockedBody => 'বিজ্ঞপ্তির অনুমতি বন্ধ আছে — আজান বাজবে না।';

  @override
  String get exactAlarmBlockedBody => 'Exact alarm বন্ধ আছে — আজান কয়েক মিনিট দেরিতে বাজতে পারে।';

  @override
  String get openSettings => 'সেটিংসে যান';

  @override
  String get onboardingTagline => 'নামাজ, কুরআন আর দৈনিক জিকির —\nসবকিছু এক জায়গায়।';

  @override
  String get onboardingLanguageOverline => 'ভাষা বাছুন · LANGUAGE';

  @override
  String get onboardingLanguageNote => 'পরে আরও → ভাষা থেকে যেকোনো সময় বদলাতে পারবেন। আরবি ও অনুবাদের ফন্ট আলাদাভাবে ঠিক করা যাবে।';

  @override
  String get onboardingStart => 'শুরু করুন';

  @override
  String onboardingStep(Object current, Object total) {
    return '$current / $total';
  }

  @override
  String get onboardingLocationTitle => 'সঠিক সময়ের জন্য\nঅবস্থান দরকার';

  @override
  String get onboardingLocationBody => 'আপনার এলাকার সূর্যের হিসাবেই নামাজের সময় বের করা হয়। অবস্থান শুধু আপনার ফোনেই থাকে, কোথাও পাঠানো হয় না।';

  @override
  String get onboardingReasonTimes => 'মিনিটের নিখুঁত ওয়াক্ত ও কাউন্টডাউন';

  @override
  String get onboardingReasonQibla => 'কিবলার সঠিক দিক নির্ণয়';

  @override
  String get onboardingReasonMasjid => 'কাছের মসজিদ ও জামাতের সময়';

  @override
  String get onboardingAllowLocation => 'অবস্থানের অনুমতি দিন';

  @override
  String get onboardingPickCity => 'শহর নিজে বাছুন';

  @override
  String get onboardingCityHint => 'ঢাকা, চট্টগ্রাম…';

  @override
  String get onboardingCityTitle => 'শহর বাছুন';

  @override
  String get onboardingRemindersTitle => 'কোন ওয়াক্তে মনে\nকরিয়ে দেব?';

  @override
  String get onboardingRemindersBody => 'প্রতিটি ওয়াক্তের জন্য আলাদাভাবে আজান, নীরব বা বন্ধ বেছে নিন।';

  @override
  String get onboardingFinish => 'শেষ করুন';

  @override
  String get moreTitle => 'আরও';

  @override
  String get settingsOverline => 'সেটিংস';

  @override
  String get settingLanguage => 'ভাষা';

  @override
  String get settingLocation => 'অবস্থান';

  @override
  String get settingCalculation => 'নামাজের হিসাব পদ্ধতি';

  @override
  String get settingFonts => 'ফন্ট ও পড়ার সেটিংস';

  @override
  String get settingNightMode => 'রাতের মোড';

  @override
  String get settingOfflineDownloads => 'অফলাইন ডাউনলোড';

  @override
  String get settingAbout => 'অ্যাপ সম্পর্কে';

  @override
  String get nightModeAuto => 'স্বয়ংক্রিয়';

  @override
  String megabytes(Object size) {
    return '$size এমবি';
  }

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get locationDeniedTitle => 'অবস্থান পাওয়া যায়নি';

  @override
  String get locationDeniedBody => 'অবস্থানের অনুমতি ছাড়া ঢাকার সময় দেখানো হচ্ছে। নিজের শহর বেছে নিন বা অনুমতি দিন।';

  @override
  String get methodKarachiShort => 'করাচি';

  @override
  String get cancel => 'বাতিল';

  @override
  String get copyHadith => 'কপি করুন';

  @override
  String get copiedToClipboard => 'কপি হয়েছে';

  @override
  String get hadithCollectionsOverline => 'গ্রন্থ';

  @override
  String hadithCollectionMeta(Object chapters, Object hadiths) {
    return '$chapters অধ্যায় · $hadiths হাদিস';
  }

  @override
  String hadithChapterMeta(Object count) {
    return '$count হাদিস';
  }

  @override
  String hadithCuratedSubtitle(Object count) {
    return '$countটি বাছাই করা হাদিস দিয়ে শুরু করুন';
  }

  @override
  String get hadithStartHere => 'শুরু করুন';

  @override
  String get hadithSearchTitle => 'হাদিস খুঁজুন';

  @override
  String get hadithSearchHint => 'বাংলায় লিখে খুঁজুন';

  @override
  String get hadithSearchPrompt => 'যে বিষয়ে হাদিস খুঁজছেন তা বাংলায় লিখুন — যেমন নামাজ, রোজা, সদকা।';

  @override
  String hadithSearchCount(Object count) {
    return '$countটি হাদিস পাওয়া গেছে';
  }

  @override
  String get hadithBookmarksTitle => 'সংরক্ষিত হাদিস';

  @override
  String get hadithNoBookmarks => 'এখনো কোনো হাদিস সংরক্ষণ করেননি।';

  @override
  String get hadithBrowseCollections => 'গ্রন্থ দেখুন';

  @override
  String get hadithPreparing => 'হাদিস সংকলন প্রস্তুত করা হচ্ছে — প্রথমবার একটু সময় লাগবে।';

  @override
  String get hadithLoadFailedTitle => 'হাদিস খোলা যায়নি';

  @override
  String get hadithLoadFailedBody => 'ফোনে জায়গা কম থাকলে এমন হতে পারে। কিছু জায়গা খালি করে আবার চেষ্টা করুন।';

  @override
  String get hadithAttribution => 'অনুবাদ ও মান নির্ধারণ উন্মুক্ত হাদিস সংকলন থেকে সংগৃহীত। ভুল চোখে পড়লে জানাবেন।';

  @override
  String tasbihTimes(Object count) {
    return '$count বার';
  }

  @override
  String get tasbihCountAction => 'গণনা করুন';

  @override
  String get tasbihTodayTotal => 'আজ মোট';

  @override
  String get tasbihRounds => 'রাউন্ড';

  @override
  String get tasbihStreak => 'টানা';

  @override
  String get tasbihReset => 'রিসেট';

  @override
  String get tasbihResetTitle => 'গণনা রিসেট করবেন?';

  @override
  String get tasbihResetBody => 'আজকের এই জিকিরের গণনা মুছে যাবে। আগের দিনের হিসাব থাকবে।';

  @override
  String get tasbihSetGoal => 'লক্ষ্য ঠিক করুন';

  @override
  String get tasbihHaptics => 'কম্পন';

  @override
  String get tasbihHistoryTitle => 'জিকিরের হিসাব';

  @override
  String get tasbihLast30Days => 'গত ৩০ দিন';

  @override
  String get tasbihDaysCounted => 'দিন';

  @override
  String get tasbihTotalCounted => 'মোট জিকির';

  @override
  String get tasbihNoHistory => 'এখনো কোনো জিকির গণনা করেননি।';

  @override
  String get tasbihStartCounting => 'গণনা শুরু করুন';

  @override
  String tasbihOfTarget(Object done, Object target) {
    return '$done / $target';
  }

  @override
  String get qiblaRecalibrate => 'আবার নির্ণয় করুন';

  @override
  String get qiblaAligned => 'সোজা সামনে — কিবলা ঠিক আছে';

  @override
  String qiblaTurnLeft(Object degrees) {
    return 'বাঁয়ে $degrees° ঘুরুন';
  }

  @override
  String qiblaTurnRight(Object degrees) {
    return 'ডানে $degrees° ঘুরুন';
  }

  @override
  String get qiblaDistanceLabel => 'মক্কা থেকে দূরত্ব';

  @override
  String qiblaKilometres(Object value) {
    return '$value কিমি';
  }

  @override
  String get qiblaAccuracyLabel => 'নির্ভুলতা';

  @override
  String get qiblaAccuracyHigh => 'উচ্চ';

  @override
  String get qiblaAccuracyMedium => 'মাঝারি';

  @override
  String get qiblaAccuracyLow => 'কম';

  @override
  String get qiblaAccuracyUnknown => 'জানা নেই';

  @override
  String get qiblaCalibrationHint => 'কম্পাসের মান কম। ফোনটি হাতে নিয়ে ইংরেজি ৮ অক্ষরের মতো কয়েকবার ঘোরান, আর ধাতব জিনিস থেকে দূরে থাকুন।';

  @override
  String get qiblaLocationServiceOff => 'লোকেশন সার্ভিস বন্ধ আছে। কিবলার দিক বের করতে এটি চালু করুন।';

  @override
  String get qiblaLocationDenied => 'অবস্থানের অনুমতি ছাড়া কিবলার দিক বের করা যায় না।';

  @override
  String get qiblaCompassUnavailable => 'এই ফোনে কম্পাস পাওয়া যায়নি।';

  @override
  String get masjidKeyMissingTitle => 'মানচিত্র চালু হয়নি';

  @override
  String get masjidLocationNeeded => 'কাছের মসজিদ দেখাতে অবস্থানের অনুমতি দরকার।';

  @override
  String masjidCountWithin(Object count, Object radius) {
    return '$countটি মসজিদ · $radius কিমির মধ্যে';
  }

  @override
  String masjidWalkMinutes(Object minutes) {
    return 'হেঁটে $minutes মিনিট';
  }

  @override
  String masjidStraightLine(Object metres) {
    return 'সরলরেখায় $metres মিটার';
  }

  @override
  String get masjidSortDistance => 'দূরত্ব';

  @override
  String get masjidSortJamaat => 'জামাতের সময়';

  @override
  String get masjidSortJumua => 'জুমা';

  @override
  String get masjidShowRoute => 'পথ দেখান';

  @override
  String get masjidSetJamaat => 'সময় ঠিক করুন';

  @override
  String get masjidAddJamaatPrompt => 'আপনি জানেন? জামাতের সময় যোগ করুন';

  @override
  String get masjidJamaatExplainer => 'জামাতের সময় মসজিদভেদে আলাদা। আপনি যেটা জানেন সেটা বসিয়ে দিন — পরে নিজেই কাজে লাগবে।';

  @override
  String get quranBookmarkTab => 'বুকমার্ক';

  @override
  String get quranNoBookmarks => 'এখনো কোনো আয়াত সংরক্ষণ করেননি।';

  @override
  String get quranSearchHint => 'সূরার নাম বা নম্বর লিখুন';

  @override
  String quranAyahCount(Object count) {
    return '$count আয়াত';
  }

  @override
  String get quranPlayingNow => 'বাজছে';

  @override
  String get quranTypeSettings => 'ফন্ট ও পড়ার সেটিংস';

  @override
  String get quranArabicSize => 'আরবি লেখার আকার';

  @override
  String get quranTranslationSize => 'অনুবাদের আকার';

  @override
  String get quranShowTranslation => 'অনুবাদ দেখান';

  @override
  String get quranAddBookmark => 'বুকমার্ক করুন';

  @override
  String get quranRemoveBookmark => 'বুকমার্ক সরান';

  @override
  String get quranWriteNote => 'নোট লিখুন';

  @override
  String get quranEditNote => 'নোট সম্পাদনা করুন';

  @override
  String get quranPlayFromHere => 'এখান থেকে শুনুন';

  @override
  String get quranCopyAyah => 'কপি করুন';

  @override
  String get quranNoteHint => 'এই আয়াত সম্পর্কে আপনার নোট…';

  @override
  String get quranSaveNote => 'নোট সংরক্ষণ করুন';

  @override
  String get quranPlanTitle => 'দৈনিক পাঠ পরিকল্পনা';

  @override
  String get quranTodaysGoal => 'আজকের লক্ষ্য';

  @override
  String get quranAyahUnit => 'আয়াত';

  @override
  String get quranMinutesUnit => 'মিনিট';

  @override
  String get quranNoPlanYet => 'কোনো পরিকল্পনা বাছা হয়নি';

  @override
  String get quranPickAPlanPrompt => 'নিচ থেকে একটি পরিকল্পনা বেছে নিন।';

  @override
  String get quranGoalDone => 'আজকের লক্ষ্য পূরণ হয়েছে — আলহামদুলিল্লাহ।';

  @override
  String quranRemainingToday(Object ayahs, Object minutes) {
    return 'আর $ayahs আয়াত — প্রায় $minutes মিনিট';
  }

  @override
  String get quranLast30Days => 'গত ৩০ দিন';

  @override
  String get quranChoosePlan => 'পরিকল্পনা বাছুন';

  @override
  String get quranStartTodaysReading => 'আজকের পাঠ শুরু করুন';

  @override
  String quranPlanProgress(Object done, Object target) {
    return 'আজকের লক্ষ্যের $done / $target আয়াত হয়েছে';
  }

  @override
  String quranPlanMinutesProgress(Object done, Object target) {
    return 'আজ $done / $target মিনিট পড়া হয়েছে';
  }

  @override
  String quranPlanAyahs(Object count) {
    return 'দিনে $count আয়াত';
  }

  @override
  String quranPlanAyahsDetail(Object months) {
    return 'খতম হবে প্রায় $months মাসে';
  }

  @override
  String quranPlanPara(Object count) {
    return 'দিনে $count পারা';
  }

  @override
  String get quranPlanParaDetail => 'রমজানে খতম — ৩০ দিনে সম্পূর্ণ';

  @override
  String quranPlanMinutes(Object count) {
    return 'দিনে $count মিনিট';
  }

  @override
  String get quranPlanMinutesDetail => 'সময় ধরে, আয়াত নয়';

  @override
  String get quranPlanWeekly => 'শুক্রবারে সূরা কাহফ';

  @override
  String get quranPlanWeeklyDetail => 'সাপ্তাহিক অভ্যাস';

  @override
  String get duaFeaturedOverline => 'আজকের দুআ';

  @override
  String get duaRightNowOverline => 'এই মুহূর্তে দরকারি';

  @override
  String get duaCategoriesOverline => 'বিভাগ';

  @override
  String duaCount(Object count) {
    return '$countটি';
  }

  @override
  String get duaAttribution => 'সব দুআ বুখারি, মুসলিম, ইবনে মাজাহ ও নাসাঈর দুআ অধ্যায় থেকে নেওয়া — প্রতিটির সূত্র সাথে দেওয়া আছে।';

  @override
  String get ramadanUntilIftar => 'ইফতার বাকি';

  @override
  String get ramadanUntilSehri => 'সেহরি শেষ হতে বাকি';

  @override
  String ramadanCountdownLabel(Object day, Object subject) {
    return '$dayতম রোজা · $subject';
  }

  @override
  String get ramadanRozaTracker => 'রোজার হিসাব';

  @override
  String ramadanKeptRatio(Object kept, Object total) {
    return '$kept / $total রাখা হয়েছে';
  }

  @override
  String get ramadanKept => 'রাখা';

  @override
  String get ramadanMissed => 'ছুটে গেছে';

  @override
  String get ramadanTaraweeh => 'তারাবিহ';

  @override
  String ramadanTaraweehDone(Object rakats, Object streak) {
    return 'আজ $rakats রাকাত · ধারাবাহিক $streak দিন';
  }

  @override
  String get ramadanTaraweehPending => 'আজ এখনো পড়া হয়নি';

  @override
  String get ramadanKhatmProgress => 'খতমের অগ্রগতি';

  @override
  String get ramadanFitraZakat => 'ফিতরা ও যাকাত';

  @override
  String get ramadanShare => 'শেয়ার করুন';

  @override
  String get ramadanShareSchedule => 'রমজানের সময়সূচি শেয়ার করুন';

  @override
  String get zakatAssetsOverline => 'সম্পদ';

  @override
  String get zakatDeductionsOverline => 'বাদ যাবে';

  @override
  String get zakatCash => 'নগদ ও ব্যাংক';

  @override
  String get zakatGold => 'স্বর্ণ';

  @override
  String get zakatSilver => 'রূপা';

  @override
  String get zakatBusiness => 'ব্যবসার পণ্য';

  @override
  String get zakatInvestments => 'বিনিয়োগ ও শেয়ার';

  @override
  String get zakatDebts => 'ঋণ ও দেনা';

  @override
  String get zakatExpenses => 'বাকি খরচ';

  @override
  String get zakatAddCategory => 'আরেকটি খাত যোগ করুন';

  @override
  String get zakatRemoveCategory => 'এই খাতটি মুছুন';

  @override
  String get zakatCategoryNameHint => 'খাতের নাম';

  @override
  String zakatBhori(Object value) {
    return '$value ভরি';
  }

  @override
  String get zakatBhoriUnit => 'ভরি';

  @override
  String get zakatEnterBhori => 'ভরিতে পরিমাণ লিখুন';

  @override
  String get zakatEnterTaka => 'টাকায় পরিমাণ লিখুন';

  @override
  String zakatRatePerBhori(Object rate) {
    return 'আজকের দর · ভরিপ্রতি $rate';
  }

  @override
  String get zakatSaveAmount => 'সংরক্ষণ করুন';

  @override
  String get zakatNisabGold => 'নিসাব (স্বর্ণ)';

  @override
  String get zakatNisabSilver => 'নিসাব (রূপা)';

  @override
  String get zakatGoldPerBhori => 'স্বর্ণ / ভরি';

  @override
  String get zakatSilverPerBhori => 'রূপা / ভরি';

  @override
  String get zakatUseGoldNisab => 'স্বর্ণের নিসাব ধরুন';

  @override
  String get zakatNisabExplainer => 'রূপার নিসাব কম, তাই বেশি মানুষের উপর যাকাত আসে — সতর্কতার জন্য সেটিই ধরা হয়।';

  @override
  String get zakatTotalWealth => 'মোট যাকাতযোগ্য সম্পদ';

  @override
  String get zakatPayableOverline => 'প্রদেয় যাকাত · ২.৫%';

  @override
  String get zakatBelowNisab => 'নিসাবের নিচে — যাকাত ফরজ নয়';

  @override
  String get zakatHelp => 'যাকাত সম্পর্কে';

  @override
  String get zakatHelpBody => 'এক চান্দ্রবর্ষ ধরে নিসাব পরিমাণ সম্পদ থাকলে তার ২.৫% যাকাত দিতে হয়। স্বর্ণ-রূপার দর প্রতিদিন বদলায়, তাই হিসাবের আগে দর দেখে নিন। এটি সহায়ক হিসাব — জটিল ক্ষেত্রে আলেমের পরামর্শ নিন।';

  @override
  String get zakatRatesUnavailableTitle => 'দর পাওয়া যায়নি';

  @override
  String get zakatRatesUnavailableBody => 'স্বর্ণ-রূপার আজকের দর আনা যায়নি, তাই নিসাব হিসাব করা যাচ্ছে না। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String get calendarEventsOverline => 'এ মাসের দিনগুলো';

  @override
  String get calendarNoEvents => 'এ মাসে বিশেষ কোনো দিন নেই।';

  @override
  String get calendarAdjustTitle => 'হিজরি তারিখ সমন্বয়';

  @override
  String get calendarAdjustBody => 'চাঁদ দেখার ঘোষণার সাথে হিসাবের তারিখ এক দিন আগে-পিছে হতে পারে। নিচ থেকে মিলিয়ে নিন।';

  @override
  String get calendarOffsetMinus => 'এক দিন আগে';

  @override
  String get calendarOffsetNone => 'হিসাব অনুযায়ী';

  @override
  String get calendarOffsetPlus => 'এক দিন পরে';

  @override
  String get calendarMawlid => 'ঈদে মিলাদুন্নবি';

  @override
  String get calendarShabeMeraj => 'শবে মিরাজ';

  @override
  String get calendarShabeBarat => 'শবে বরাতের রাত';

  @override
  String get calendarArafah => 'আরাফার দিন';
}
