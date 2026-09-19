import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:al_muttaqee/src/module/hadith/controllers/hadith_controller.dart';
import 'package:al_muttaqee/src/module/home/controllers/home_controller.dart';
import 'package:al_muttaqee/src/module/more/controllers/more_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/tracker_controller.dart';
import 'package:al_muttaqee/src/module/qibla/controllers/qibla_controller.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => QuranController(), fenix: true);
    Get.lazyPut(() => TasbihController(), fenix: true);
    Get.lazyPut(() => PrayerTimesController(), fenix: true);
    Get.lazyPut(() => TrackerController(), fenix: true);
    Get.lazyPut(() => HadithController(), fenix: true);
    Get.lazyPut(() => MoreController(), fenix: true);

    // Qibla left the tab bar in the redesign but is still reachable by route,
    // so its controller is registered lazily rather than eagerly built.
    Get.lazyPut(() => QiblaController(), fenix: true);

    Get.lazyPut(
      () => DashboardController(
        homeController: HomeController.to,
        quranController: QuranController.to,
        prayerTimesController: PrayerTimesController.to,
        tasbihController: TasbihController.to,
        moreController: MoreController.to,
      ),
    );
  }
}
