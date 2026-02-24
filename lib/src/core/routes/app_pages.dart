import 'package:get/get.dart';
import 'package:al_muttaqee/src/module/splash/bindings/splash_binding.dart';
import 'package:al_muttaqee/src/module/splash/views/splash_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.SPLASH,
      binding: SplashBinding(),
      page: () {
        return SplashView();
      },
    ),
    // GetPage(
    //   name: Routes.HOME,
    //   binding: DashboardBindings(),
    //   page: () {
    //     return DashboardView();
    //   },
    // ),

  ];
}
