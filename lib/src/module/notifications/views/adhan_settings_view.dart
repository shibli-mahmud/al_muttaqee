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
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// আজান ও রিমাইন্ডার — frame ১২.
class AdhanSettingsView extends BaseView<AdhanSettingsController> {
  AdhanSettingsView({super.key});

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
            title: l10n.adhanAndReminders,
            theme: theme,
            onBack: Get.back,
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.cardPadding,
                AppValues.screenPadding,
                AppValues.space_24,
              ),
              children: [
                DuskOverline(l10n.perPrayerOverline),
                _perPrayerCard(l10n),
                const SizedBox(height: AppValues.groupGap),

                // The permission card sits above the toggles on purpose: it
                // decides whether any of them fire at all, so it must not be
                // the thing that scrolls out of sight.
                AlarmPermissionCard(
                  state: controller.permissions,
                  l10n: l10n,
                  onFix: controller.fixPermissions,
                ),

                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.otherRemindersOverline),
                _remindersCard(l10n),
                const SizedBox(height: AppValues.groupGapWide),
                _testCard(l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _perPrayerCard(AppLocalizations l10n) {
    return GroupedCard(
      children: [
        for (final prayer in trackedPrayers)
          GroupedRow(
            title: prayerLabel(l10n, prayer),
            subtitle: _summaryFor(l10n, prayer),
            leading: adhanChipFor(prayer, controller.settingFor(prayer)),
            chevron: true,
            onTap: () => controller.openPrayerDetail(prayer),
          ),
      ],
    );
  }

  /// The row's subtitle repeats the current choice so the list can be read
  /// without opening five detail screens.
  String _summaryFor(AppLocalizations l10n, PrayerName prayer) {
    final setting = controller.settingFor(prayer);

    if (setting.isOff) return l10n.adhanModeOffLong;
    if (setting.isSilent) return l10n.adhanModeSilentLong;

    final sound = soundLabel(l10n, setting.sound);
    if (setting.preOffsetMinutes <= 0) return sound;
    return l10n.adhanSummaryWithOffset(
      sound,
      localizeDigits('${setting.preOffsetMinutes}'),
    );
  }

  Widget _remindersCard(AppLocalizations l10n) {
    String label(ExtraReminder reminder) => switch (reminder) {
          ExtraReminder.jumua => l10n.reminderJumua,
          ExtraReminder.tahajjud => l10n.reminderTahajjud,
          ExtraReminder.dailyHadith => l10n.reminderDailyHadith,
        };

    return GroupedCard(
      children: [
        for (final reminder in ExtraReminder.values)
          GroupedRow(
            title: label(reminder),
            titleStyle: DuskText.rowLabel.copyWith(color: AppColors.ink),
            trailing: DuskSwitch(
              value: controller.service.reminders[reminder] ?? false,
              semanticLabel: label(reminder),
              onChanged: (value) => controller.setReminder(reminder, value),
            ),
          ),
      ],
    );
  }

  Widget _testCard(AppLocalizations l10n) {
    return DuskCard(
      radius: DuskRadius.card,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.fontSize_15,
        horizontal: AppValues.space_20,
      ),
      onTap: controller.previewAdhan,
      child: Row(
        children: [
          const Icon(
            PhosphorIconsFill.play,
            size: AppValues.icon_18,
            color: AppColors.duskMid,
          ),
          const SizedBox(width: AppValues.gapSmall),
          Expanded(
            child: Text(
              l10n.testAdhanSound,
              style: DuskText.rowLabel.copyWith(color: AppColors.inkSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
