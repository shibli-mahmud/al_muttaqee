import 'package:al_muttaqee/src/module/masjid_finder/controllers/masjid_finder_controller.dart';
import 'package:get/get.dart';

class MasjidFinderBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(MasjidFinderController.new);
}
