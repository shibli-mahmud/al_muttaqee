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
import 'package:al_muttaqee/src/module/qibla/controllers/qibla_controller.dart';
import 'package:al_muttaqee/src/module/qibla/views/qibla_dial.dart';

/// কিবলা — frame ০৮.
///
/// Full-bleed deep teal rather than a hero over ivory, because the compass is
/// the whole screen and a card around it would only make it smaller. The user
/// is holding the phone flat and turning on the spot; everything here is sized
/// to be readable in that posture, at arm's length.
class QiblaView extends BaseView<QiblaController> {
  QiblaView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.duskDeep;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // The khatim runs over the whole screen here, not just a hero band.
        const Positioned.fill(
          child: KhatimOverlay(ink: AppColors.onDeepPrimary, opacity: 0.10),
        ),
        SafeArea(
          child: Obx(() {
            if (controller.errorMessageKey.value.isNotEmpty) {
              return _error(l10n);
            }
            return _compass(context, l10n);
          }),
        ),
      ],
    );
  }

  // ── Compass ───────────────────────────────────────────────────────────────

  Widget _compass(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _titleRow(l10n),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.screenPadding,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppValues.gapSmall),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    QiblaDial(
                      heading: controller.heading.value,
                      qiblaBearing: controller.qiblaBearing.value,
                      closeness: controller.closeness,
                      aligned: controller.isAligned,
                    ),
                    _readout(l10n),
                  ],
                ),
                const SizedBox(height: AppValues.space_22),
                _statePill(l10n),
                const SizedBox(height: AppValues.space_18),
                _stats(l10n),
                const SizedBox(height: AppValues.space_18),
                if (controller.needsCalibration) _calibrationHint(l10n),
                const SizedBox(height: AppValues.space_24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleRow(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.heroPadding,
        AppValues.gapXSmall,
        AppValues.heroPadding,
        0,
      ),
      child: Row(
        children: [
          InkResponse(
            onTap: Get.back,
            radius: AppValues.space_24,
            child: const SizedBox(
              width: AppValues.minTapTarget,
              height: AppValues.minTapTarget,
              child: Icon(
                PhosphorIconsRegular.arrowLeft,
                size: AppValues.icon_21,
                color: AppColors.onDeepPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.qibla,
              style: DuskText.heroTitleBack
                  .copyWith(color: AppColors.onDeepPrimary),
            ),
          ),
          DuskHeroIconButton(
            icon: PhosphorIconsRegular.arrowsClockwise,
            theme: DuskHeroTheme.day,
            semanticLabel: l10n.qiblaRecalibrate,
            onTap: controller.start,
          ),
        ],
      ),
    );
  }

  /// The degrees, in the middle of the dial.
  Widget _readout(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${formatNumberWithLocale(controller.qiblaBearing.value.round())}°',
          style: DuskText.degrees.copyWith(color: AppColors.onDeepPrimary),
        ),
        Text(
          l10n.qiblaDirection,
          style: DuskText.bangla(
            size: AppValues.fontSize_12_5,
            weight: FontWeight.w500,
            color: AppColors.onDeepMuted,
          ),
        ),
      ],
    );
  }

  /// Says, in one line, whether the user is facing the qibla and what to do
  /// about it. The number above is the fact; this is the instruction.
  Widget _statePill(AppLocalizations l10n) {
    final aligned = controller.isAligned;
    final off = controller.offsetDegrees.abs().round();

    final label = switch (controller.turn) {
      QiblaTurn.aligned => l10n.qiblaAligned,
      QiblaTurn.left =>
        l10n.qiblaTurnLeft(formatNumberWithLocale(off)),
      QiblaTurn.right =>
        l10n.qiblaTurnRight(formatNumberWithLocale(off)),
    };

    final icon = switch (controller.turn) {
      QiblaTurn.aligned => PhosphorIconsBold.check,
      QiblaTurn.left => PhosphorIconsBold.arrowArcLeft,
      QiblaTurn.right => PhosphorIconsBold.arrowArcRight,
    };

    return AnimatedContainer(
      duration: AppValues.cardPress,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_12,
        horizontal: AppValues.space_20,
      ),
      decoration: BoxDecoration(
        color: aligned
            ? AppColors.gold
            : AppColors.onDeepPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(DuskRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppValues.icon_18,
            color: aligned ? AppColors.goldInk : AppColors.onDeepMuted,
          ),
          const SizedBox(width: AppValues.gapXSmall),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: DuskText.bangla(
                size: AppValues.fontSize_15,
                weight: FontWeight.w700,
                color: aligned ? AppColors.goldInk : AppColors.onDeepPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats(AppLocalizations l10n) {
    final accuracy = switch (controller.accuracy.value) {
      CompassAccuracy.high => l10n.qiblaAccuracyHigh,
      CompassAccuracy.medium => l10n.qiblaAccuracyMedium,
      CompassAccuracy.low => l10n.qiblaAccuracyLow,
      CompassAccuracy.unknown => l10n.qiblaAccuracyUnknown,
    };

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: l10n.qiblaDistanceLabel,
            value: l10n.qiblaKilometres(
              formatGrouped(controller.distanceKm.value.round()),
            ),
          ),
        ),
        const SizedBox(width: AppValues.cardGapWide),
        Expanded(
          child: _StatCard(
            label: l10n.qiblaAccuracyLabel,
            value: accuracy,
            warn: controller.needsCalibration,
          ),
        ),
      ],
    );
  }

  /// Shown only when the magnetometer says it is struggling. A calibration
  /// hint that is always on screen gets ignored; one that appears when the
  /// reading is actually bad gets read.
  Widget _calibrationHint(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          PhosphorIconsRegular.arrowsClockwise,
          size: AppValues.icon_18,
          color: AppColors.onDeepMuted,
        ),
        const SizedBox(width: AppValues.gapSmall),
        Expanded(
          child: Text(
            l10n.qiblaCalibrationHint,
            style: DuskText.bangla(
              size: AppValues.fontSize_12_5,
              weight: FontWeight.w400,
              height: 1.7,
              color: AppColors.onDeepMuted,
            ),
          ),
        ),
      ],
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _error(AppLocalizations l10n) {
    final message = switch (controller.errorMessageKey.value) {
      'locationService' => l10n.qiblaLocationServiceOff,
      'locationPermission' => l10n.qiblaLocationDenied,
      _ => l10n.qiblaCompassUnavailable,
    };

    return Column(
      children: [
        _titleRow(l10n),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppValues.space_34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppValues.icon_76,
                    height: AppValues.icon_76,
                    decoration: BoxDecoration(
                      color: AppColors.onDeepPrimary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      PhosphorIconsRegular.compass,
                      size: AppValues.space_34,
                      color: AppColors.goldBright,
                    ),
                  ),
                  const SizedBox(height: AppValues.gap),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: DuskText.bodyTight
                        .copyWith(color: AppColors.onDeepPrimary),
                  ),
                  const SizedBox(height: AppValues.space_22),
                  DuskPrimaryButton(
                    label: l10n.retry,
                    icon: PhosphorIconsRegular.arrowsClockwise,
                    onPressed: controller.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.warn = false,
  });

  final String label;
  final String value;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_13,
        horizontal: AppValues.cardPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.onDeepPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(DuskRadius.cardSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DuskText.caption.copyWith(color: AppColors.onDeepMuted),
          ),
          const SizedBox(height: AppValues.gap_2),
          Text(
            value,
            style: DuskText.bangla(
              size: AppValues.fontSize_15_5,
              weight: FontWeight.w700,
              color: warn ? AppColors.goldBright : AppColors.onDeepPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
