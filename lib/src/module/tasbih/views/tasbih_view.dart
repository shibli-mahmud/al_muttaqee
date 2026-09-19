import 'dart:math' as math;

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
import 'package:al_muttaqee/src/module/tasbih/views/tasbih_bead_ring.dart';

/// তাসবিহ — frame ০৭.
///
/// A counter is one interaction repeated a hundred times, so everything here
/// serves the tap: the target is the whole card rather than a small button,
/// the ring shows the round without asking anyone to read a number, and each
/// count carries a haptic so it works with the eyes closed.
class TasbihView extends BaseView<TasbihController> {
  TasbihView({super.key});

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

    return Obx(
      () => Column(
        children: [
          _hero(l10n),
          Expanded(
            child: ListView(
              // Negative top padding pulls the counter card up over the
              // gradient edge, the way the design overlaps them.
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                0,
                AppValues.screenPadding,
                AppValues.space_24,
              ),
              children: [
                Transform.translate(
                  offset: const Offset(0, -AppValues.space_18),
                  child: _counterCard(context, l10n),
                ),
                _actionRow(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _hero(AppLocalizations l10n) {
    const theme = DuskHeroTheme.day;
    final dhikr = controller.activeDhikr.value;

    return DuskHero(
      theme: theme,
      paddingBottom: AppValues.space_34,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuskHeroTitleRow(
            title: l10n.navTasbih,
            theme: theme,
            large: true,
            actions: [
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.clockCounterClockwise,
                theme: theme,
                semanticLabel: l10n.tasbihHistoryTitle,
                onTap: controller.openHistory,
              ),
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.vibrate,
                theme: theme,
                filled: controller.hapticsEnabled.value,
                semanticLabel: l10n.tasbihHaptics,
                onTap: controller.toggleHaptics,
              ),
            ],
          ),
          const SizedBox(height: AppValues.groupGap),
          _presetChips(theme),
          const SizedBox(height: AppValues.space_20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.heroPadding,
            ),
            child: Column(
              children: [
                Text(
                  dhikr.arabic,
                  textAlign: TextAlign.center,
                  style: DuskText.arabic(size: AppValues.fontSize_36,
                          height: 1.5)
                      .copyWith(color: theme.onPrimary),
                ),
                const SizedBox(height: AppValues.gap_4),
                Text(
                  '${dhikr.bangla} · '
                  '${l10n.tasbihTimes(formatNumberWithLocale(controller.target.value))}',
                  textAlign: TextAlign.center,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_13_5,
                    weight: FontWeight.w500,
                    color: theme.onMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _presetChips(DuskHeroTheme theme) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.heroPadding,
        ),
        itemCount: dhikrPresets.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppValues.space_7),
        itemBuilder: (context, index) {
          final preset = dhikrPresets[index];
          final active = preset.id == controller.activeDhikr.value.id;
          return DuskPill(
            label: preset.bangla,
            background: active
                ? theme.accent
                : AppColors.onDeepPrimary.withValues(alpha: 0.14),
            foreground: active ? theme.accentInk : theme.onPrimary,
            style: DuskText.bangla(
              size: AppValues.fontSize_12_5,
              weight: active ? FontWeight.w700 : FontWeight.w600,
            ),
            onTap: () => controller.selectDhikr(preset),
          );
        },
      ),
    );
  }

  // ── Counter ───────────────────────────────────────────────────────────────

  Widget _counterCard(BuildContext context, AppLocalizations l10n) {
    final width = MediaQuery.sizeOf(context).width;
    // The design sets 116; below that the digits crowd the card's padding on
    // narrow phones, so it scales with the width instead of clipping.
    final counterSize = math.min(AppValues.fontSize_116, width * 0.30);

    return Semantics(
      button: true,
      label: l10n.tasbihCountAction,
      value: formatNumberWithLocale(controller.count.value),
      // The ring itself takes the tap and the drag; the card around it is just
      // the surface, so a stray touch on the stat tiles does not count a bead.
      child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppValues.space_26,
            horizontal: AppValues.space_22,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(DuskRadius.counter),
            boxShadow: AppColors.shadowCounter,
          ),
          child: Column(
            children: [
              _CompletionFlare(
                pulse: controller.roundJustCompleted.value,
                child: TasbihBeadRing(
                  count: controller.count.value,
                  target: controller.target.value,
                  onAdvance: controller.increment,
                  onRewind: controller.decrement,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatNumberWithLocale(controller.count.value),
                        style: DuskText.counter(counterSize)
                            .copyWith(color: AppColors.duskDeep),
                      ),
                      Text(
                        l10n.tasbihOfTarget(
                          formatNumberWithLocale(controller.progressInRound),
                          formatNumberWithLocale(controller.target.value),
                        ),
                        style: DuskText.bangla(
                          size: AppValues.fontSize_13,
                          weight: FontWeight.w600,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppValues.space_18),
              _statTiles(l10n),
            ],
          ),
      ),
    );
  }

  Widget _statTiles(AppLocalizations l10n) {
    final summary = controller.summary.value;

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: l10n.tasbihTodayTotal,
            value: formatNumberWithLocale(summary.todayTotal),
          ),
        ),
        const SizedBox(width: AppValues.gapXSmall),
        Expanded(
          child: _StatTile(
            label: l10n.tasbihRounds,
            value: formatNumberWithLocale(summary.todayRounds),
          ),
        ),
        const SizedBox(width: AppValues.gapXSmall),
        Expanded(
          child: _StatTile(
            label: l10n.tasbihStreak,
            value: formatNumberWithLocale(summary.streak),
            highlighted: true,
          ),
        ),
      ],
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Widget _actionRow(AppLocalizations l10n) {
    return Row(
      children: [
        _CircleAction(
          icon: PhosphorIconsRegular.arrowCounterClockwise,
          semanticLabel: l10n.tasbihReset,
          onTap: () => _confirmReset(l10n),
        ),
        const SizedBox(width: AppValues.space_12),
        Expanded(
          child: Material(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(AppValues.space_28 + 2),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppValues.space_28 + 2),
                boxShadow: AppColors.shadowGold,
              ),
              child: InkWell(
                onTap: controller.increment,
                // Long-press undoes a miscount without a separate control,
                // which keeps the action row to three things.
                onLongPress: controller.decrement,
                splashColor: AppColors.goldPressed.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppValues.space_22,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        PhosphorIconsBold.plus,
                        size: AppValues.icon_28,
                        color: AppColors.goldInk,
                      ),
                      const SizedBox(width: AppValues.gapSmall),
                      Text(
                        l10n.tasbihCountAction,
                        style: DuskText.bangla(
                          size: AppValues.fontSize_14,
                          weight: FontWeight.w700,
                          color: AppColors.goldInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppValues.space_12),
        _CircleAction(
          icon: PhosphorIconsRegular.target,
          semanticLabel: l10n.tasbihSetGoal,
          onTap: () => _pickTarget(l10n),
        ),
      ],
    );
  }

  Future<void> _confirmReset(AppLocalizations l10n) async {
    // A reset throws away work, so it asks. Everything else here is one tap.
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DuskRadius.card),
        ),
        title: Text(l10n.tasbihResetTitle, style: DuskText.cardHeading),
        content: Text(
          l10n.tasbihResetBody,
          style: DuskText.bodySmall.copyWith(color: AppColors.inkSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: Text(
              l10n.cancel,
              style: DuskText.rowLabel.copyWith(color: AppColors.inkMuted),
            ),
          ),
          TextButton(
            onPressed: () => Get.back<bool>(result: true),
            child: Text(
              l10n.tasbihReset,
              style: DuskText.rowLabel.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.resetCount();
  }

  Future<void> _pickTarget(AppLocalizations l10n) async {
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
          AppValues.space_12,
          AppValues.screenPadding,
          AppValues.space_24,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.grabHandle,
                    borderRadius: BorderRadius.circular(DuskRadius.chip),
                  ),
                ),
              ),
              const SizedBox(height: AppValues.space_18),
              Text(l10n.tasbihSetGoal, style: DuskText.cardHeading),
              const SizedBox(height: AppValues.gapSmall),
              Obx(
                () => GroupedCard(
                  children: [
                    for (final option in TasbihController.targetOptions)
                      GroupedRow(
                        title: l10n.tasbihTimes(
                          formatNumberWithLocale(option),
                        ),
                        titleStyle: DuskText.rowLabel.copyWith(
                          color: controller.target.value == option
                              ? AppColors.goldTintInk
                              : AppColors.ink,
                        ),
                        tinted: controller.target.value == option,
                        trailing: Icon(
                          controller.target.value == option
                              ? PhosphorIconsFill.checkCircle
                              : PhosphorIconsRegular.circle,
                          size: AppValues.icon_20,
                          color: controller.target.value == option
                              ? AppColors.goldOnIvory
                              : AppColors.dashedBorder,
                        ),
                        onTap: () {
                          controller.setTarget(option);
                          Get.back<void>();
                        },
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

/// A gold flare when a round completes.
///
/// The haptic tells the hand; this tells the eye. It is deliberately brief —
/// the point of the exercise is not to be watching the screen.
class _CompletionFlare extends StatefulWidget {
  const _CompletionFlare({required this.pulse, required this.child});

  final int pulse;
  final Widget child;

  @override
  State<_CompletionFlare> createState() => _CompletionFlareState();
}

class _CompletionFlareState extends State<_CompletionFlare>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flare = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );

  @override
  void didUpdateWidget(_CompletionFlare old) {
    super.didUpdateWidget(old);
    if (widget.pulse != old.pulse) _flare.forward(from: 0);
  }

  @override
  void dispose() {
    _flare.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flare,
      builder: (context, child) {
        if (_flare.value == 0 || _flare.isCompleted) return child!;
        final t = Curves.easeOut.transform(_flare.value);
        return Stack(
          alignment: Alignment.center,
          children: [
            child!,
            IgnorePointer(
              child: Opacity(
                opacity: (1 - t) * 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: 0.0),
                        AppColors.gold.withValues(alpha: 0.5),
                        AppColors.gold.withValues(alpha: 0.0),
                      ],
                      stops: [0.0, 0.55 + 0.4 * t, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_11,
        horizontal: AppValues.gapSmall,
      ),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.goldTint : AppColors.neutralFill,
        borderRadius: BorderRadius.circular(DuskRadius.inner),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DuskText.caption.copyWith(
              color:
                  highlighted ? AppColors.goldOnCanvas : AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: AppValues.gap_2),
          Text(
            value,
            style: DuskText.bangla(
              size: AppValues.fontSize_17,
              weight: FontWeight.w700,
              color: highlighted ? AppColors.goldTintInk : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;

  static const double _size = 58;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: AppColors.shadowCard,
          ),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: _size,
              height: _size,
              child: Icon(
                icon,
                size: AppValues.icon_22,
                color: AppColors.duskMid,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
