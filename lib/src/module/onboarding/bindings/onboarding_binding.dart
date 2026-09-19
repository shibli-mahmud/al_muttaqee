import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/onboarding/controllers/onboarding_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Prayer times are needed here, not only on the dashboard: the reminder
    // page shows each prayer's time, and choosing a city has to recompute
    // before the user reaches the home screen.
    if (!Get.isRegistered<PrayerTimesController>()) {
      Get.lazyPut(() => PrayerTimesController(), fenix: true);
    }
    Get.lazyPut(() => OnboardingController(), fenix: true);
  }
}
