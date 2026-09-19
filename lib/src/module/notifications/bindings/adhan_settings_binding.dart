import 'package:get/get.dart';

import 'package:al_muttaqee/src/module/notifications/controllers/adhan_settings_controller.dart';

class AdhanSettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AdhanSettingsController>()) {
      Get.lazyPut(() => AdhanSettingsController(), fenix: true);
    }
  }
}
