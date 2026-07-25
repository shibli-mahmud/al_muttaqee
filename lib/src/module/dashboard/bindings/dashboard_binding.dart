import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:al_muttaqee/src/module/home/controllers/home_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/qibla/controllers/qibla_controller.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => QuranController(), fenix: true);
    Get.lazyPut(() => QiblaController(), fenix: true);
    Get.lazyPut(() => TasbihController(), fenix: true);
    Get.lazyPut(() => PrayerTimesController(), fenix: true);

    Get.lazyPut(
      () => DashboardController(
        homeController: HomeController.to,
        quranController: QuranController.to,
        qiblaController: QiblaController.to,
        tasbihController: TasbihController.to,
      ),
    );
  }
}
