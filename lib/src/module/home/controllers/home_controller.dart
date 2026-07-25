import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

class DailyCardItem {
  final String titleKey;
  final String text;
  final String source;

  const DailyCardItem({
    required this.titleKey,
    required this.text,
    required this.source,
  });
}

class HomeController extends BaseController {
  static HomeController get to => Get.find<HomeController>();

  final gregorianLabel = ''.obs;
  final hijriLabel = ''.obs;
  final dailyCards = <DailyCardItem>[].obs;
  final lastSurah = 0.obs;
  final lastAyah = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDates();
    _loadDailyContent();
    _loadLastRead();
  }

  void _loadDates() {
    final now = DateTime.now();
    gregorianLabel.value =
        '${now.day} ${_monthName(now.month)} ${now.year}';
    final hijri = HijriCalendar.fromDate(now);
    hijriLabel.value =
        '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH';
  }

  String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[month - 1];
  }

  Future<void> _loadDailyContent() async {
    try {
      final raw =
          await rootBundle.loadString('assets/data/daily_content.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final day = DateTime.now().day;
      final isBn = L10n.isBangla(L10n.selectedLocale);

      final hadiths = (json['hadiths'] as List).cast<Map<String, dynamic>>();
      final duas = (json['duas'] as List).cast<Map<String, dynamic>>();
      final h = hadiths[(day - 1) % hadiths.length];
      final d = duas[(day - 1) % duas.length];

      dailyCards.assignAll([
        DailyCardItem(
          titleKey: 'hadith',
          text: (isBn ? h['bn'] : h['en']) as String,
          source: h['source'] as String? ?? '',
        ),
        DailyCardItem(
          titleKey: 'dua',
          text: (isBn ? d['bn'] : d['en']) as String,
          source: d['source'] as String? ?? '',
        ),
      ]);
    } catch (e, st) {
      logger.e('HomeController._loadDailyContent: $e\n$st');
    }
  }

  Future<void> _loadLastRead() async {
    final prefs = PreferenceManagerImpl.to;
    lastSurah.value =
        await prefs.getInt(AppStrings.spQuranLastSurahNumber, defaultValue: 1);
    lastAyah.value =
        await prefs.getInt(AppStrings.spQuranLastAyahNumber, defaultValue: 1);
  }

  PrayerTimesController? get prayerTimes {
    if (Get.isRegistered<PrayerTimesController>()) {
      return PrayerTimesController.to;
    }
    return null;
  }

  String prayerLabel(PrayerName name) {
    final l10n = appLocalization;
    return switch (name) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };
  }

  void openPrayerTimes() => Get.toNamed(Routes.prayerTimes);

  void openQuranContinue() {
    if (Get.isRegistered<DashboardController>()) {
      DashboardController.to.changePage(1);
    }
  }

  void openQibla() {
    if (Get.isRegistered<DashboardController>()) {
      DashboardController.to.changePage(2);
    }
  }

  void openTasbih() {
    if (Get.isRegistered<DashboardController>()) {
      DashboardController.to.changePage(3);
    }
  }

  void openMasjidFinder() {
    showSuccessMessage(appLocalization.comingSoon);
    showSuccessToast(appLocalization.comingSoon);
  }

  void reloadLocaleSensitive() {
    _loadDailyContent();
  }
}
