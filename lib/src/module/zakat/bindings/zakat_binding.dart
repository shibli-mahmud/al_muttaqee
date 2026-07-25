import 'package:al_muttaqee/src/module/zakat/controllers/zakat_controller.dart';
import 'package:get/get.dart';

class ZakatBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ZakatController.new);
}
