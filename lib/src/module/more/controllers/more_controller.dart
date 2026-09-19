import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// The আরও tab.
///
/// Everything that is not a daily habit collects here: the features a user
/// reaches for occasionally, and every setting. It replaces the language
/// drawer, which hid a two-item choice behind a gesture most of this audience
/// never found.
class MoreController extends BaseController {
  static MoreController get to => Get.find<MoreController>();

  final appVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion.value = info.version;
    } catch (e) {
      logger.e('MoreController._loadVersion: $e');
    }
  }

  PrayerTimesController? get _prayerTimes =>
      Get.isRegistered<PrayerTimesController>()
          ? PrayerTimesController.to
          : null;

  /// The place name for the অবস্থান row, or an empty string when the user has
  /// not chosen one and location is unavailable.
  String get locationLabel => _prayerTimes?.locationLabel.value ?? '';

  PrayerCalculationMethod get calculationMethod =>
      _prayerTimes?.method.value ?? PrayerCalculationMethod.karachi;

  String get languageLabel => L10n.getLocalString(L10n.selectedLocale);

  Future<void> setLocale(Locale locale) => L10n.setLocale(locale);

  // ── Destinations ──────────────────────────────────────────────────────────

  void openQibla() => Get.toNamed(Routes.qibla);
  void openMasjidFinder() => Get.toNamed(Routes.masjidFinder);
  void openDua() => Get.toNamed(Routes.dua);
  void openHadith() => Get.toNamed(Routes.hadith);
  void openZakat() => Get.toNamed(Routes.zakat);
  void openCalendar() => Get.toNamed(Routes.calendar);
  void openRamadan() => Get.toNamed(Routes.ramadan);
  void openNames99() => Get.toNamed(Routes.names99);
  void openWidgets() => Get.toNamed(Routes.widgets);

  void openAdhanSettings() => Get.toNamed(Routes.adhanSettings);
  void openPrayerSettings() => Get.toNamed(Routes.prayerSettings);
}
