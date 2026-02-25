import 'package:al_muttaqee/src/module/qibla/controllers/qibla_controller.dart';
import 'package:get/get.dart';

class QiblaBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => QiblaController());
  }
}