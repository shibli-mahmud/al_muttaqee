import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:get/get.dart';

class PrayerTimesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PrayerTimesController>()) {
      Get.lazyPut(() => PrayerTimesController(), fenix: true);
    }
  }
}
