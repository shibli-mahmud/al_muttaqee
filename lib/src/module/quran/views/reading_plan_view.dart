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
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_library_models.dart';

/// দৈনিক পাঠ পরিকল্পনা — frame ১৪.
///
/// The plan is the difference between an app somebody opens in Ramadan and one
/// they open in Safar. Every option here is a rate somebody actually keeps,
/// with the consequence spelled out — "a khatm in about eleven months" — so
/// the choice is made with its arithmetic visible.
class ReadingPlanView extends BaseView<QuranController> {
  ReadingPlanView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  static const List<ReadingPlan> _options = [
    ReadingPlan(type: ReadingPlanType.ayahs, target: 20),
    ReadingPlan(type: ReadingPlanType.para, target: 1),
    ReadingPlan(type: ReadingPlanType.minutes, target: 10),
    ReadingPlan(type: ReadingPlanType.weekly, target: 1),
  ];

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const theme = DuskHeroTheme.day;

    return Obx(
      () => Column(
        children: [
          DuskHero(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuskHeroTitleRow(
                  title: l10n.quranPlanTitle,
                  theme: theme,
                  onBack: Get.back,
                ),
                const SizedBox(height: AppValues.space_18),
                _todayBlock(l10n, theme),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.cardPadding,
                AppValues.screenPadding,
                AppValues.space_24,
              ),
              children: [
                _heatmapCard(l10n),
                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.quranChoosePlan),
                for (final option in _options)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.cardGap),
                    child: _PlanCard(
                      plan: option,
                      selected: controller.plan.value.type == option.type &&
                          controller.plan.value.target == option.target,
                      l10n: l10n,
                      onTap: () => controller.setPlan(option),
                    ),
                  ),
                const SizedBox(height: AppValues.gapXSmall),
                DuskPrimaryButton(
                  label: l10n.quranStartTodaysReading,
                  icon: PhosphorIconsRegular.arrowRight,
                  onPressed: () {
                    Get.back<void>();
                    final surah = controller.lastReadSurah ??
                        controller.surahs.first;
                    controller.openSurah(
                      surah,
                      ayah: controller.lastReadAyah > 0
                          ? controller.lastReadAyah
                          : 1,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Today's target, big, in the hero.
  Widget _todayBlock(AppLocalizations l10n, DuskHeroTheme theme) {
    final plan = controller.plan.value;
    final progress = controller.planProgress ?? 0;
    final done = plan.type == ReadingPlanType.minutes
        ? controller.todayProgress.value.minutesRead
        : controller.todayProgress.value.ayahsRead;
    final target = plan.type == ReadingPlanType.minutes
        ? plan.target
        : plan.dailyAyahTarget;
    final remaining = (target - done).clamp(0, target);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.heroPadding),
      child: Column(
        children: [
          Text(
            l10n.quranTodaysGoal,
            style: DuskText.overlineHero.copyWith(color: theme.accent),
          ),
          const SizedBox(height: AppValues.gap_4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatNumberWithLocale(done),
                style: DuskText.countdownLarge.copyWith(
                  fontSize: AppValues.fontSize_56,
                  color: theme.onPrimary,
                ),
              ),
              const SizedBox(width: AppValues.gap_6),
              Text(
                target > 0
                    ? '/ ${formatNumberWithLocale(target)} '
                        '${plan.type == ReadingPlanType.minutes ? l10n.quranMinutesUnit : l10n.quranAyahUnit}'
                    : l10n.quranNoPlanYet,
                style: DuskText.bangla(
                  size: AppValues.fontSize_20,
                  weight: FontWeight.w700,
                  color: theme.onMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.gapSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(DuskRadius.chip),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor:
                  AppColors.onDeepPrimary.withValues(alpha: 0.20),
              valueColor: AlwaysStoppedAnimation(theme.accent),
            ),
          ),
          const SizedBox(height: AppValues.gapSmall),
          Text(
            target <= 0
                ? l10n.quranPickAPlanPrompt
                : remaining <= 0
                    ? l10n.quranGoalDone
                    : l10n.quranRemainingToday(
                        formatNumberWithLocale(remaining),
                        formatNumberWithLocale(
                          (remaining / ayahsPerMinute).ceil(),
                        ),
                      ),
            textAlign: TextAlign.center,
            style: DuskText.bangla(
              size: AppValues.fontSize_13,
              weight: FontWeight.w600,
              color: theme.onMuted,
            ),
          ),
        ],
      ),
    );
  }

  /// Thirty days, ten to a row.
  Widget _heatmapCard(AppLocalizations l10n) {
    return DuskCard(
      radius: DuskRadius.card,
      shadow: AppColors.shadowCardRaised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuskOverline(l10n.quranLast30Days, padding: EdgeInsets.zero),
          const SizedBox(height: AppValues.gapSmall),
          FutureBuilder<List<ReadingDay>>(
            future: controller.readingHistory(),
            builder: (context, snapshot) {
              final days = snapshot.data;
              if (days == null) {
                return const DuskSkeleton(
                  width: double.infinity,
                  height: 96,
                  radius: DuskRadius.iconChip,
                );
              }

              // Newest last, so the grid reads left-to-right through time.
              final ordered = days.reversed.toList();
              final best = ordered
                  .map((d) => d.ayahsRead)
                  .fold<int>(1, (a, b) => a > b ? a : b);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ordered.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: AppValues.gap_5,
                  crossAxisSpacing: AppValues.gap_5,
                ),
                itemBuilder: (context, index) {
                  final day = ordered[index];
                  final isToday = index == ordered.length - 1;
                  final ratio = day.ayahsRead / best;

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: day.isEmpty
                          ? AppColors.trackEmpty
                          : Color.lerp(
                              AppColors.trackPartial,
                              AppColors.duskMid,
                              ratio,
                            ),
                      borderRadius: BorderRadius.circular(AppValues.gap_5),
                      // Today is an outline rather than a fill, so an
                      // unfinished today does not read as a missed one.
                      border: isToday
                          ? Border.all(color: AppColors.gold, width: 2)
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
    required this.l10n,
  });

  final ReadingPlan plan;
  final bool selected;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = _copy();

    return DuskCard(
      radius: DuskRadius.cardTight,
      color: selected ? AppColors.goldTintCard : AppColors.surface,
      border: selected ? Border.all(color: AppColors.goldTintBorder) : null,
      shadow: selected ? const [] : AppColors.shadowCard,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DuskText.cardHeading.copyWith(
                    color: selected ? AppColors.goldTintInk : AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: DuskText.rowSubtitle.copyWith(
                    color: selected
                        ? AppColors.goldTintInkSoft
                        : AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.gapSmall),
          Icon(
            selected
                ? PhosphorIconsFill.checkCircle
                : PhosphorIconsRegular.circle,
            size: AppValues.icon_22,
            color: selected ? AppColors.goldOnIvory : AppColors.dashedBorder,
          ),
        ],
      ),
    );
  }

  (String, String) _copy() {
    switch (plan.type) {
      case ReadingPlanType.ayahs:
        final months = ((plan.daysToKhatm ?? 0) / 30).round();
        return (
          l10n.quranPlanAyahs(formatNumberWithLocale(plan.target)),
          l10n.quranPlanAyahsDetail(formatNumberWithLocale(months)),
        );
      case ReadingPlanType.para:
        return (
          l10n.quranPlanPara(formatNumberWithLocale(plan.target)),
          l10n.quranPlanParaDetail,
        );
      case ReadingPlanType.minutes:
        return (
          l10n.quranPlanMinutes(formatNumberWithLocale(plan.target)),
          l10n.quranPlanMinutesDetail,
        );
      case ReadingPlanType.weekly:
        return (l10n.quranPlanWeekly, l10n.quranPlanWeeklyDetail);
    }
  }
}
