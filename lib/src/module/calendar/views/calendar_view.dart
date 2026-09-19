import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/calendar/controllers/calendar_controller.dart';

/// হিজরি ক্যালেন্ডার — frame ১৯.
///
/// The Hijri day is the primary reading and the Gregorian sits under it — but
/// the Gregorian stays at 12px. It is content, not decoration: people use this
/// screen precisely to line the two calendars up.
class CalendarView extends BaseView<IslamicCalendarController> {
  CalendarView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  /// Bangla weekday initials, Saturday first as the Bangladeshi week runs.
  static const List<String> _weekdays = [
    'শনি',
    'রবি',
    'সোম',
    'মঙ্গল',
    'বুধ',
    'বৃহঃ',
    'শুক্র',
  ];

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const theme = DuskHeroTheme.day;

    return Obx(
      () => Column(
        children: [
          _hero(context, l10n, theme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.cardPadding,
                AppValues.screenPadding,
                AppValues.space_24,
              ),
              children: [
                _monthCard(l10n),
                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.calendarEventsOverline),
                ..._eventCards(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(
    BuildContext context,
    AppLocalizations l10n,
    DuskHeroTheme theme,
  ) {
    final month = controller.shownMonth;
    final days = controller.daysOfMonth();
    final span = days.isEmpty
        ? ''
        : days.first.month == days.last.month
            ? monthName(days.first.month)
            : '${monthName(days.first.month)} – ${monthName(days.last.month)}';

    return DuskHero(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuskHeroTitleRow(
            title: l10n.calendar,
            theme: theme,
            onBack: Get.back,
            actions: [
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.slidersHorizontal,
                theme: theme,
                semanticLabel: l10n.calendarAdjustTitle,
                onTap: () => _adjustSheet(context, l10n),
              ),
            ],
          ),
          const SizedBox(height: AppValues.cardPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.heroPadding,
            ),
            child: Row(
              children: [
                _arrow(PhosphorIconsRegular.caretLeft, theme,
                    controller.previousMonth),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${month.longMonthName} '
                        '${formatNumberWithLocale(month.hYear)}',
                        textAlign: TextAlign.center,
                        style: DuskText.bangla(
                          size: AppValues.fontSize_18,
                          weight: FontWeight.w700,
                          color: theme.onPrimary,
                        ),
                      ),
                      Text(
                        days.isEmpty
                            ? ''
                            : '$span ${formatNumberWithLocale(days.last.year)}',
                        textAlign: TextAlign.center,
                        style: DuskText.bangla(
                          size: AppValues.fontSize_11_5,
                          weight: FontWeight.w400,
                          color: theme.onMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                _arrow(PhosphorIconsRegular.caretRight, theme,
                    controller.nextMonth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, DuskHeroTheme theme, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: AppValues.space_24,
      child: SizedBox(
        width: AppValues.minTapTarget,
        height: AppValues.minTapTarget,
        child: Icon(icon, size: AppValues.icon_20, color: theme.onMuted),
      ),
    );
  }

  // ── Month grid ────────────────────────────────────────────────────────────

  Widget _monthCard(AppLocalizations l10n) {
    final days = controller.daysOfMonth();
    if (days.isEmpty) return const SizedBox.shrink();

    // DateTime.weekday is 1 (Mon)..7 (Sun); the grid starts on Saturday.
    final leading = (days.first.weekday % 7 + 1) % 7;

    return DuskCard(
      radius: AppValues.space_26,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_14,
        horizontal: AppValues.space_12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < _weekdays.length; i++)
                Expanded(
                  child: Text(
                    _weekdays[i],
                    textAlign: TextAlign.center,
                    style: DuskText.bangla(
                      size: AppValues.fontSize_10_5,
                      weight: FontWeight.w700,
                      // Friday is the one weekday that carries meaning here.
                      color: i == 6
                          ? AppColors.goldOnIvory
                          : AppColors.inkMuted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppValues.gap_6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leading + days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: AppValues.gap_3,
              crossAxisSpacing: AppValues.gap_3,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              if (index < leading) return const SizedBox.shrink();
              final date = days[index - leading];
              return _DayCell(
                date: date,
                hijriDay: controller.hijriFor(date).hDay,
                today: controller.isToday(date),
                event: controller.eventOn(date) != null,
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Events ────────────────────────────────────────────────────────────────

  List<Widget> _eventCards(AppLocalizations l10n) {
    final events = controller.eventsThisMonth();
    if (events.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: AppValues.gapXSmall),
          child: Text(
            l10n.calendarNoEvents,
            style: DuskText.bodySmall.copyWith(color: AppColors.inkMuted),
          ),
        ),
      ];
    }

    return [
      for (final (event, date) in events)
        Padding(
          padding: const EdgeInsets.only(bottom: AppValues.cardGap),
          child: DuskCard(
            radius: DuskRadius.cardTight,
            color: event.major ? AppColors.goldTintCard : AppColors.surface,
            border: event.major
                ? Border.all(color: AppColors.goldTintBorder)
                : null,
            shadow: event.major ? const [] : AppColors.shadowCard,
            child: Row(
              children: [
                DuskIconChip(
                  icon: event.major
                      ? PhosphorIconsFill.moonStars
                      : PhosphorIconsRegular.calendarBlank,
                  size: AppValues.tileIconChip,
                  radius: DuskRadius.iconChipLarge - 1,
                  background:
                      event.major ? AppColors.gold : AppColors.sage,
                  foreground:
                      event.major ? AppColors.goldInk : AppColors.duskMid,
                  iconSize: AppValues.icon_19,
                ),
                const SizedBox(width: AppValues.space_13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _eventName(l10n, event.key),
                        style: DuskText.cardHeading.copyWith(
                          color: event.major
                              ? AppColors.goldTintInk
                              : AppColors.ink,
                        ),
                      ),
                      Text(
                        '${formatNumberWithLocale(controller.hijriFor(date).hDay)} '
                        '${controller.hijriFor(date).longMonthName} · '
                        '${formatDayMonth(date)}, ${weekdayName(date)}',
                        style: DuskText.rowSubtitle.copyWith(
                          color: event.major
                              ? AppColors.goldOnCanvas
                              : AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    ];
  }

  String _eventName(AppLocalizations l10n, String key) => switch (key) {
        'ashura' => l10n.ashura,
        'mawlid' => l10n.calendarMawlid,
        'shabeMeraj' => l10n.calendarShabeMeraj,
        'shabeBarat' => l10n.calendarShabeBarat,
        'ramadanStart' => l10n.ramadanStart,
        'laylatulQadr' => l10n.laylatulQadr,
        'eidAlFitr' => l10n.eidAlFitr,
        'arafah' => l10n.calendarArafah,
        _ => l10n.eidAlAdha,
      };

  // ── Hijri correction ──────────────────────────────────────────────────────

  Future<void> _adjustSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await Get.bottomSheet<void>(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.ivory,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DuskRadius.sheet),
          ),
          boxShadow: AppColors.shadowSheet,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppValues.screenPadding,
          AppValues.space_18,
          AppValues.screenPadding,
          AppValues.space_24,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.calendarAdjustTitle, style: DuskText.cardHeading),
              const SizedBox(height: AppValues.gap_4),
              Text(
                l10n.calendarAdjustBody,
                style: DuskText.bodySmall
                    .copyWith(color: AppColors.inkSecondary),
              ),
              const SizedBox(height: AppValues.space_18),
              Obx(
                () => GroupedCard(
                  children: [
                    for (final offset in [-1, 0, 1])
                      GroupedRow(
                        title: switch (offset) {
                          -1 => l10n.calendarOffsetMinus,
                          1 => l10n.calendarOffsetPlus,
                          _ => l10n.calendarOffsetNone,
                        },
                        titleStyle: DuskText.rowLabel.copyWith(
                          color: controller.hijriOffset.value == offset
                              ? AppColors.goldTintInk
                              : AppColors.ink,
                        ),
                        tinted: controller.hijriOffset.value == offset,
                        trailing: Icon(
                          controller.hijriOffset.value == offset
                              ? PhosphorIconsFill.checkCircle
                              : PhosphorIconsRegular.circle,
                          size: AppValues.icon_20,
                          color: controller.hijriOffset.value == offset
                              ? AppColors.goldOnIvory
                              : AppColors.dashedBorder,
                        ),
                        onTap: () => controller.setHijriOffset(offset),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.hijriDay,
    required this.today,
    required this.event,
  });

  final DateTime date;
  final int hijriDay;
  final bool today;
  final bool event;

  @override
  Widget build(BuildContext context) {
    final (background, hijriInk, gregorianInk) = switch (true) {
      _ when today => (
          AppColors.duskDeep,
          AppColors.onDeepPrimary,
          AppColors.onDeepMuted,
        ),
      _ when event => (
          AppColors.goldTint,
          AppColors.goldTintInk,
          AppColors.goldOnCanvas,
        ),
      _ => (AppColors.baseTransparent, AppColors.ink, AppColors.inkMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppValues.space_7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppValues.space_14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatNumberWithLocale(hijriDay),
            style: DuskText.bangla(
              size: AppValues.fontSize_15,
              weight: FontWeight.w700,
              color: hijriInk,
            ),
          ),
          Text(
            formatNumberWithLocale(date.day),
            style: DuskText.bangla(
              size: AppValues.fontSize_12,
              weight: FontWeight.w400,
              color: gregorianInk,
            ),
          ),
        ],
      ),
    );
  }
}
