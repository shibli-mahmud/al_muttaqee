import 'package:al_muttaqee/src/module/hadith/controllers/hadith_controller.dart';
import 'package:get/get.dart';

class HadithBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HadithController(), fenix: true);
  }
}
