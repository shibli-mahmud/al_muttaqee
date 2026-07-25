import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

class IslamicCalendarController extends BaseController {
  final displayedMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;

  void previousMonth() => displayedMonth.value = DateTime(
        displayedMonth.value.year,
        displayedMonth.value.month - 1,
      );

  void nextMonth() => displayedMonth.value = DateTime(
        displayedMonth.value.year,
        displayedMonth.value.month + 1,
      );

  List<DateTime> days() {
    final first = displayedMonth.value;
    final count = DateTime(first.year, first.month + 1, 0).day;
    return List.generate(count, (index) => DateTime(first.year, first.month, index + 1));
  }

  String? importantDate(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    if (hijri.hMonth == 1 && hijri.hDay == 10) return 'ashura';
    if (hijri.hMonth == 9 && hijri.hDay == 1) return 'ramadanStart';
    if (hijri.hMonth == 9 && hijri.hDay >= 21 && hijri.hDay.isOdd) return 'laylatulQadr';
    if (hijri.hMonth == 10 && hijri.hDay == 1) return 'eidAlFitr';
    if (hijri.hMonth == 12 && hijri.hDay == 10) return 'eidAlAdha';
    return null;
  }
}
