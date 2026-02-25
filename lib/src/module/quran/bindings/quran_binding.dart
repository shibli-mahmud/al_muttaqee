import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:get/get.dart';

class QuranBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => QuranController());
  }
}