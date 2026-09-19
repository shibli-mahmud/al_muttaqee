import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk_cards.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk_states.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// Pieces shared by the adhan list (frame ১২), the per-prayer detail, and the
/// reminder step of onboarding (frame ১১).

String prayerLabel(AppLocalizations l10n, PrayerName name) => switch (name) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };

String soundLabel(AppLocalizations l10n, AdhanSound sound) => switch (sound) {
      AdhanSound.systemDefault => l10n.adhanSoundDefault,
      AdhanSound.makkah => l10n.adhanSoundMakkah,
      AdhanSound.madinah => l10n.adhanSoundMadinah,
      AdhanSound.mishary => l10n.adhanSoundMishary,
    };

String modeLabel(AppLocalizations l10n, AdhanMode mode) => switch (mode) {
      AdhanMode.adhan => l10n.adhanModeAdhan,
      AdhanMode.silent => l10n.adhanModeSilent,
      AdhanMode.off => l10n.adhanModeOff,
    };

/// The leading chip on an adhan row.
///
/// It carries two facts at once — which prayer, and whether it is muted. A
/// silenced prayer swaps its per-prayer tint for the muted one and shows a
/// crossed speaker, so a glance down the list finds the switched-off ones
/// without reading any subtitles.
Widget adhanChipFor(PrayerName prayer, AdhanSetting setting) {
  if (setting.isSilent || setting.isOff) {
    return DuskIconChip(
      icon: setting.isOff
          ? PhosphorIconsRegular.bellSlash
          : PhosphorIconsRegular.speakerX,
      background: AppColors.mutedChip,
      foreground: AppColors.inkMuted,
    );
  }

  final (icon, background, foreground) = switch (prayer) {
    PrayerName.fajr => (
        PhosphorIconsRegular.sunHorizon,
        AppColors.fajrChip,
        AppColors.fajrChipInk,
      ),
    PrayerName.sunrise => (
        PhosphorIconsRegular.sun,
        AppColors.sunriseChip,
        AppColors.sunriseChipInk,
      ),
    PrayerName.dhuhr => (
        PhosphorIconsRegular.sun,
        AppColors.dhuhrChip,
        AppColors.dhuhrChipInk,
      ),
    PrayerName.asr => (
        PhosphorIconsRegular.cloudSun,
        AppColors.sage,
        AppColors.duskMid,
      ),
    PrayerName.maghrib => (
        PhosphorIconsRegular.sunHorizon,
        AppColors.maghribChip,
        AppColors.maghribChipInk,
      ),
    PrayerName.isha => (
        PhosphorIconsRegular.moon,
        AppColors.ishaChip,
        AppColors.ishaChipInk,
      ),
  };

  return DuskIconChip(
    icon: icon,
    background: background,
    foreground: foreground,
  );
}

/// The status card that says whether the adhan can actually fire on time.
///
/// Green-ish and reassuring when everything is granted; the gold warning
/// treatment, naming the specific missing permission, when it is not. It never
/// says "something went wrong" — it says which switch is off and offers to open
/// that screen, because the user is the only one who can fix it.
class AlarmPermissionCard extends StatelessWidget {
  const AlarmPermissionCard({
    super.key,
    required this.state,
    required this.l10n,
    required this.onFix,
  });

  final AlarmPermissionState state;
  final AppLocalizations l10n;
  final VoidCallback onFix;

  @override
  Widget build(BuildContext context) {
    if (state.allGranted) {
      return DuskStatusPanel(
        title: l10n.exactAlarmOkTitle,
        message: l10n.exactAlarmOkBody,
      );
    }

    // Most blocking first: no notification permission means nothing at all
    // fires, which is a different sentence from "may be a few minutes late".
    final message = !state.notificationsGranted
        ? l10n.notificationsBlockedBody
        : !state.exactAlarmsAllowed
            ? l10n.exactAlarmBlockedBody
            : l10n.exactAlarmWarnBody;

    return DuskErrorPanel(
      title: l10n.exactAlarmWarnTitle,
      message: message,
      actionLabel: l10n.openSettings,
      onAction: onFix,
    );
  }
}
