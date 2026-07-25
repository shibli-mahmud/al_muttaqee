import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/shared/widgets/application_bar.dart';
import 'package:al_muttaqee/src/core/utils/utils/notification_service.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsController extends BaseController {
  NotificationService get service => NotificationService.to;
}

class NotificationSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationSettingsController());
  }
}

class NotificationSettingsView extends BaseView<NotificationSettingsController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ApplicationBar(
      appTitleText: l10n.notifications,
      bgColor: AppColors.brand500,
      titleTextStyle: kFigtree600W16S.copyWith(color: AppColors.baseWhite),
      iconThemeData: const IconThemeData(color: AppColors.baseWhite),
    );
  }

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final service = controller.service;

    return Container(
      color: AppColors.baseBackground,
      child: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(AppValues.gap),
          children: [
            Text(
              l10n.permissionRationaleNotifications,
              style: kFigtree400W14S.copyWith(color: AppColors.grey700),
            ),
            const SizedBox(height: AppValues.gap),
            ElevatedButton(
              onPressed: () async {
                final ok = await service.requestPermission();
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.permissionRationaleNotifications),
                    ),
                  );
                } else {
                  await service.rescheduleAll();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand500,
                foregroundColor: AppColors.baseWhite,
              ),
              child: Text(l10n.enableNotifications),
            ),
            const SizedBox(height: AppValues.gap),
            SwitchListTile(
              title: Text(l10n.globalNotifications, style: kFigtree500W14S),
              value: service.globalEnabled.value,
              activeThumbColor: AppColors.brand500,
              onChanged: service.setGlobal,
            ),
            SwitchListTile(
              title: Text(l10n.duaReminders, style: kFigtree500W14S),
              value: service.duaRemindersEnabled.value,
              activeThumbColor: AppColors.brand500,
              onChanged: service.globalEnabled.value
                  ? service.setDuaReminders
                  : null,
            ),
            const Divider(),
            Text(l10n.salatAlerts, style: kFigtree600W16S),
            ...[
              (PrayerName.fajr, l10n.prayerFajr),
              (PrayerName.dhuhr, l10n.prayerDhuhr),
              (PrayerName.asr, l10n.prayerAsr),
              (PrayerName.maghrib, l10n.prayerMaghrib),
              (PrayerName.isha, l10n.prayerIsha),
            ].map((item) {
              return SwitchListTile(
                title: Text(item.$2, style: kFigtree400W14S),
                value: service.prayerToggles[item.$1] ?? true,
                activeThumbColor: AppColors.brand500,
                onChanged: service.globalEnabled.value
                    ? (v) => service.setPrayerToggle(item.$1, v)
                    : null,
              );
            }),
          ],
        );
      }),
    );
  }
}
