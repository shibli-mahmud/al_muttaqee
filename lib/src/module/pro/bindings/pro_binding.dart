import 'package:al_muttaqee/src/module/pro/controllers/pro_controller.dart';
import 'package:get/get.dart';

class ProBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ProController.new);
}
