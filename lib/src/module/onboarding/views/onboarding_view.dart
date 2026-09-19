import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/notifications/views/adhan_widgets.dart';
import 'package:al_muttaqee/src/module/onboarding/controllers/onboarding_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// Frames ০৯–১১: the first run.
class OnboardingView extends BaseView<OnboardingController> {
  OnboardingView({super.key});

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

    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      // Driven by the buttons, not by swiping: each page has an action that
      // has to happen (a language, a location decision, a permission), and a
      // swipe past it would skip the thing the page exists for.
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _WelcomePage(controller: controller, l10n: l10n),
        _LocationPage(controller: controller, l10n: l10n),
        _RemindersPage(controller: controller, l10n: l10n),
      ],
    );
  }
}

// ── ০৯ · স্বাগতম ────────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.controller, required this.l10n});

  final OnboardingController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DuskHero(
          theme: DuskHeroTheme.day.copyWithPattern(0.16),
          bottomRadius: AppValues.space_34,
          paddingBottom: 46,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppValues.space_26,
              74,
              AppValues.space_26,
              0,
            ),
            child: Column(
              children: [
                Container(
                  width: AppValues.container_72,
                  height: AppValues.container_72,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppValues.space_26),
                  ),
                  alignment: Alignment.center,
                  // The same glyph as the launcher icon and the splash, so
                  // the first three things a new user sees are one mark.
                  child: Image.asset(
                    'assets/images/brand_glyph.png',
                    width: AppValues.icon_34,
                    height: AppValues.icon_34,
                  ),
                ),
                const SizedBox(height: AppValues.space_22),
                Text(
                  'المتقي',
                  style: DuskText.arabicWordmark
                      .copyWith(color: AppColors.goldBright),
                ),
                Text(
                  'আল মুত্তাকী',
                  style:
                      DuskText.wordmark.copyWith(color: AppColors.onDeepPrimary),
                ),
                const SizedBox(height: AppValues.space_12),
                Text(
                  l10n.onboardingTagline,
                  textAlign: TextAlign.center,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_14_5,
                    weight: FontWeight.w400,
                    height: 1.7,
                    color: AppColors.onDeepMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppValues.heroPadding,
              AppValues.space_28,
              AppValues.heroPadding,
              AppValues.space_26,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuskOverline(
                  l10n.onboardingLanguageOverline,
                  padding: const EdgeInsets.only(bottom: AppValues.space_12),
                ),
                Obx(
                  () => Row(
                    children: [
                      for (final locale in L10n.locals) ...[
                        if (locale != L10n.locals.first)
                          const SizedBox(width: AppValues.cardGapWide),
                        Expanded(
                          child: _LanguageCard(
                            label: L10n.getLocalString(locale),
                            selected: controller.selectedLanguage.value
                                    .languageCode ==
                                locale.languageCode,
                            onTap: () => controller.chooseLanguage(locale),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.space_18),
                Text(
                  l10n.onboardingLanguageNote,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_13,
                    weight: FontWeight.w400,
                    height: 1.75,
                    color: AppColors.inkMuted,
                  ),
                ),
                const Spacer(),
                DuskPrimaryButton(
                  label: l10n.onboardingStart,
                  icon: PhosphorIconsRegular.arrowRight,
                  onPressed: controller.next,
                ),
                const SizedBox(height: AppValues.gap),
                Obx(() => _PageDots(current: controller.page.value)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.cardSmall,
      color: selected ? AppColors.duskDeep : AppColors.surface,
      shadow: selected ? const [] : AppColors.shadowCard,
      padding: const EdgeInsets.all(AppValues.cardPadding),
      onTap: onTap,
      child: Row(
        children: [
          if (selected) ...[
            const Icon(
              PhosphorIconsRegular.check,
              size: AppValues.icon_18,
              color: AppColors.gold,
            ),
            const SizedBox(width: AppValues.gapSmall),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DuskText.bangla(
                size: AppValues.fontSize_16,
                weight: FontWeight.w700,
                color: selected
                    ? AppColors.onDeepPrimary
                    : AppColors.inkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── ১০ · অবস্থান ────────────────────────────────────────────────────────────

class _LocationPage extends StatelessWidget {
  const _LocationPage({required this.controller, required this.l10n});

  final OnboardingController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppValues.heroPadding,
          AppValues.gapXSmall,
          AppValues.heroPadding,
          AppValues.space_26,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepHeader(controller: controller, l10n: l10n, step: 2),
            const SizedBox(height: AppValues.space_34),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.sage,
                  borderRadius: BorderRadius.circular(AppValues.space_24),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  PhosphorIconsRegular.mapPin,
                  size: AppValues.icon_30,
                  color: AppColors.duskMid,
                ),
              ),
            ),
            const SizedBox(height: AppValues.space_22),
            Text(l10n.onboardingLocationTitle, style: DuskText.onboardingHeading),
            const SizedBox(height: AppValues.space_12),
            Text(
              l10n.onboardingLocationBody,
              style: DuskText.body.copyWith(color: AppColors.inkSecondary),
            ),
            const SizedBox(height: AppValues.space_26),
            _reason(PhosphorIconsRegular.clock, l10n.onboardingReasonTimes),
            const SizedBox(height: AppValues.cardGapWide),
            _reason(PhosphorIconsRegular.compass, l10n.onboardingReasonQibla),
            const SizedBox(height: AppValues.cardGapWide),
            _reason(PhosphorIconsRegular.mosque, l10n.onboardingReasonMasjid),
            const Spacer(),
            DuskPrimaryButton(
              label: l10n.onboardingAllowLocation,
              icon: PhosphorIconsRegular.arrowRight,
              onPressed: controller.requestLocation,
            ),
            const SizedBox(height: AppValues.gapSmall),
            DuskSecondaryButton(
              label: l10n.onboardingPickCity,
              trailingText: l10n.onboardingCityHint,
              onPressed: () => _pickCity(context),
            ),
            const SizedBox(height: AppValues.gap),
            Obx(() => _PageDots(current: controller.page.value)),
          ],
        ),
      ),
    );
  }

  Widget _reason(IconData icon, String label) {
    return DuskCard(
      radius: DuskRadius.cardSmall,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_14,
        horizontal: AppValues.cardPadding,
      ),
      child: Row(
        children: [
          DuskIconChip(
            icon: icon,
            size: AppValues.tileIconChip,
            radius: DuskRadius.iconChipLarge - 1,
            iconSize: AppValues.icon_19,
          ),
          const SizedBox(width: AppValues.space_13),
          Expanded(
            child: Text(
              label,
              style: DuskText.bangla(
                size: AppValues.fontSize_13_5,
                weight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCity(BuildContext context) async {
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
              Text(l10n.onboardingCityTitle, style: DuskText.cardHeading),
              const SizedBox(height: AppValues.gapSmall),
              Flexible(
                child: SingleChildScrollView(
                  child: GroupedCard(
                    children: [
                      for (final city in bangladeshCities)
                        GroupedRow(
                          title: city.name,
                          titleStyle:
                              DuskText.rowLabel.copyWith(color: AppColors.ink),
                          leading: const DuskIconChip(
                            icon: PhosphorIconsRegular.mapPin,
                          ),
                          chevron: true,
                          onTap: () {
                            Get.back<void>();
                            controller.chooseCity(city);
                          },
                        ),
                    ],
                  ),
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

// ── ১১ · রিমাইন্ডার সেটআপ ───────────────────────────────────────────────────

class _RemindersPage extends StatelessWidget {
  const _RemindersPage({required this.controller, required this.l10n});

  final OnboardingController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppValues.heroPadding,
          AppValues.gapXSmall,
          AppValues.heroPadding,
          AppValues.space_24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepHeader(controller: controller, l10n: l10n, step: 3),
            const SizedBox(height: AppValues.space_22),
            Text(
              l10n.onboardingRemindersTitle,
              style: DuskText.onboardingHeadingSmall,
            ),
            const SizedBox(height: AppValues.gapXSmall),
            Text(
              l10n.onboardingRemindersBody,
              style: DuskText.bangla(
                size: AppValues.fontSize_13_5,
                weight: FontWeight.w400,
                height: 1.75,
                color: AppColors.inkSecondary,
              ),
            ),
            const SizedBox(height: AppValues.space_18),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GroupedCard(
                        children: [
                          for (final prayer in trackedPrayers)
                            _reminderRow(prayer),
                        ],
                      ),
                      const SizedBox(height: AppValues.groupGap),
                      // The exact-alarm caveat is raised here rather than
                      // after the first late adhan, because by then the user
                      // has already decided the app does not work.
                      if (!controller.permissions.allGranted)
                        DuskErrorPanel(
                          title: l10n.exactAlarmWarnTitle,
                          message: l10n.exactAlarmWarnBody,
                          actionLabel: l10n.openSettings,
                          onAction: controller.openBlockingSetting,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppValues.cardPadding),
            DuskPrimaryButton(
              label: l10n.onboardingFinish,
              icon: PhosphorIconsRegular.check,
              onPressed: controller.finish,
            ),
            const SizedBox(height: AppValues.gap),
            Obx(() => _PageDots(current: controller.page.value)),
          ],
        ),
      ),
    );
  }

  Widget _reminderRow(PrayerName prayer) {
    final setting = controller.settingFor(prayer);
    final time = controller.timeFor(prayer);

    final (background, foreground) = switch (setting.mode) {
      AdhanMode.adhan => (AppColors.duskDeep, AppColors.onDeepPrimary),
      AdhanMode.silent => (AppColors.mutedChip, AppColors.inkSecondary),
      AdhanMode.off => (AppColors.mutedChip, AppColors.inkSecondary),
    };

    return GroupedRow(
      title: prayerLabel(l10n, prayer),
      value: time == null ? '—' : formatClock(time),
      valueStyle: DuskText.rowTrailing.copyWith(color: AppColors.inkMuted),
      trailing: DuskPill(
        label: modeLabel(l10n, setting.mode),
        background: background,
        foreground: foreground,
        onTap: () => controller.cycleMode(prayer),
      ),
    );
  }
}

// ── Shared chrome ───────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.controller,
    required this.l10n,
    required this.step,
  });

  final OnboardingController controller;
  final AppLocalizations l10n;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkResponse(
          onTap: controller.back,
          radius: AppValues.space_24,
          child: const SizedBox(
            width: AppValues.minTapTarget,
            height: AppValues.minTapTarget,
            child: Icon(
              PhosphorIconsRegular.arrowLeft,
              size: AppValues.icon_21,
              color: AppColors.duskMid,
            ),
          ),
        ),
        const Spacer(),
        Text(
          l10n.onboardingStep(
            localizeDigits('$step'),
            localizeDigits('${OnboardingController.pageCount}'),
          ),
          style: DuskText.bangla(
            size: AppValues.fontSize_12_5,
            weight: FontWeight.w700,
            color: AppColors.inkMuted,
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < OnboardingController.pageCount; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.gap_3),
            child: AnimatedContainer(
              duration: AppValues.navPill,
              curve: Curves.easeOutCubic,
              width: i == current ? AppValues.space_26 : AppValues.gapXSmall,
              height: AppValues.gap_5,
              decoration: BoxDecoration(
                color: i == current ? AppColors.gold : const Color(0xFFCFC8B8),
                borderRadius: BorderRadius.circular(DuskRadius.chip),
              ),
            ),
          ),
      ],
    );
  }
}
