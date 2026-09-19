import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';

class TasbihBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TasbihController>()) {
      Get.lazyPut(() => TasbihController(), fenix: true);
    }
  }
}
