import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/tracker_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';
import 'package:hijri/hijri_calendar.dart';

/// নামাজ — frame ০৩. Tab three.
///
/// The whole day, jamaat times, and the month's tracking on one screen. Jamaat
/// is on every row rather than buried in a masjid screen, because in this
/// market "when is jamaat" is asked far more often than "when does the window
/// open".
class PrayerTimesView extends BaseView<PrayerTimesController> {
  PrayerTimesView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  TrackerController? get _tracker =>
      Get.isRegistered<TrackerController>() ? TrackerController.to : null;

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final padding = _screenPadding(context);

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshTimes();
        await _tracker?.refreshAll();
      },
      color: AppColors.duskMid,
      backgroundColor: AppColors.surface,
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            _hero(l10n),
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding,
                AppValues.cardPadding,
                padding,
                AppValues.space_24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!controller.hasPermission.value) ...[
                    DuskErrorPanel(
                      title: l10n.locationDeniedTitle,
                      message: l10n.locationDeniedBody,
                      actionLabel: l10n.openSettings,
                      onAction: () => Get.toNamed(Routes.prayerSettings),
                    ),
                    const SizedBox(height: AppValues.space_12),
                  ],
                  _prayerList(l10n),
                  const SizedBox(height: AppValues.space_12),
                  _monthTracker(l10n),
                  const SizedBox(height: AppValues.space_12),
                  _settingsCard(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _hero(AppLocalizations l10n) {
    final theme = controller.heroTheme;

    return DuskHero(
      theme: theme,
      bottomRadius: DuskRadius.heroHome,
      paddingBottom: AppValues.space_22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuskHeroTitleRow(
            title: l10n.prayerScreenTitle,
            theme: theme,
            large: true,
            actions: [
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.bellRinging,
                theme: theme,
                semanticLabel: l10n.adhanAndReminders,
                onTap: () => Get.toNamed(Routes.adhanSettings),
              ),
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.slidersHorizontal,
                theme: theme,
                semanticLabel: l10n.calculationAndOffsets,
                onTap: () => Get.toNamed(Routes.prayerSettings),
              ),
            ],
          ),
          const SizedBox(height: AppValues.cardPadding),
          _datePager(theme),
          const SizedBox(height: AppValues.space_18),
          _countdown(l10n, theme),
        ],
      ),
    );
  }

  Widget _datePager(DuskHeroTheme theme) {
    final date = controller.selectedDate.value;
    final hijri = HijriCalendar.fromDate(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.heroPadding),
      child: Row(
        children: [
          _pagerArrow(PhosphorIconsRegular.caretLeft, theme,
              () => controller.stepDate(-1)),
          Expanded(
            child: Column(
              children: [
                Text(
                  controller.isShowingToday
                      ? appLocalization.dateToday(weekdayName(date))
                      : '${weekdayName(date)} · ${formatDayMonth(date)}',
                  textAlign: TextAlign.center,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_15,
                    weight: FontWeight.w700,
                    color: theme.onPrimary,
                  ),
                ),
                Text(
                  '${formatNumberWithLocale(hijri.hDay)} '
                  '${hijri.longMonthName} '
                  '${formatNumberWithLocale(hijri.hYear)}',
                  textAlign: TextAlign.center,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_12,
                    weight: FontWeight.w400,
                    color: theme.onMuted,
                  ),
                ),
              ],
            ),
          ),
          _pagerArrow(PhosphorIconsRegular.caretRight, theme,
              () => controller.stepDate(1)),
        ],
      ),
    );
  }

  Widget _pagerArrow(IconData icon, DuskHeroTheme theme, VoidCallback onTap) {
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

  Widget _countdown(AppLocalizations l10n, DuskHeroTheme theme) {
    final times = controller.dayTimes.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.heroPadding),
      child: Column(
        children: [
          Text(
            times == null
                ? l10n.nextPrayerOverline
                : l10n.remainingOverline(_label(l10n, times.next)),
            textAlign: TextAlign.center,
            style: DuskText.overlineHero.copyWith(color: theme.accent),
          ),
          // The countdown is a text swap with no animation: animating a digit
          // that changes every second is distracting and burns battery on the
          // phones this audience carries.
          Text(
            times == null
                ? '—'
                : formatCountdown(controller.remaining.value),
            style: DuskText.countdown.copyWith(color: theme.onPrimary),
          ),
        ],
      ),
    );
  }

  // ── Prayer list ───────────────────────────────────────────────────────────

  Widget _prayerList(AppLocalizations l10n) {
    final times = controller.selectedTimes;
    if (times == null) return _listSkeleton();

    final tracker = _tracker;
    final showTracker = controller.isShowingToday;

    return GroupedCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.gapXSmall,
        horizontal: AppValues.gap_6,
      ),
      children: [
        for (final entry in times.prayers)
          entry.name == PrayerName.sunrise
              ? _sunriseRow(entry)
              : _prayerRow(l10n, times, entry, tracker, showTracker),
      ],
    );
  }

  /// Sunrise is informational — it marks the end of the Fajr window rather than
  /// a prayer — so it has no jamaat line, no tracker circle and muted type.
  Widget _sunriseRow(PrayerTimeEntry entry) {
    return GroupedRow(
      title: appLocalization.prayerSunrise,
      titleStyle: DuskText.bangla(
        size: AppValues.fontSize_14_5,
        weight: FontWeight.w600,
        color: AppColors.inkMuted,
      ),
      leading: const DuskIconChip(
        icon: PhosphorIconsRegular.sun,
        background: AppColors.sunriseChip,
        foreground: AppColors.sunriseChipInk,
      ),
      value: formatClock(entry.time),
      valueStyle: DuskText.bangla(
        size: AppValues.fontSize_15,
        weight: FontWeight.w600,
        color: AppColors.inkMuted,
      ),
      // Keeps the times column aligned with the rows that do carry a circle.
      trailing: const SizedBox(width: AppValues.trackerCircleSmall),
    );
  }

  Widget _prayerRow(
    AppLocalizations l10n,
    DayPrayerTimes times,
    PrayerTimeEntry entry,
    TrackerController? tracker,
    bool showTracker,
  ) {
    final isNext = times.next == entry.name && controller.isShowingToday;
    final isCurrent = times.current == entry.name && controller.isShowingToday;
    final chip = _chipFor(entry.name);
    final jamaat = controller.jamaatTimeFor(
      entry.name,
      date: controller.selectedDate.value,
    );

    return GroupedRow(
      title: _label(l10n, entry.name),
      subtitle: _subtitleFor(l10n, times, entry, jamaat, isNext, isCurrent),
      leading: DuskIconChip(
        icon: chip.icon,
        background: chip.background,
        foreground: chip.foreground,
      ),
      value: formatClock(entry.time),
      tinted: isNext,
      trailing: showTracker && tracker != null
          ? Obx(
              () => TrackerCircle(
                size: AppValues.trackerCircleSmall,
                state: tracker.stateFor(entry.name),
                semanticLabel: _label(l10n, entry.name),
                onTap: tracker.canLog(entry.name)
                    ? () => tracker.togglePrayerLogged(entry.name)
                    : null,
              ),
            )
          : const SizedBox(width: AppValues.trackerCircleSmall),
    );
  }

  String _subtitleFor(
    AppLocalizations l10n,
    DayPrayerTimes times,
    PrayerTimeEntry entry,
    DateTime? jamaat,
    bool isNext,
    bool isCurrent,
  ) {
    if (isNext) {
      return jamaat == null
          ? l10n.nextWindow
          : l10n.nextWindowWithJamaat(formatClock(jamaat));
    }
    if (isCurrent) {
      return jamaat == null
          ? l10n.runningNow
          : '${l10n.jamaatOnly(formatClock(jamaat))} · ${l10n.runningNow}';
    }

    // Fajr is the one window whose end matters day to day — it closes at
    // sunrise, and people plan around that.
    if (entry.name == PrayerName.fajr) {
      final sunrise = times.entryFor(PrayerName.sunrise)?.time;
      if (sunrise != null && jamaat != null) {
        return l10n.jamaatAndEnd(formatClock(jamaat), formatClock(sunrise));
      }
      if (sunrise != null) return l10n.endsAt(formatClock(sunrise));
    }

    return jamaat == null
        ? l10n.jamaatUnknown
        : l10n.jamaatOnly(formatClock(jamaat));
  }

  _PrayerChip _chipFor(PrayerName name) => switch (name) {
        PrayerName.fajr => const _PrayerChip(
            PhosphorIconsRegular.sunHorizon,
            AppColors.fajrChip,
            AppColors.fajrChipInk,
          ),
        PrayerName.sunrise => const _PrayerChip(
            PhosphorIconsRegular.sun,
            AppColors.sunriseChip,
            AppColors.sunriseChipInk,
          ),
        PrayerName.dhuhr => const _PrayerChip(
            PhosphorIconsRegular.sun,
            AppColors.dhuhrChip,
            AppColors.dhuhrChipInk,
          ),
        PrayerName.asr => const _PrayerChip(
            PhosphorIconsRegular.cloudSun,
            AppColors.asrChip,
            AppColors.asrChipInk,
          ),
        PrayerName.maghrib => const _PrayerChip(
            PhosphorIconsRegular.sunHorizon,
            AppColors.maghribChip,
            AppColors.maghribChipInk,
          ),
        PrayerName.isha => const _PrayerChip(
            PhosphorIconsRegular.moon,
            AppColors.ishaChip,
            AppColors.ishaChipInk,
          ),
      };

  Widget _listSkeleton() {
    return GroupedCard(
      children: [
        for (var i = 0; i < 6; i++)
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppValues.rowPaddingV,
              horizontal: AppValues.rowPaddingH,
            ),
            child: Row(
              children: [
                DuskSkeleton(
                  width: AppValues.iconChip,
                  height: AppValues.iconChip,
                  radius: DuskRadius.iconChip,
                ),
                SizedBox(width: AppValues.space_12),
                Expanded(child: DuskSkeleton.line(height: AppValues.space_18)),
                SizedBox(width: AppValues.space_12),
                DuskSkeleton(width: 46, height: AppValues.space_18),
              ],
            ),
          ),
      ],
    );
  }

  // ── Month tracker ─────────────────────────────────────────────────────────

  Widget _monthTracker(AppLocalizations l10n) {
    final tracker = _tracker;
    if (tracker == null) return const SizedBox.shrink();

    return DuskCard(
      radius: DuskRadius.card,
      shadow: AppColors.shadowCardRaised,
      child: Obx(() {
        final month = tracker.visibleMonth.value;
        final summary = tracker.summary.value;
        final log = tracker.monthLog;
        final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
        final today = DateTime.now();
        final isCurrentMonth =
            month.year == today.year && month.month == today.month;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.monthTracker(monthName(month.month)),
                    style: DuskText.cardHeading,
                  ),
                ),
                Text(
                  formatRatio(summary.monthCompleted, summary.monthPossible),
                  style: DuskText.bangla(
                    size: AppValues.fontSize_12_5,
                    weight: FontWeight.w700,
                    color: AppColors.goldOnIvory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.groupGap),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daysInMonth,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15,
                mainAxisSpacing: AppValues.gap_4,
                crossAxisSpacing: AppValues.gap_4,
              ),
              itemBuilder: (context, index) {
                final day = index + 1;
                return _HeatCell(
                  completed: log[day]?.completed ?? 0,
                  isToday: isCurrentMonth && day == today.day,
                );
              },
            ),
            const SizedBox(height: AppValues.space_12),
            _legend(l10n),
          ],
        );
      }),
    );
  }

  Widget _legend(AppLocalizations l10n) {
    Widget swatch(Color color) => Container(
          width: AppValues.space_11,
          height: AppValues.space_11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppValues.space_3),
          ),
        );

    final style = DuskText.caption.copyWith(color: AppColors.inkMuted);

    return Row(
      children: [
        swatch(AppColors.duskMid),
        const SizedBox(width: AppValues.space_7),
        Text(l10n.legendAllFive, style: style),
        const SizedBox(width: AppValues.gapXSmall),
        swatch(AppColors.trackPartial),
        const SizedBox(width: AppValues.space_7),
        Text(l10n.legendPartial, style: style),
        const SizedBox(width: AppValues.gapXSmall),
        swatch(AppColors.trackEmpty),
        const SizedBox(width: AppValues.space_7),
        Text(l10n.legendPending, style: style),
      ],
    );
  }

  // ── Settings rows ─────────────────────────────────────────────────────────

  Widget _settingsCard(AppLocalizations l10n) {
    return GroupedCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.gap_4,
        horizontal: AppValues.gap_6,
      ),
      children: [
        GroupedRow(
          title: l10n.calculationAndOffsets,
          titleStyle: DuskText.rowLabel.copyWith(color: AppColors.ink),
          leading: const DuskIconChip(
            icon: PhosphorIconsRegular.slidersHorizontal,
          ),
          value: _methodShortLabel(l10n, controller.method.value),
          valueStyle: DuskText.rowTrailing.copyWith(color: AppColors.inkMuted),
          chevron: true,
          onTap: () => Get.toNamed(Routes.prayerSettings),
        ),
        GroupedRow(
          title: l10n.adhanAndReminders,
          titleStyle: DuskText.rowLabel.copyWith(color: AppColors.ink),
          leading: const DuskIconChip(icon: PhosphorIconsRegular.bellRinging),
          chevron: true,
          onTap: () => Get.toNamed(Routes.adhanSettings),
        ),
      ],
    );
  }

  String _label(AppLocalizations l10n, PrayerName name) => switch (name) {
        PrayerName.fajr => l10n.prayerFajr,
        PrayerName.sunrise => l10n.prayerSunrise,
        PrayerName.dhuhr => l10n.prayerDhuhr,
        PrayerName.asr => l10n.prayerAsr,
        PrayerName.maghrib => l10n.prayerMaghrib,
        PrayerName.isha => l10n.prayerIsha,
      };

  /// The row shows only the method's short name — the full name with its
  /// parenthetical belongs on the settings screen where there is room.
  String _methodShortLabel(
    AppLocalizations l10n,
    PrayerCalculationMethod method,
  ) =>
      switch (method) {
        PrayerCalculationMethod.karachi => l10n.methodKarachiShort,
        PrayerCalculationMethod.muslimWorldLeague => l10n.methodMwl,
        PrayerCalculationMethod.egyptian => l10n.methodEgyptian,
        PrayerCalculationMethod.ummAlQura => l10n.methodUmmAlQura,
        PrayerCalculationMethod.northAmerica => l10n.methodNorthAmerica,
        PrayerCalculationMethod.dubai => l10n.methodDubai,
        PrayerCalculationMethod.qatar => l10n.methodQatar,
        PrayerCalculationMethod.kuwait => l10n.methodKuwait,
        PrayerCalculationMethod.singapore => l10n.methodSingapore,
        PrayerCalculationMethod.turkiye => l10n.methodTurkiye,
      };

  static double _screenPadding(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppValues.breakpointNarrow
          ? AppValues.screenPaddingTight
          : AppValues.screenPadding;
}

class _PrayerChip {
  const _PrayerChip(this.icon, this.background, this.foreground);

  final IconData icon;
  final Color background;
  final Color foreground;
}

/// One day in the month heatmap.
class _HeatCell extends StatelessWidget {
  const _HeatCell({required this.completed, required this.isToday});

  final int completed;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    // Today is gold whatever its count: the eye should find "where am I" in
    // the grid before it reads any history.
    final color = isToday
        ? AppColors.gold
        : switch (completed) {
            >= 5 => AppColors.duskMid,
            4 => AppColors.trackPartialStrong,
            >= 2 => AppColors.trackPartial,
            _ => AppColors.trackEmpty,
          };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppValues.gap_4),
      ),
    );
  }
}
