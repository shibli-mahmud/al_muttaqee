import 'package:get/get.dart';
import 'package:islamic_app/src/module/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}