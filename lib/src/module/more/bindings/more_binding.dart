import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/more/controllers/more_controller.dart';

class MoreBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MoreController>()) {
      Get.lazyPut(() => MoreController(), fenix: true);
    }
  }
}
