import 'package:al_muttaqee/src/module/calendar/controllers/calendar_controller.dart';
import 'package:get/get.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(IslamicCalendarController.new);
}
