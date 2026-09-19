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
import 'package:al_muttaqee/src/module/notifications/controllers/adhan_settings_controller.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/notifications/views/adhan_widgets.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// One prayer's adhan settings: how it announces itself, which recording, and
/// how far ahead.
class AdhanPrayerDetailView extends BaseView<AdhanSettingsController> {
  AdhanPrayerDetailView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  /// The offsets worth offering. Past fifteen minutes a "pre-adhan" stops
  /// being a warning and becomes a second, confusing alarm.
  static const List<int> _offsets = [0, 5, 10, 15];

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const theme = DuskHeroTheme.day;

    final prayer = controller.prayerFromRoute();

    return Obx(() {
      if (prayer == null) {
        return Column(
          children: [
            DuskHero(
              theme: theme,
              child: DuskHeroTitleRow(
                title: l10n.adhanAndReminders,
                theme: theme,
                onBack: Get.back,
              ),
            ),
            Expanded(
              child: Center(
                child: DuskEmptyState(
                  icon: PhosphorIconsRegular.bellSlash,
                  message: l10n.comingSoonBody,
                ),
              ),
            ),
          ],
        );
      }

      final setting = controller.settingFor(prayer);
      final time = controller.timeFor(prayer);

      return Column(
        children: [
          DuskHero(
            theme: theme,
            child: DuskHeroTitleRow(
              title: prayerLabel(l10n, prayer),
              theme: theme,
              onBack: Get.back,
              actions: [
                if (time != null)
                  Padding(
                    padding: const EdgeInsets.only(right: AppValues.gap_4),
                    child: Text(
                      formatClock(time),
                      style: DuskText.bangla(
                        size: AppValues.fontSize_15_5,
                        weight: FontWeight.w700,
                        color: theme.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.cardPadding,
                AppValues.screenPadding,
                AppValues.space_28,
              ),
              children: [
                DuskOverline(l10n.adhanModeOverline),
                _modeCard(l10n, prayer, setting),

                // Sound and offset only mean anything when something is going
                // to be heard, so they are hidden rather than disabled when
                // the prayer is off — a disabled control invites tapping.
                if (!setting.isOff) ...[
                  const SizedBox(height: AppValues.groupGapWide),
                  DuskOverline(l10n.preOffsetOverline),
                  _offsetCard(l10n, prayer, setting),
                ],
                if (setting.mode == AdhanMode.adhan) ...[
                  const SizedBox(height: AppValues.groupGapWide),
                  DuskOverline(l10n.adhanSoundOverline),
                  _soundCard(l10n, prayer, setting),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _modeCard(
    AppLocalizations l10n,
    PrayerName prayer,
    AdhanSetting setting,
  ) {
    IconData iconFor(AdhanMode mode) => switch (mode) {
          AdhanMode.adhan => PhosphorIconsRegular.speakerHigh,
          AdhanMode.silent => PhosphorIconsRegular.vibrate,
          AdhanMode.off => PhosphorIconsRegular.bellSlash,
        };

    return GroupedCard(
      children: [
        for (final mode in AdhanMode.values)
          _ChoiceRow(
            title: modeLabel(l10n, mode),
            leading: DuskIconChip(icon: iconFor(mode)),
            selected: setting.mode == mode,
            onTap: () => controller.setMode(prayer, mode),
          ),
      ],
    );
  }

  Widget _offsetCard(
    AppLocalizations l10n,
    PrayerName prayer,
    AdhanSetting setting,
  ) {
    return GroupedCard(
      children: [
        for (final minutes in _offsets)
          _ChoiceRow(
            title: minutes == 0
                ? l10n.preOffsetOnTime
                : l10n.preOffsetMinutes(localizeDigits('$minutes')),
            selected: setting.preOffsetMinutes == minutes,
            onTap: () => controller.setPreOffset(prayer, minutes),
          ),
      ],
    );
  }

  Widget _soundCard(
    AppLocalizations l10n,
    PrayerName prayer,
    AdhanSetting setting,
  ) {
    return GroupedCard(
      children: [
        for (final sound in AdhanSound.values)
          _ChoiceRow(
            title: soundLabel(l10n, sound),
            selected: setting.sound == sound,
            onTap: () => controller.setSound(prayer, sound),
            trailingAction: IconButton(
              icon: const Icon(
                PhosphorIconsFill.play,
                size: AppValues.icon_18,
                color: AppColors.duskMid,
              ),
              tooltip: l10n.testAdhanSound,
              onPressed: () => controller.service.previewAdhan(sound),
            ),
          ),
      ],
    );
  }
}

/// A row in a single-choice group.
class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.title,
    required this.selected,
    required this.onTap,
    this.leading,
    this.trailingAction,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    return GroupedRow(
      title: title,
      titleStyle: DuskText.rowLabel.copyWith(
        color: selected ? AppColors.goldTintInk : AppColors.ink,
      ),
      leading: leading,
      tinted: selected,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingAction != null) trailingAction!,
          Icon(
            selected
                ? PhosphorIconsFill.checkCircle
                : PhosphorIconsRegular.circle,
            size: AppValues.icon_20,
            color: selected ? AppColors.goldOnIvory : AppColors.dashedBorder,
          ),
        ],
      ),
    );
  }
}
