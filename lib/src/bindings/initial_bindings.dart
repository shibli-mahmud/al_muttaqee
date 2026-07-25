import 'package:get/get.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PreferenceManagerImpl>()) {
      Get.lazyPut(() => PreferenceManagerImpl(), fenix: true);
    }
    if (!Get.isRegistered<LocationService>()) {
      Get.put<LocationService>(LocationService(), permanent: true);
    }
  }
}
