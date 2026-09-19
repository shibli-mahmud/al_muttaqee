import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:al_muttaqee/src/module/hadith/data/hadith_repository.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/tracker_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// One piece of daily content — a hadith or a dua drawn from the bundled set.
class DailyCardItem {
  const DailyCardItem({
    required this.titleKey,
    required this.arabic,
    required this.text,
    required this.source,
  });

  final String titleKey;
  final String arabic;
  final String text;
  final String source;
}

class HomeController extends BaseController {
  static HomeController get to => Get.find<HomeController>();

  HomeController({HadithRepository? hadiths})
      : _hadiths = hadiths ?? HadithRepository();

  final HadithRepository _hadiths;

  final gregorianLabel = ''.obs;
  final hijriLabel = ''.obs;
  final dailyCards = <DailyCardItem>[].obs;
  final lastSurah = 0.obs;
  final lastAyah = 0.obs;
  final isRamadan = false.obs;

  /// Unread notifications, which the hero bell reports with a gold dot.
  final hasUnreadNotifications = false.obs;

  /// Today's hadith, with the collection it came from. Null until the
  /// bundled corpus has been opened.
  final dailyHadith = Rxn<HadithHit>();

  @override
  void onInit() {
    super.onInit();
    _loadDates();
    _loadDailyContent();
    _loadDailyHadith();
    _loadLastRead();
  }

  void _loadDates() {
    final now = DateTime.now();
    gregorianLabel.value = formatDayMonth(now);

    final hijri = HijriCalendar.fromDate(now);
    hijriLabel.value =
        '${formatNumberWithLocale(hijri.hDay)} ${hijri.longMonthName}';
    isRamadan.value = hijri.hMonth == 9;
  }

  Future<void> _loadDailyContent() async {
    try {
      final raw = await rootBundle.loadString('assets/data/daily_content.json');
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
          arabic: h['ar'] as String? ?? '',
          text: (isBn ? h['bn'] : h['en']) as String,
          source: h['source'] as String? ?? '',
        ),
        DailyCardItem(
          titleKey: 'dua',
          arabic: d['ar'] as String? ?? '',
          text: (isBn ? d['bn'] : d['en']) as String,
          source: d['source'] as String? ?? '',
        ),
      ]);
    } catch (e, st) {
      logger.e('HomeController._loadDailyContent: $e\n$st');
    }
  }

  Future<void> _loadDailyHadith() async {
    try {
      dailyHadith.value = await _hadiths.hadithOfTheDay();
    } catch (e, st) {
      logger.e('HomeController._loadDailyHadith: $e\n$st');
    }
  }

  DailyCardItem? get todaysDua =>
      dailyCards.firstWhereOrNull((card) => card.titleKey == 'dua');

  Future<void> _loadLastRead() async {
    final prefs = PreferenceManagerImpl.to;
    lastSurah.value = await prefs.getInt(
      AppStrings.spQuranLastSurahNumber,
      defaultValue: 1,
    );
    lastAyah.value = await prefs.getInt(
      AppStrings.spQuranLastAyahNumber,
      defaultValue: 1,
    );
  }

  PrayerTimesController? get prayerTimes =>
      Get.isRegistered<PrayerTimesController>()
          ? PrayerTimesController.to
          : null;

  TrackerController? get tracker =>
      Get.isRegistered<TrackerController>() ? TrackerController.to : null;

  /// The hero's time-of-day theme. Falls back to the day gradient before the
  /// first prayer computation lands, so the screen never flashes a wrong hue.
  DuskHeroTheme get heroTheme => prayerTimes?.heroTheme ?? DuskHeroTheme.day;

  /// Whether the Maghrib window is running, which is when the iftar-dua card
  /// appears on হোম and nowhere else.
  bool get isMaghribWindow =>
      prayerTimes?.currentWindow == DuskWindow.maghrib;

  /// How long after a window opens the hero keeps saying "it is X now" rather
  /// than counting to the next prayer. Half an hour covers the stretch in which
  /// someone is deciding whether to leave for the masjid.
  static const Duration justStartedGrace = Duration(minutes: 30);

  /// The window that opened recently enough that naming it is more useful than
  /// naming the next one, or null the rest of the time.
  PrayerName? get justStartedWindow {
    final times = prayerTimes?.dayTimes.value;
    final current = times?.current;
    if (times == null || current == null) return null;

    final start = times.entryFor(current)?.time;
    if (start == null) return null;

    final since = DateTime.now().difference(start);
    return since >= Duration.zero && since <= justStartedGrace
        ? current
        : null;
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

  /// The Arabic name shown under the hero prayer name.
  String arabicPrayerName(PrayerName name) => switch (name) {
        PrayerName.fajr => 'الفجر',
        PrayerName.sunrise => 'الشروق',
        PrayerName.dhuhr => 'الظهر',
        PrayerName.asr => 'العصر',
        PrayerName.maghrib => 'المغرب',
        PrayerName.isha => 'العشاء',
      };

  /// Pull-to-refresh on হোম. Named apart from [GetxController.refresh], which
  /// only rebuilds observers and does not re-read anything.
  Future<void> reloadAll() async {
    await prayerTimes?.refreshTimes();
    await tracker?.refreshAll();
    _loadDates();
    await _loadDailyContent();
    await _loadDailyHadith();
    await _loadLastRead();
  }

  // ── Destinations ──────────────────────────────────────────────────────────

  void openPrayerTimes() {
    if (Get.isRegistered<DashboardController>()) {
      DashboardController.to.openTab(DashboardTab.prayer);
    } else {
      Get.toNamed(Routes.prayerTimes);
    }
  }

  void openQuranContinue() {
    if (Get.isRegistered<DashboardController>()) {
      DashboardController.to.openTab(DashboardTab.quran);
    } else {
      Get.toNamed(Routes.quran);
    }
  }

  void openNotifications() => Get.toNamed(Routes.adhanSettings);
  void openHadith() => Get.toNamed(Routes.hadith);
  void openQibla() => Get.toNamed(Routes.qibla);
  void openMasjidFinder() => Get.toNamed(Routes.masjidFinder);
  void openDua() => Get.toNamed(Routes.dua);
  void openZakat() => Get.toNamed(Routes.zakat);
  void openCalendar() => Get.toNamed(Routes.calendar);
  void openRamadan() => Get.toNamed(Routes.ramadan);

  void reloadLocaleSensitive() {
    _loadDates();
    _loadDailyContent();
    _loadDailyHadith();
  }
}
