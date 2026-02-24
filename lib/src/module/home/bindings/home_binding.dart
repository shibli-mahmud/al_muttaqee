import 'package:get/get.dart';
import 'package:al_muttaqee/src/module/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}