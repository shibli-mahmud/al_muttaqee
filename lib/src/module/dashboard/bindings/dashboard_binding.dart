import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}