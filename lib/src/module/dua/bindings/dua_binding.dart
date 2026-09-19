import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/dua/controllers/dua_controller.dart';

class DuaBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DuaController>()) {
      Get.lazyPut(() => DuaController(), fenix: true);
    }
  }
}
