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
import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';
import 'package:al_muttaqee/src/module/tasbih/models/tasbih_models.dart';

/// The last thirty days of dhikr.
///
/// The point of keeping the log is to be able to show this: a counter that
/// forgets gives someone a number, and a counter that remembers gives them a
/// habit they can see.
class TasbihHistoryView extends BaseView<TasbihController> {
  TasbihHistoryView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const theme = DuskHeroTheme.day;

    return Column(
      children: [
        DuskHero(
          theme: theme,
          child: DuskHeroTitleRow(
            title: l10n.tasbihHistoryTitle,
            theme: theme,
            onBack: Get.back,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<DhikrDay>>(
            future: controller.history(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return ListView.builder(
                  padding: const EdgeInsets.all(AppValues.screenPadding),
                  itemCount: 6,
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: AppValues.cardGap),
                    child: DuskSkeleton(
                      width: double.infinity,
                      height: 60,
                      radius: DuskRadius.cardSmall,
                    ),
                  ),
                );
              }

              final days = snapshot.data ?? const <DhikrDay>[];
              final active =
                  days.where((day) => !day.isEmpty).toList(growable: false);

              if (active.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppValues.space_34),
                    child: DuskEmptyState(
                      icon: PhosphorIconsRegular.handsPraying,
                      message: l10n.tasbihNoHistory,
                      actionLabel: l10n.tasbihStartCounting,
                      onAction: Get.back,
                    ),
                  ),
                );
              }

              final best = active
                  .map((day) => day.total)
                  .reduce((a, b) => a > b ? a : b);

              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppValues.screenPadding,
                  AppValues.cardPadding,
                  AppValues.screenPadding,
                  AppValues.space_24,
                ),
                children: [
                  _summaryCard(l10n, active),
                  const SizedBox(height: AppValues.groupGap),
                  DuskOverline(l10n.tasbihLast30Days),
                  GroupedCard(
                    children: [
                      for (final day in active)
                        _DayRow(day: day, best: best, l10n: l10n),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(AppLocalizations l10n, List<DhikrDay> days) {
    final total = days.fold<int>(0, (sum, day) => sum + day.total);

    return DuskCard(
      child: Row(
        children: [
          Expanded(
            child: _Figure(
              label: l10n.tasbihDaysCounted,
              value: formatNumberWithLocale(days.length),
            ),
          ),
          Container(
            width: 1,
            height: 34,
            color: AppColors.hairline,
          ),
          Expanded(
            child: _Figure(
              label: l10n.tasbihTotalCounted,
              value: formatGrouped(total),
            ),
          ),
          Container(
            width: 1,
            height: 34,
            color: AppColors.hairline,
          ),
          Expanded(
            child: _Figure(
              label: l10n.tasbihStreak,
              value: formatNumberWithLocale(
                controller.summary.value.streak,
              ),
              highlighted: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: DuskText.bangla(
            size: AppValues.fontSize_21,
            weight: FontWeight.w700,
            color: highlighted ? AppColors.goldOnIvory : AppColors.ink,
          ),
        ),
        const SizedBox(height: AppValues.gap_2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: DuskText.caption.copyWith(color: AppColors.inkMuted),
        ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.best,
    required this.l10n,
  });

  final DhikrDay day;

  /// The busiest day in the window, which sets the bar scale.
  final int best;

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final fraction = best <= 0 ? 0.0 : day.total / best;
    final top = day.counts.entries.isEmpty
        ? null
        : day.counts.entries.reduce((a, b) => a.value >= b.value ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_11,
        horizontal: AppValues.rowPaddingH,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatDayMonth(day.date), style: DuskText.rowLabel),
                Text(
                  weekdayName(day.date),
                  style: DuskText.caption.copyWith(color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(DuskRadius.chip),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: AppValues.gap_6,
                    backgroundColor: AppColors.trackEmpty,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.duskMid),
                  ),
                ),
                if (top != null) ...[
                  const SizedBox(height: AppValues.gap_4),
                  Text(
                    presetFor(top.key).bangla,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        DuskText.caption.copyWith(color: AppColors.inkMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppValues.space_12),
          Text(
            formatGrouped(day.total),
            style: DuskText.bangla(
              size: AppValues.fontSize_15_5,
              weight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
