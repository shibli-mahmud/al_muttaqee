import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';
import 'package:al_muttaqee/src/core/utils/utils/notification_service.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// A Bangladeshi city the user can pick when they decline location.
///
/// The fallback is required, not a nicety: a meaningful share of this audience
/// declines location permission, and an app that answers "when is Asr" with
/// nothing is uninstalled the same day.
class OnboardingCity {
  const OnboardingCity(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;
}

const List<OnboardingCity> bangladeshCities = [
  OnboardingCity('ঢাকা', 23.8103, 90.4125),
  OnboardingCity('চট্টগ্রাম', 22.3569, 91.7832),
  OnboardingCity('খুলনা', 22.8456, 89.5403),
  OnboardingCity('রাজশাহী', 24.3745, 88.6042),
  OnboardingCity('সিলেট', 24.8949, 91.8687),
  OnboardingCity('বরিশাল', 22.7010, 90.3535),
  OnboardingCity('রংপুর', 25.7439, 89.2752),
  OnboardingCity('ময়মনসিংহ', 24.7471, 90.4203),
  OnboardingCity('কুমিল্লা', 23.4607, 91.1809),
  OnboardingCity('নারায়ণগঞ্জ', 23.6238, 90.5000),
];

/// The three-page first run: language, location, reminders.
///
/// Each page earns something before the OS asks for it. Android's own
/// permission dialogs give no reason and no second chance, so the screen before
/// each one explains what the permission buys and offers a way forward if the
/// user says no.
class OnboardingController extends BaseController {
  static OnboardingController get to => Get.find<OnboardingController>();

  OnboardingController({
    PreferenceManager? prefs,
    LocationService? locationService,
  })  : _prefs = prefs ?? PreferenceManagerImpl.to,
        _locationService = locationService ?? LocationService.to;

  final PreferenceManager _prefs;
  final LocationService _locationService;

  static const int pageCount = 3;

  final pageController = PageController();
  final page = 0.obs;

  final selectedLanguage = L10n.selectedLocale.obs;
  final selectedCity = Rxn<OnboardingCity>();
  final locationGranted = false.obs;

  NotificationService? get _notifications =>
      Get.isRegistered<NotificationService>() ? NotificationService.to : null;

  PrayerTimesController? get _prayerTimes =>
      Get.isRegistered<PrayerTimesController>()
          ? PrayerTimesController.to
          : null;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) => page.value = index;

  void next() {
    if (page.value >= pageCount - 1) {
      finish();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void back() {
    if (page.value == 0) return;
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // ── Page 1: language ──────────────────────────────────────────────────────

  Future<void> chooseLanguage(Locale locale) async {
    selectedLanguage.value = locale;
    await L10n.setLocale(locale);
  }

  // ── Page 2: location ──────────────────────────────────────────────────────

  Future<void> requestLocation() async {
    final granted = await _locationService.ensurePermission();
    locationGranted.value = granted;
    if (granted) {
      selectedCity.value = null;
      await _prayerTimes?.refreshTimes();
      next();
    }
    // Declining is not an error and does not block the flow — the user can
    // pick a city instead, and the screen stays put so they can see that.
  }

  Future<void> chooseCity(OnboardingCity city) async {
    selectedCity.value = city;
    await _prefs.setString(AppStrings.spManualCity, city.name);
    await _prayerTimes?.setLocationLabel(city.name);
    next();
  }

  // ── Page 3: reminders ─────────────────────────────────────────────────────

  AdhanSetting settingFor(PrayerName prayer) =>
      _notifications?.adhanSettings[prayer] ?? const AdhanSetting.defaults();

  /// Cycles adhan → silent → off, so the whole choice is one tap on a pill
  /// rather than a menu per prayer.
  Future<void> cycleMode(PrayerName prayer) async {
    final current = settingFor(prayer).mode;
    final next = switch (current) {
      AdhanMode.adhan => AdhanMode.silent,
      AdhanMode.silent => AdhanMode.off,
      AdhanMode.off => AdhanMode.adhan,
    };
    await _notifications?.setAdhanSetting(
      prayer,
      settingFor(prayer).copyWith(mode: next),
    );
  }

  AlarmPermissionState get permissions =>
      _notifications?.permissions.value ??
      const AlarmPermissionState.unknown();

  Future<void> requestNotificationPermissions() async {
    final service = _notifications;
    if (service == null) return;
    await service.requestNotificationPermission();
    await service.requestExactAlarmPermission();
  }

  Future<void> openBlockingSetting() async =>
      _notifications?.openBlockingSetting();

  DateTime? timeFor(PrayerName prayer) =>
      _prayerTimes?.dayTimes.value?.entryFor(prayer)?.time;

  // ── Exit ──────────────────────────────────────────────────────────────────

  Future<void> finish() async {
    await requestNotificationPermissions();
    await _prefs.setBool(AppStrings.spOnboardingComplete, true);
    await _notifications?.rescheduleAll();
    Get.offAllNamed(Routes.dashboard);
  }

  /// Whether the first run has already happened. Read by the splash screen.
  static Future<bool> isComplete([PreferenceManager? prefs]) =>
      (prefs ?? PreferenceManagerImpl.to)
          .getBool(AppStrings.spOnboardingComplete);
}
