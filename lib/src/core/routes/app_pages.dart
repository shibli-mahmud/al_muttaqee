import 'package:al_muttaqee/src/module/dashboard/bindings/dashboard_binding.dart';
import 'package:al_muttaqee/src/module/dashboard/views/dashboard_view.dart';
import 'package:al_muttaqee/src/module/home/bindings/home_binding.dart';
import 'package:al_muttaqee/src/module/home/views/home_view.dart';
import 'package:al_muttaqee/src/module/prayer_times/bindings/prayer_times_binding.dart';
import 'package:al_muttaqee/src/module/prayer_times/views/prayer_times_view.dart';
import 'package:al_muttaqee/src/module/qibla/bindings/qibla_binding.dart';
import 'package:al_muttaqee/src/module/qibla/views/qibla_view.dart';
import 'package:al_muttaqee/src/module/quran/bindings/quran_binding.dart';
import 'package:al_muttaqee/src/module/quran/views/quran_view.dart';
import 'package:al_muttaqee/src/module/tasbih/bindings/tasbih_binding.dart';
import 'package:al_muttaqee/src/module/tasbih/views/tasbih_view.dart';
import 'package:get/get.dart';
import 'package:al_muttaqee/src/module/splash/bindings/splash_binding.dart';
import 'package:al_muttaqee/src/module/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.splash,
      binding: SplashBinding(),
      page: () => SplashView(),
    ),
    GetPage(
      name: Routes.dashboard,
      binding: DashboardBinding(),
      page: () => DashboardView(),
    ),
    GetPage(
      name: Routes.home,
      binding: HomeBinding(),
      page: () => HomeView(),
    ),
    GetPage(
      name: Routes.quran,
      binding: QuranBinding(),
      page: () => QuranView(),
    ),
    GetPage(
      name: Routes.qibla,
      binding: QiblaBinding(),
      page: () => QiblaView(),
    ),
    GetPage(
      name: Routes.tasbih,
      binding: TasbihBinding(),
      page: () => TasbihView(),
    ),
    GetPage(
      name: Routes.prayerTimes,
      binding: PrayerTimesBinding(),
      page: () => PrayerTimesView(),
    ),
  ];
}
