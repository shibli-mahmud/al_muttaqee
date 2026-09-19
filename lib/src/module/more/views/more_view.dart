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
import 'package:al_muttaqee/src/module/more/controllers/more_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// আরও — tab five.
///
/// Two blocks, and the split is deliberate: a grid of *features* the user might
/// go and use, then a list of *settings* they might go and change. Mixing the
/// two, as the old drawer did, made both harder to scan.
class MoreView extends BaseView<MoreController> {
  MoreView({super.key});

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
    final padding = screenPadding(context);

    return Column(
      children: [
        DuskHero(
          theme: DuskHeroTheme.day,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppValues.heroPadding,
              AppValues.gap_6,
              AppValues.heroPadding,
              0,
            ),
            child: Text(
              l10n.moreTitle,
              style: DuskText.heroTitle.copyWith(color: AppColors.onDeepPrimary),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              padding,
              AppValues.cardPadding,
              padding,
              AppValues.space_24,
            ),
            children: [
              _featureGrid(l10n),
              const SizedBox(height: AppValues.space_18),
              DuskOverline(l10n.settingsOverline),
              _settings(context, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _featureGrid(AppLocalizations l10n) {
    final tiles = <_FeatureTile>[
      _FeatureTile(
        label: l10n.tileQibla,
        icon: PhosphorIconsRegular.compass,
        onTap: controller.openQibla,
      ),
      _FeatureTile(
        label: l10n.tileMasjid,
        icon: PhosphorIconsRegular.mosque,
        onTap: controller.openMasjidFinder,
      ),
      _FeatureTile(
        label: l10n.tileDua,
        icon: PhosphorIconsRegular.handHeart,
        onTap: controller.openDua,
      ),
      _FeatureTile(
        label: l10n.tileHadith,
        icon: PhosphorIconsRegular.scroll,
        onTap: controller.openHadith,
      ),
      _FeatureTile(
        label: l10n.tileZakat,
        icon: PhosphorIconsRegular.calculator,
        onTap: controller.openZakat,
      ),
      _FeatureTile(
        label: l10n.tileCalendar,
        icon: PhosphorIconsRegular.calendarBlank,
        onTap: controller.openCalendar,
      ),
      // Ramadan is highlighted year-round in the design; during Ramadan it is
      // also surfaced automatically on হোম.
      _FeatureTile(
        label: l10n.tileRamadan,
        icon: PhosphorIconsRegular.moonStars,
        onTap: controller.openRamadan,
        highlighted: true,
      ),
      _FeatureTile(
        label: l10n.tileNames99,
        icon: PhosphorIconsRegular.sparkle,
        onTap: controller.openNames99,
      ),
      _FeatureTile(
        label: l10n.tileWidget,
        icon: PhosphorIconsRegular.squaresFour,
        onTap: controller.openWidgets,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppValues.cardGapWide,
        crossAxisSpacing: AppValues.cardGapWide,
        // Tall enough for a 38px chip, the gap and a label at 1.3x text scale.
        mainAxisExtent: 94,
      ),
      itemBuilder: (context, index) => tiles[index],
    );
  }

  Widget _settings(BuildContext context, AppLocalizations l10n) {
    return Obx(
      () => GroupedCard(
        children: [
          _settingRow(
            icon: PhosphorIconsRegular.translate,
            label: l10n.settingLanguage,
            value: controller.languageLabel,
            onTap: () => _pickLanguage(context, l10n),
          ),
          _settingRow(
            icon: PhosphorIconsRegular.mapPin,
            label: l10n.settingLocation,
            value: controller.locationLabel.isEmpty
                ? l10n.locationUnknown
                : controller.locationLabel,
            onTap: controller.openPrayerSettings,
          ),
          _settingRow(
            icon: PhosphorIconsRegular.slidersHorizontal,
            label: l10n.settingCalculation,
            value: _methodLabel(l10n, controller.calculationMethod),
            onTap: controller.openPrayerSettings,
          ),
          _settingRow(
            icon: PhosphorIconsRegular.bellRinging,
            label: l10n.adhanAndReminders,
            onTap: controller.openAdhanSettings,
          ),
          _settingRow(
            icon: PhosphorIconsRegular.textAa,
            label: l10n.settingFonts,
            onTap: null,
          ),
          _settingRow(
            icon: PhosphorIconsRegular.moon,
            label: l10n.settingNightMode,
            value: l10n.nightModeAuto,
            onTap: null,
          ),
          _settingRow(
            icon: PhosphorIconsRegular.downloadSimple,
            label: l10n.settingOfflineDownloads,
            onTap: null,
          ),
          _settingRow(
            icon: PhosphorIconsRegular.info,
            label: l10n.settingAbout,
            value: localizeDigits(controller.appVersion.value),
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _settingRow({
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    // A row with nowhere to go loses its chevron rather than being greyed out:
    // the label still tells the user the setting exists, and a disabled-looking
    // row invites repeated tapping.
    return GroupedRow(
      title: label,
      titleStyle: DuskText.rowLabel.copyWith(color: AppColors.ink),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.gap_3),
        child: Icon(icon, size: AppValues.icon_18, color: AppColors.duskMid),
      ),
      value: value,
      valueStyle: DuskText.rowTrailing.copyWith(color: AppColors.inkMuted),
      chevron: onTap != null,
      onTap: onTap,
    );
  }

  Future<void> _pickLanguage(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await Get.bottomSheet<void>(
      _LanguageSheet(controller: controller, l10n: l10n),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }

  String _methodLabel(AppLocalizations l10n, PrayerCalculationMethod method) =>
      switch (method) {
        PrayerCalculationMethod.karachi => l10n.methodKarachi,
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

  /// 18 normally, 14 below 375dp where 18 starts to crowd the grid.
  static double screenPadding(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppValues.breakpointNarrow
          ? AppValues.screenPaddingTight
          : AppValues.screenPadding;
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.cardSmall,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_13,
        horizontal: AppValues.gapXSmall,
      ),
      color: highlighted ? AppColors.goldTintCard : AppColors.surface,
      border:
          highlighted ? Border.all(color: AppColors.goldTintBorder) : null,
      shadow: highlighted ? const [] : AppColors.shadowCard,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DuskIconChip(
            icon: icon,
            size: AppValues.tileIconChip,
            radius: DuskRadius.iconChipLarge - 1,
            background: highlighted ? AppColors.gold : AppColors.sage,
            foreground: highlighted ? AppColors.goldInk : AppColors.duskMid,
            iconSize: AppValues.icon_19,
          ),
          const SizedBox(height: AppValues.space_7),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: DuskText.gridLabel.copyWith(
              color: highlighted ? AppColors.goldTintInk : AppColors.ink,
              fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.controller, required this.l10n});

  final MoreController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final current = L10n.selectedLocale.languageCode;

    return Container(
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
            Text(l10n.settingLanguage, style: DuskText.cardHeading),
            const SizedBox(height: AppValues.gapSmall),
            GroupedCard(
              children: [
                for (final locale in L10n.locals)
                  GroupedRow(
                    title: L10n.getLocalString(locale),
                    titleStyle: DuskText.rowLabel.copyWith(
                      color: AppColors.ink,
                    ),
                    trailing: locale.languageCode == current
                        ? const Icon(
                            PhosphorIconsFill.checkCircle,
                            size: AppValues.icon_20,
                            color: AppColors.goldOnIvory,
                          )
                        : null,
                    onTap: () async {
                      Get.back<void>();
                      await controller.setLocale(locale);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
