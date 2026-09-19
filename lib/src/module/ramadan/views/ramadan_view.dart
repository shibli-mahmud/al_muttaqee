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
import 'package:al_muttaqee/src/module/ramadan/controllers/ramadan_controller.dart';

/// রমজান মোড — frame ২০.
///
/// The amber family runs through the whole screen, not just the hero, so
/// Ramadan reads as a season the app has entered rather than a page inside it.
class RamadanView extends BaseView<RamadanController> {
  RamadanView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  /// The Maghrib/amber theme, at the stronger pattern the design calls for.
  static final DuskHeroTheme _amber =
      DuskHeroTheme.maghrib.copyWithPattern(0.15);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(
      () => Column(
        children: [
          _hero(l10n),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.cardPadding,
                AppValues.screenPadding,
                AppValues.space_24,
              ),
              children: [
                _rozaTracker(l10n),
                const SizedBox(height: AppValues.cardGap),
                _rows(l10n),
                const SizedBox(height: AppValues.groupGap),
                _shareButton(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _hero(AppLocalizations l10n) {
    final toIftar = controller.countingToIftar.value;

    return DuskHero(
      theme: _amber,
      paddingBottom: AppValues.space_22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuskHeroTitleRow(
            title: l10n.tileRamadan,
            theme: _amber,
            onBack: Get.back,
            actions: [
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.shareNetwork,
                theme: _amber,
                semanticLabel: l10n.ramadanShare,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppValues.space_18),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.heroPadding,
            ),
            child: Column(
              children: [
                Text(
                  controller.isRamadan.value
                      ? l10n.ramadanCountdownLabel(
                          formatNumberWithLocale(controller.rozaDay.value),
                          toIftar
                              ? l10n.ramadanUntilIftar
                              : l10n.ramadanUntilSehri,
                        )
                      : toIftar
                          ? l10n.ramadanUntilIftar
                          : l10n.ramadanUntilSehri,
                  textAlign: TextAlign.center,
                  style: DuskText.overlineHero
                      .copyWith(color: AppColors.ramadanAccent),
                ),
                Text(
                  formatCountdown(controller.remaining.value),
                  style: DuskText.countdownLarge
                      .copyWith(color: AppColors.ramadanOnPrimary),
                ),
                const SizedBox(height: AppValues.groupGap),
                _timeCards(l10n, toIftar),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sehri and iftar side by side. The imminent one is filled, so a glance
  /// answers "which of these is next" without reading either time.
  Widget _timeCards(AppLocalizations l10n, bool toIftar) {
    final sehri = controller.sehriEnd;
    final iftar = controller.iftar;

    return Row(
      children: [
        Expanded(
          child: _TimeCard(
            label: l10n.sehriEnds,
            value: sehri == null ? '—' : formatClock(sehri),
            filled: !toIftar,
          ),
        ),
        const SizedBox(width: AppValues.cardGapWide),
        Expanded(
          child: _TimeCard(
            label: l10n.iftar,
            value: iftar == null ? '—' : formatClock(iftar),
            filled: toIftar,
          ),
        ),
      ],
    );
  }

  // ── Roza tracker ──────────────────────────────────────────────────────────

  Widget _rozaTracker(AppLocalizations l10n) {
    return DuskCard(
      radius: DuskRadius.card,
      shadow: AppColors.shadowCardRaised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.ramadanRozaTracker,
                    style: DuskText.cardHeading),
              ),
              Text(
                l10n.ramadanKeptRatio(
                  formatNumberWithLocale(controller.rozaKept),
                  formatNumberWithLocale(controller.rozaDay.value),
                ),
                style: DuskText.bangla(
                  size: AppValues.fontSize_12_5,
                  weight: FontWeight.w700,
                  color: AppColors.ramadanLabelOnLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.groupGap),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: AppValues.gap_5,
              crossAxisSpacing: AppValues.gap_5,
            ),
            itemBuilder: (context, index) {
              final day = index + 1;
              return _RozaCell(
                day: day,
                today: day == controller.rozaDay.value,
                future: day > controller.rozaDay.value,
                kept: controller.rozaLog[day] ?? false,
                onTap: () => controller.toggleRoza(day),
              );
            },
          ),
          const SizedBox(height: AppValues.space_12),
          _legend(l10n),
        ],
      ),
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
        swatch(AppColors.ramadanMid),
        const SizedBox(width: AppValues.space_7),
        Text(l10n.ramadanKept, style: style),
        const SizedBox(width: AppValues.gapXSmall),
        swatch(AppColors.ramadanMissed),
        const SizedBox(width: AppValues.space_7),
        Text(l10n.ramadanMissed, style: style),
        const SizedBox(width: AppValues.gapXSmall),
        swatch(AppColors.trackEmpty),
        const SizedBox(width: AppValues.space_7),
        Text(l10n.legendPending, style: style),
      ],
    );
  }

  // ── Rows ──────────────────────────────────────────────────────────────────

  Widget _rows(AppLocalizations l10n) {
    final rakats = controller.taraweehLog[controller.rozaDay.value] ?? 0;

    return Column(
      children: [
        DuskCard(
          radius: DuskRadius.cardTight,
          onTap: () => controller.setTaraweeh(rakats > 0 ? 0 : 20),
          child: Row(
            children: [
              const DuskIconChip(
                icon: PhosphorIconsRegular.moonStars,
                size: AppValues.tileIconChip,
                radius: DuskRadius.iconChipLarge - 1,
                background: AppColors.ishaChip,
                foreground: AppColors.ishaChipInk,
                iconSize: AppValues.icon_19,
              ),
              const SizedBox(width: AppValues.space_13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.ramadanTaraweeh, style: DuskText.cardHeading),
                    Text(
                      rakats > 0
                          ? l10n.ramadanTaraweehDone(
                              formatNumberWithLocale(rakats),
                              formatNumberWithLocale(
                                controller.taraweehStreak,
                              ),
                            )
                          : l10n.ramadanTaraweehPending,
                      style: DuskText.rowSubtitle
                          .copyWith(color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: rakats > 0
                      ? AppColors.ramadanMid
                      : AppColors.neutralFill,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  PhosphorIconsBold.check,
                  size: AppValues.iconSmall,
                  color: rakats > 0
                      ? AppColors.ramadanOnPrimary
                      : AppColors.dashedBorder,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppValues.cardGap),
        DuskCard(
          radius: DuskRadius.cardTight,
          onTap: () => Get.toNamed(Routes.readingPlan),
          child: Row(
            children: [
              const DuskIconChip(
                icon: PhosphorIconsRegular.bookOpenText,
                size: AppValues.tileIconChip,
                radius: DuskRadius.iconChipLarge - 1,
                iconSize: AppValues.icon_19,
              ),
              const SizedBox(width: AppValues.space_13),
              Expanded(
                child: Text(
                  l10n.ramadanKhatmProgress,
                  style: DuskText.cardHeading,
                ),
              ),
              const Icon(
                PhosphorIconsRegular.caretRight,
                size: AppValues.icon_17,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppValues.cardGap),
        DuskCard(
          radius: DuskRadius.cardTight,
          onTap: () => Get.toNamed(Routes.zakat),
          child: Row(
            children: [
              const DuskIconChip(
                icon: PhosphorIconsRegular.handCoins,
                size: AppValues.tileIconChip,
                radius: DuskRadius.iconChipLarge - 1,
                background: AppColors.goldTint,
                foreground: AppColors.goldOnIvory,
                iconSize: AppValues.icon_19,
              ),
              const SizedBox(width: AppValues.space_13),
              Expanded(
                child: Text(
                  l10n.ramadanFitraZakat,
                  style: DuskText.cardHeading,
                ),
              ),
              const Icon(
                PhosphorIconsRegular.caretRight,
                size: AppValues.icon_17,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shareButton(AppLocalizations l10n) {
    return DuskPrimaryButton(
      label: l10n.ramadanShareSchedule,
      icon: PhosphorIconsRegular.shareNetwork,
      background: AppColors.ramadanMid,
      foreground: AppColors.ramadanOnPrimary,
      shadow: const [],
      onPressed: () {},
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.value,
    required this.filled,
  });

  final String label;
  final String value;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_13,
        horizontal: AppValues.cardPadding,
      ),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.ramadanAccent
            : AppColors.ramadanOnPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(DuskRadius.cardSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DuskText.bangla(
              size: AppValues.fontSize_11_5,
              weight: FontWeight.w700,
              color: filled
                  ? AppColors.ramadanAccentLabel
                  : AppColors.ramadanOnMuted,
            ),
          ),
          Text(
            value,
            style: DuskText.bangla(
              size: AppValues.fontSize_21,
              weight: FontWeight.w700,
              color: filled
                  ? AppColors.ramadanAccentInk
                  : AppColors.ramadanOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RozaCell extends StatelessWidget {
  const _RozaCell({
    required this.day,
    required this.today,
    required this.future,
    required this.kept,
    required this.onTap,
  });

  final int day;
  final bool today;
  final bool future;
  final bool kept;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (background, ink) = switch (true) {
      _ when today => (AppColors.ramadanAccent, AppColors.ramadanAccentInk),
      _ when kept => (AppColors.ramadanMid, AppColors.ramadanOnPrimary),
      _ when future => (AppColors.trackEmpty, AppColors.baseTransparent),
      _ => (AppColors.ramadanMissed, AppColors.ramadanOnPrimary),
    };

    return GestureDetector(
      onTap: future ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppValues.gap_6),
        ),
        alignment: Alignment.center,
        child: Text(
          // A future day carries no number: there is nothing to report yet,
          // and an empty cell reads as "not yet" rather than "missed".
          future ? '' : formatNumberWithLocale(day),
          style: DuskText.bangla(
            size: AppValues.fontSize_10,
            weight: FontWeight.w700,
            color: ink,
          ),
        ),
      ),
    );
  }
}
