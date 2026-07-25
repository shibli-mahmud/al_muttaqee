import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/shared/widgets/application_bar.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PrayerTimesView extends BaseView<PrayerTimesController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ApplicationBar(
      appTitleText: l10n.prayerTimes,
      bgColor: AppColors.brand500,
      titleTextStyle: kFigtree600W16S.copyWith(color: AppColors.baseWhite),
      iconThemeData: const IconThemeData(color: AppColors.baseWhite),
      actions: [
        IconButton(
          icon: const Icon(PhosphorIconsRegular.gear),
          onPressed: () => _openSettings(context),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppColors.baseBackground,
      child: Obx(() {
        final times = controller.dayTimes.value;
        if (times == null) {
          return Center(child: Text(l10n.preparingPrayerTimes));
        }

        final timeFmt = DateFormat.jm();
        return RefreshIndicator(
          onRefresh: controller.refreshTimes,
          child: ListView(
            padding: const EdgeInsets.all(AppValues.gap),
            children: [
              _NextPrayerCard(
                title: l10n.nextPrayer,
                prayerLabel: _labelFor(l10n, times.next),
                countdown: controller.formatRemaining(controller.remaining.value),
                timeText: timeFmt.format(times.nextTime),
              ),
              const SizedBox(height: AppValues.gap),
              if (!controller.hasPermission.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppValues.gap),
                  child: Text(
                    l10n.prayerTimesLocationFallback,
                    style: kFigtree400W12S.copyWith(color: AppColors.grey700),
                  ),
                ),
              ...times.prayers.map((entry) {
                final isCurrent = times.current == entry.name;
                final isNext = times.next == entry.name;
                return _PrayerRow(
                  name: _labelFor(l10n, entry.name),
                  time: timeFmt.format(entry.time),
                  highlighted: isCurrent || isNext,
                  isCurrent: isCurrent,
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  String _labelFor(AppLocalizations l10n, PrayerName name) {
    return switch (name) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };
  }

  void _openSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppValues.gap),
        decoration: const BoxDecoration(
          color: AppColors.baseWhite,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppValues.radius),
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.prayerSettings, style: kFigtree600W16S),
                const SizedBox(height: AppValues.gapSmall),
                Text(l10n.calculationMethod, style: kFigtree500W14S),
                DropdownButton<PrayerCalculationMethod>(
                  isExpanded: true,
                  value: controller.method.value,
                  items: PrayerCalculationMethod.values
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(_methodLabel(l10n, m)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) controller.setMethod(v);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.hanafiMadhab, style: kFigtree400W14S),
                  value: controller.hanafiMadhab.value,
                  activeThumbColor: AppColors.brand500,
                  onChanged: (v) => controller.setHanafiMadhab(v),
                ),
                Text(l10n.manualOffsets, style: kFigtree500W14S),
                ...[
                  PrayerName.fajr,
                  PrayerName.dhuhr,
                  PrayerName.asr,
                  PrayerName.maghrib,
                  PrayerName.isha,
                ].map((p) {
                  final value = controller.offsets[p] ?? 0;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_labelFor(l10n, p), style: kFigtree400W14S),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => controller.setOffset(p, value - 1),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$value min', style: kFigtree500W14S),
                        IconButton(
                          onPressed: () => controller.setOffset(p, value + 1),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }),
        ),
      ),
      isScrollControlled: true,
    );
  }

  String _methodLabel(AppLocalizations l10n, PrayerCalculationMethod m) {
    return switch (m) {
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
  }
}

class _NextPrayerCard extends StatelessWidget {
  const _NextPrayerCard({
    required this.title,
    required this.prayerLabel,
    required this.countdown,
    required this.timeText,
  });

  final String title;
  final String prayerLabel;
  final String countdown;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.gap),
      decoration: BoxDecoration(
        color: AppColors.brand500,
        borderRadius: BorderRadius.circular(AppValues.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kFigtree400W12S.copyWith(color: AppColors.brand200),
          ),
          const SizedBox(height: AppValues.gap_4),
          Text(
            prayerLabel,
            style: kFigtree700W22S.copyWith(color: AppColors.baseWhite),
          ),
          const SizedBox(height: AppValues.gapXSmall),
          Text(
            countdown,
            style: kFigtree600W18S.copyWith(color: AppColors.baseWhite),
          ),
          Text(
            timeText,
            style: kFigtree400W14S.copyWith(color: AppColors.brand100),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.name,
    required this.time,
    required this.highlighted,
    required this.isCurrent,
  });

  final String name;
  final String time;
  final bool highlighted;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.gapXSmall),
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.gap,
        vertical: AppValues.gapSmall,
      ),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.brand200 : AppColors.baseWhite,
        borderRadius: BorderRadius.circular(AppValues.radiusSmall),
        border: isCurrent
            ? Border.all(color: AppColors.brand500, width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: kFigtree500W14S),
          Text(time, style: kFigtree600W14S),
        ],
      ),
    );
  }
}
