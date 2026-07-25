import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/module/home/controllers/home_controller.dart';
import 'package:al_muttaqee/src/module/qibla/controllers/qibla_controller.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';
import 'package:get/get.dart';

class DashboardController extends BaseController {
  static DashboardController get to => Get.find<DashboardController>();

  final HomeController homeController;
  final QuranController quranController;
  final QiblaController qiblaController;
  final TasbihController tasbihController;

  DashboardController({
    required this.homeController,
    required this.quranController,
    required this.qiblaController,
    required this.tasbihController,
  });
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}