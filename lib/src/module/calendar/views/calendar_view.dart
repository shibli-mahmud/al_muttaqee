import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/application_bar.dart';
import 'package:al_muttaqee/src/module/calendar/controllers/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class CalendarView extends BaseView<IslamicCalendarController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      ApplicationBar(appTitleText: AppLocalizations.of(context)!.calendar);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      final days = controller.days();
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: controller.previousMonth, icon: const Icon(Icons.chevron_left)),
                Text(DateFormat.yMMMM().format(controller.displayedMonth.value), style: kFigtree600W16S),
                IconButton(onPressed: controller.nextMonth, icon: const Icon(Icons.chevron_right)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (_, index) {
                final day = days[index];
                final hijri = HijriCalendar.fromDate(day);
                final important = controller.importantDate(day);
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: important == null ? AppColors.baseWhite : AppColors.brand100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Tooltip(
                    message: important == null ? '' : _eventLabel(l10n, important),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${day.day}', style: kFigtree600W14S),
                        Text('${hijri.hDay}', style: kFigtree400W12S.copyWith(color: AppColors.brand600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.importantDates, style: kFigtree600W16S),
          ),
        ],
      );
    });
  }

  String _eventLabel(AppLocalizations l10n, String key) => switch (key) {
        'ashura' => l10n.ashura,
        'ramadanStart' => l10n.ramadanStart,
        'laylatulQadr' => l10n.laylatulQadr,
        'eidAlFitr' => l10n.eidAlFitr,
        _ => l10n.eidAlAdha,
      };
}
