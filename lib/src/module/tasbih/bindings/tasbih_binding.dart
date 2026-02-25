import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';
import 'package:get/get.dart';

class TasbihBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => TasbihController());
  }
}