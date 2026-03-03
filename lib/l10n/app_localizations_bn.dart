// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get locationAccessMessage =>
      'কিবলার দিক নির্ণয়ের জন্য অনুগ্রহ করে লোকেশন সেবা চালু করুন এবং অনুমতি দিন।';
  @override
  String get compassCalibrationMessage =>
      'কম্পাস ক্যালিব্রেশন প্রয়োজন। নির্ভুলতা বাড়াতে নিচের আটের মতো ডিভাইস নাড়ান।';
  @override
  String get moveDeviceLikeThis => 'ডিভাইস এভাবে নাড়ান';
  @override
  String get qiblaDirection => 'কিবলার দিক';
  @override
  String get qiblaDirectionHint =>
      'কিবলার দিকে মুখ করতে ডিভাইসের উপরের দিকে তীরটি ধরুন।';
  @override
  String qiblaHeadingFormat(double qibla, double heading) =>
      'কিবলা: ${qibla.toStringAsFixed(0)}°  |  হেডিং: ${heading.toStringAsFixed(0)}°';
  @override
  String get deviceLevelMessage =>
      'ডিভাইস সমতল — বৃত্তের মাঝে বাবল সেন্টার করুন';
  @override
  String tiltMessage(double tilt) =>
      'হেলান: ${tilt.toStringAsFixed(0)}° — ডিভাইস সমতল করতে বাবল সেন্টার করুন';
  @override
  String get levelIndicator => 'লেভেল ইন্ডিকেটর (কেন্দ্র বাবল)';

  // Quran
  @override
  String get quranLastRead => 'সর্বশেষ পঠিত সূরা';
  @override
  String get quranContinueReading => 'পড়া চালিয়ে যান';
  @override
  String get quranStartReading => 'পড়া শুরু করুন';
  @override
  String get quranNoLastReadYet => 'আপনি এখনও কোনো সূরা খুলেননি।';
  @override
  String get quranSurahTab => 'সূরা';
  @override
  String get quranParaTab => 'পারা';
  @override
  String get quranSurahLabel => 'সূরা';
  @override
  String get quranParaLabel => 'পারা';
  @override
  String quranAyahNumberLabel(int ayahNumber) {
    const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    final text = ayahNumber.toString();
    final buffer = StringBuffer();
    for (final ch in text.split('')) {
      final codeUnit = ch.codeUnitAt(0);
      if (codeUnit >= 48 && codeUnit <= 57) {
        final digit = codeUnit - 48;
        buffer.write(bnDigits[digit]);
      } else {
        buffer.write(ch);
      }
    }
    return 'আয়াত ${buffer.toString()}';
  }

  @override
  String get quranRevelationMeccan => 'মাক্কী';
  @override
  String get quranRevelationMedinan => 'মাদানী';
}
