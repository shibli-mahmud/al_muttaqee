import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends BaseController{

  void onReady() async {
    super.onReady();
    Future.delayed(const Duration(seconds: 3),(){
      Get.offAllNamed(Routes.dashboard);
    });
    // await load();
  }
}