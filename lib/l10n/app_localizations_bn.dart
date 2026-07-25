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
  String get quickAccess => 'দ্রুত অ্যাক্সেস';

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
}
