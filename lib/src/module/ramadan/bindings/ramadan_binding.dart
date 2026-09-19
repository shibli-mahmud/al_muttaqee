import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/ramadan/controllers/ramadan_controller.dart';

class RamadanBinding extends Bindings {
  @override
  void dependencies() {
    // The countdown is computed from Fajr and Maghrib, so prayer times have to
    // exist even when Ramadan is opened directly by route.
    if (!Get.isRegistered<PrayerTimesController>()) {
      Get.lazyPut(() => PrayerTimesController(), fenix: true);
    }
    if (!Get.isRegistered<RamadanController>()) {
      Get.lazyPut(() => RamadanController(), fenix: true);
    }
  }
}
