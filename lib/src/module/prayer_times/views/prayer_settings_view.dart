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
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// হিসাব পদ্ধতি ও সমন্বয় — a pushed screen, not a bottom sheet.
///
/// The old build put calculation method, madhab and per-prayer offsets in a
/// sheet. That is the wrong container for settings someone reads carefully and
/// changes rarely: a sheet is cramped, dismisses on an accidental drag, and
/// cannot be linked to from আরও. Jamaat times join them here because they are
/// the same kind of decision — how this user's day is measured.
class PrayerSettingsView extends BaseView<PrayerTimesController> {
  PrayerSettingsView({super.key});

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
          paddingBottom: AppValues.space_20,
          child: DuskHeroTitleRow(
            title: l10n.calculationAndOffsets,
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
                AppValues.space_28,
              ),
              children: [
                DuskOverline(l10n.calculationMethod),
                _methodCard(l10n),
                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.madhabOverline),
                _madhabCard(l10n),
                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.jamaatOverline),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppValues.gapSmall),
                  child: Text(
                    l10n.jamaatExplainer,
                    style: DuskText.bodySmall
                        .copyWith(color: AppColors.inkSecondary),
                  ),
                ),
                _jamaatCard(context, l10n),
                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.offsetsOverline),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppValues.gapSmall),
                  child: Text(
                    l10n.offsetsExplainer,
                    style: DuskText.bodySmall
                        .copyWith(color: AppColors.inkSecondary),
                  ),
                ),
                _offsetsCard(l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _methodCard(AppLocalizations l10n) {
    return GroupedCard(
      children: [
        for (final method in PrayerCalculationMethod.values)
          GroupedRow(
            title: _methodLabel(l10n, method),
            titleStyle: DuskText.rowLabel.copyWith(
              color: controller.method.value == method
                  ? AppColors.goldTintInk
                  : AppColors.ink,
            ),
            tinted: controller.method.value == method,
            trailing: controller.method.value == method
                ? const Icon(
                    PhosphorIconsFill.checkCircle,
                    size: AppValues.icon_20,
                    color: AppColors.goldOnIvory,
                  )
                : const Icon(
                    PhosphorIconsRegular.circle,
                    size: AppValues.icon_20,
                    color: AppColors.dashedBorder,
                  ),
            onTap: () => controller.setMethod(method),
          ),
      ],
    );
  }

  Widget _madhabCard(AppLocalizations l10n) {
    return GroupedCard(
      children: [
        GroupedRow(
          title: l10n.hanafiAsr,
          titleStyle: DuskText.rowLabel.copyWith(color: AppColors.ink),
          subtitle: l10n.hanafiMadhab,
          trailing: DuskSwitch(
            value: controller.hanafiMadhab.value,
            semanticLabel: l10n.hanafiAsr,
            onChanged: controller.setHanafiMadhab,
          ),
        ),
      ],
    );
  }

  Widget _jamaatCard(BuildContext context, AppLocalizations l10n) {
    return GroupedCard(
      children: [
        for (final prayer in trackedPrayers)
          GroupedRow(
            title: _prayerLabel(l10n, prayer),
            leading: DuskIconChip(icon: _iconFor(prayer)),
            value: controller.jamaatTimes[prayer] == null
                ? l10n.notSet
                : formatClock(controller.jamaatTimes[prayer]!.on(DateTime.now())),
            valueStyle: DuskText.rowTrailing.copyWith(
              color: controller.jamaatTimes[prayer] == null
                  ? AppColors.inkMuted
                  : AppColors.ink,
            ),
            chevron: true,
            onTap: () => _pickJamaatTime(context, l10n, prayer),
          ),
      ],
    );
  }

  Future<void> _pickJamaatTime(
    BuildContext context,
    AppLocalizations l10n,
    PrayerName prayer,
  ) async {
    final existing = controller.jamaatTimes[prayer];
    final prayerTime =
        controller.dayTimes.value?.entryFor(prayer)?.time ?? DateTime.now();

    final picked = await showTimePicker(
      context: context,
      helpText: '${_prayerLabel(l10n, prayer)} · ${l10n.jamaatOverline}',
      initialTime: existing == null
          ? TimeOfDay(hour: prayerTime.hour, minute: prayerTime.minute)
          : TimeOfDay(hour: existing.hour, minute: existing.minute),
    );
    if (picked == null) return;

    await controller.setJamaatTime(
      prayer,
      JamaatTime(picked.hour, picked.minute),
    );
  }

  Widget _offsetsCard(AppLocalizations l10n) {
    return GroupedCard(
      children: [
        for (final prayer in trackedPrayers)
          GroupedRow(
            title: _prayerLabel(l10n, prayer),
            leading: DuskIconChip(icon: _iconFor(prayer)),
            trailing: _OffsetStepper(
              minutes: controller.offsets[prayer] ?? 0,
              label: l10n.minutesValue(
                localizeDigits('${controller.offsets[prayer] ?? 0}'),
              ),
              onChanged: (value) => controller.setOffset(prayer, value),
            ),
          ),
      ],
    );
  }

  IconData _iconFor(PrayerName name) => switch (name) {
        PrayerName.fajr => PhosphorIconsRegular.sunHorizon,
        PrayerName.sunrise => PhosphorIconsRegular.sun,
        PrayerName.dhuhr => PhosphorIconsRegular.sun,
        PrayerName.asr => PhosphorIconsRegular.cloudSun,
        PrayerName.maghrib => PhosphorIconsRegular.sunHorizon,
        PrayerName.isha => PhosphorIconsRegular.moon,
      };

  String _prayerLabel(AppLocalizations l10n, PrayerName name) =>
      switch (name) {
        PrayerName.fajr => l10n.prayerFajr,
        PrayerName.sunrise => l10n.prayerSunrise,
        PrayerName.dhuhr => l10n.prayerDhuhr,
        PrayerName.asr => l10n.prayerAsr,
        PrayerName.maghrib => l10n.prayerMaghrib,
        PrayerName.isha => l10n.prayerIsha,
      };

  String _methodLabel(AppLocalizations l10n, PrayerCalculationMethod m) =>
      switch (m) {
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

/// A minus / value / plus stepper for a per-prayer minute offset.
///
/// Bounded to ±30: an offset is meant to reconcile the app with a local
/// masjid's published times, and anything past half an hour is a wrong
/// calculation method rather than an adjustment.
class _OffsetStepper extends StatelessWidget {
  const _OffsetStepper({
    required this.minutes,
    required this.label,
    required this.onChanged,
  });

  final int minutes;
  final String label;
  final ValueChanged<int> onChanged;

  static const int _limit = 30;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: PhosphorIconsRegular.minus,
          onTap: minutes > -_limit ? () => onChanged(minutes - 1) : null,
        ),
        SizedBox(
          width: 68,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: DuskText.bangla(
              size: AppValues.fontSize_13,
              weight: FontWeight.w700,
              color: minutes == 0 ? AppColors.inkMuted : AppColors.ink,
            ),
          ),
        ),
        _StepButton(
          icon: PhosphorIconsRegular.plus,
          onTap: minutes < _limit ? () => onChanged(minutes + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkResponse(
      onTap: onTap,
      radius: AppValues.space_22,
      child: SizedBox(
        width: AppValues.minTapTarget,
        height: AppValues.minTapTarget,
        child: Center(
          child: Container(
            width: AppValues.space_28,
            height: AppValues.space_28,
            decoration: BoxDecoration(
              color: AppColors.neutralFill,
              borderRadius: BorderRadius.circular(DuskRadius.chip),
            ),
            child: Icon(
              icon,
              size: AppValues.iconSmall,
              color: enabled ? AppColors.duskMid : AppColors.dashedBorder,
            ),
          ),
        ),
      ),
    );
  }
}
