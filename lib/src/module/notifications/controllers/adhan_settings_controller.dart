import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/core/utils/utils/notification_service.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// আজান ও রিমাইন্ডার — frame ১২, and the per-prayer detail behind it.
///
/// A thin controller: the real state lives in [NotificationService], because
/// the schedule has to be rebuilt from it whether the change came from this
/// screen, from onboarding, or from a location move.
class AdhanSettingsController extends BaseController {
  static AdhanSettingsController get to => Get.find<AdhanSettingsController>();

  NotificationService get service => NotificationService.to;

  @override
  void onInit() {
    super.onInit();
    // Coming back from an OS settings screen is the common case here, so the
    // permission card must not still be showing the state from before.
    service.refreshPermissions();
  }

  /// The prayer named by `/adhan-settings/:prayer`.
  ///
  /// Read from the route on demand rather than held as state: one controller
  /// serves both the list and the detail, and a field would go stale the
  /// moment the user pushed a second detail screen.
  PrayerName? prayerFromRoute() {
    final raw = Get.parameters['prayer'];
    if (raw == null) return null;
    return PrayerName.values.firstWhereOrNull((p) => p.name == raw);
  }

  AdhanSetting settingFor(PrayerName prayer) =>
      service.adhanSettings[prayer] ?? const AdhanSetting.defaults();

  Future<void> setMode(PrayerName prayer, AdhanMode mode) =>
      service.setAdhanSetting(prayer, settingFor(prayer).copyWith(mode: mode));

  Future<void> setSound(PrayerName prayer, AdhanSound sound) =>
      service.setAdhanSetting(
        prayer,
        settingFor(prayer).copyWith(sound: sound),
      );

  Future<void> setPreOffset(PrayerName prayer, int minutes) =>
      service.setAdhanSetting(
        prayer,
        settingFor(prayer).copyWith(preOffsetMinutes: minutes),
      );

  Future<void> setReminder(ExtraReminder reminder, bool enabled) =>
      service.setReminder(reminder, enabled);

  AlarmPermissionState get permissions => service.permissions.value;

  /// Walks the user through whichever gate is still shut, most-blocking first.
  Future<void> fixPermissions() async {
    final state = permissions;
    if (!state.notificationsGranted) {
      final granted = await service.requestNotificationPermission();
      if (!granted) await service.openBlockingSetting();
      return;
    }
    if (!state.exactAlarmsAllowed) {
      await service.requestExactAlarmPermission();
      return;
    }
    if (!state.batteryOptimisationIgnored) {
      await service.requestBatteryExemption();
    }
  }

  Future<void> previewAdhan() async {
    // Preview whatever Fajr is set to: it is the alarm that matters most and
    // the one people want to hear before they trust it.
    await service.previewAdhan(settingFor(PrayerName.fajr).sound);
  }

  /// The scheduled time of [prayer] today, shown beside each row so the user
  /// can see what they are configuring.
  DateTime? timeFor(PrayerName prayer) {
    if (!Get.isRegistered<PrayerTimesController>()) return null;
    return PrayerTimesController.to.dayTimes.value?.entryFor(prayer)?.time;
  }

  void openPrayerDetail(PrayerName prayer) =>
      Get.toNamed(Routes.adhanSettingsFor(prayer.name));
}
