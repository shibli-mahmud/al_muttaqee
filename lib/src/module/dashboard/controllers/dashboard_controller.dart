import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/module/home/controllers/home_controller.dart';
import 'package:al_muttaqee/src/module/more/controllers/more_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';

/// The five tabs, in the order they appear in the nav bar.
///
/// Prayer times were promoted from a pushed screen to a first-class
/// destination, and Qibla demoted out of the tab bar to a quick action: qibla
/// is something a user needs once in a new room, while prayer times are the
/// reason they opened the app at all.
enum DashboardTab { home, quran, prayer, tasbih, more }

class DashboardController extends BaseController {
  static DashboardController get to => Get.find<DashboardController>();

  final HomeController homeController;
  final QuranController quranController;
  final PrayerTimesController prayerTimesController;
  final TasbihController tasbihController;
  final MoreController moreController;

  DashboardController({
    required this.homeController,
    required this.quranController,
    required this.prayerTimesController,
    required this.tasbihController,
    required this.moreController,
  });

  final currentIndex = 0.obs;

  DashboardTab get currentTab => DashboardTab.values[currentIndex.value];

  void changePage(int index) {
    if (index < 0 || index >= DashboardTab.values.length) return;
    currentIndex.value = index;
  }

  void openTab(DashboardTab tab) => changePage(tab.index);
}
