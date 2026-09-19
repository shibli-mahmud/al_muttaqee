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
import 'package:al_muttaqee/src/module/home/controllers/home_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// হোম — frame ০১.
///
/// The screen answers one question first — how long until the next prayer —
/// and only then offers the day's five habits. Everything above the fold is in
/// service of that one answer, which is why the countdown gets the hero and the
/// features get a four-tile strip at the bottom.
class HomeView extends BaseView<HomeController> {
  HomeView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  /// The hero runs under the status bar, so the page must not inset for it —
  /// [DuskHero] applies the top [SafeArea] to its own content instead.
  @override
  Widget pageContent(BuildContext context) => body(context);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final padding = _screenPadding(context);

    return RefreshIndicator(
      onRefresh: controller.reloadAll,
      color: AppColors.duskMid,
      backgroundColor: AppColors.surface,
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            _Hero(controller: controller, l10n: l10n),
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding,
                AppValues.space_18,
                padding,
                AppValues.space_24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _dateRow(l10n),
                  const SizedBox(height: AppValues.groupGap),
                  _trackerCard(l10n),
                  const SizedBox(height: AppValues.groupGap),
                  _continueReadingCard(l10n),
                  if (controller.isMaghribWindow) ...[
                    const SizedBox(height: AppValues.groupGap),
                    _iftarDuaCard(l10n),
                  ],
                  const SizedBox(height: AppValues.groupGap),
                  _hadithCard(l10n),
                  const SizedBox(height: AppValues.groupGap),
                  DuskOverline(l10n.quickAccessOverline),
                  _quickAccess(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Date row ──────────────────────────────────────────────────────────────

  /// Two cards, unequal: the Hijri one is wider and tinted because its label is
  /// longer and, for this audience, more often the one being looked up.
  Widget _dateRow(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 100,
          child: _DateCard(
            label: l10n.todayLabel,
            value: controller.gregorianLabel.value,
            background: AppColors.surface,
            labelColor: AppColors.inkMuted,
            valueColor: AppColors.ink,
            shadow: AppColors.shadowCard,
          ),
        ),
        const SizedBox(width: AppValues.cardGapWide),
        Expanded(
          flex: 125,
          child: _DateCard(
            label: l10n.hijriLabel,
            value: controller.hijriLabel.value,
            background: AppColors.sage,
            labelColor: AppColors.sageLabel,
            valueColor: AppColors.duskDeep,
            shadow: const [],
          ),
        ),
      ],
    );
  }

  // ── Tracker ───────────────────────────────────────────────────────────────

  Widget _trackerCard(AppLocalizations l10n) {
    final tracker = controller.tracker;

    return DuskCard(
      child: Obx(() {
        final streak = tracker?.currentStreak ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.todaysPrayers, style: DuskText.cardHeading),
                ),
                if (streak > 0)
                  DuskPill(
                    label: l10n.streakDays(formatNumberWithLocale(streak)),
                    icon: PhosphorIconsFill.flame,
                  ),
              ],
            ),
            const SizedBox(height: AppValues.groupGap),
            Row(
              children: [
                for (final prayer in trackedPrayers)
                  Expanded(
                    child: _TrackerColumn(
                      label: controller.prayerLabel(prayer),
                      state: tracker?.stateFor(prayer) ?? TrackerState.future,
                      onTap: tracker == null
                          ? null
                          : () => tracker.togglePrayerLogged(prayer),
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  // ── Continue reading ──────────────────────────────────────────────────────

  Widget _continueReadingCard(AppLocalizations l10n) {
    // The reading-plan percentage arrives with the plan itself in phase 2; the
    // ayah position is real today, so the card shows what it knows.
    final ayah = controller.lastAyah.value;

    return DuskCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.duskMid, AppColors.duskLight],
      ),
      shadow: const [],
      onTap: controller.openQuranContinue,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.continueReadingOverline,
                  style: DuskText.overline.copyWith(color: AppColors.gold),
                ),
                const SizedBox(height: 1),
                Text(
                  _surahLabel(),
                  style: DuskText.bangla(
                    size: AppValues.fontSize_19,
                    weight: FontWeight.w700,
                    color: AppColors.onDeepPrimary,
                  ),
                ),
                Text(
                  ayah > 0
                      ? l10n.quranAyahNumberLabel(ayah)
                      : l10n.readingNotStarted,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_12,
                    weight: FontWeight.w400,
                    color: AppColors.onDeepMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.groupGap),
          Container(
            width: AppValues.icon_50,
            height: AppValues.icon_50,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              PhosphorIconsFill.play,
              size: AppValues.icon_21,
              color: AppColors.goldInk,
            ),
          ),
        ],
      ),
    );
  }

  String _surahLabel() {
    final number = controller.lastSurah.value;
    return number > 0
        ? 'সূরা ${formatNumberWithLocale(number)}'
        : appLocalization.quran;
  }

  // ── Contextual: iftar dua ─────────────────────────────────────────────────

  /// Only present inside the Maghrib window. A card that is always there is
  /// furniture; one that appears exactly when it is useful gets read.
  Widget _iftarDuaCard(AppLocalizations l10n) {
    return DuskCard(
      onTap: controller.openDua,
      child: Row(
        children: [
          const DuskIconChip(
            icon: PhosphorIconsRegular.forkKnife,
            size: AppValues.tileIconChip,
            radius: DuskRadius.iconChipLarge - 1,
            background: AppColors.maghribChip,
            foreground: AppColors.maghribChipInk,
            iconSize: AppValues.icon_19,
          ),
          const SizedBox(width: AppValues.space_13),
          Expanded(
            child: Text(l10n.iftarDua, style: DuskText.rowTitle),
          ),
          const Icon(
            PhosphorIconsRegular.caretRight,
            size: AppValues.icon_17,
            color: AppColors.inkMuted,
          ),
        ],
      ),
    );
  }

  // ── Daily hadith ──────────────────────────────────────────────────────────

  Widget _hadithCard(AppLocalizations l10n) {
    final hadith = controller.dailyHadith.value;
    final dua = controller.todaysDua;

    // Before the bundle resolves, hold the card's geometry with skeletons
    // rather than collapsing the layout and pushing everything below it up.
    if (hadith == null && dua == null) {
      return const DuskCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DuskSkeleton.line(width: 110, height: 12),
            SizedBox(height: AppValues.space_12),
            DuskSkeleton.line(height: AppValues.space_24),
            SizedBox(height: AppValues.gapSmall),
            DuskSkeleton.line(),
            SizedBox(height: AppValues.gap_6),
            DuskSkeleton.line(width: 180),
          ],
        ),
      );
    }

    final arabic = hadith?.hadith.arabic ?? '';
    final translation =
        hadith?.hadith.bengali.isNotEmpty == true
            ? hadith!.hadith.bengali
            : (dua?.text ?? '');
    final source = hadith == null
        ? (dua?.source ?? '')
        : '${hadith.bookName} · '
            '${formatNumberWithLocale(hadith.hadith.number)}';

    return DuskCard(
      onTap: controller.openHadith,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.hadithOfTheDay,
                  style:
                      DuskText.overline.copyWith(color: AppColors.goldOnIvory),
                ),
              ),
              const Icon(
                PhosphorIconsRegular.bookmarkSimple,
                size: AppValues.iconSmall,
                color: AppColors.inkMuted,
              ),
            ],
          ),
          const SizedBox(height: AppValues.gapSmall),
          if (arabic.isNotEmpty)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                arabic,
                textAlign: TextAlign.right,
                style: DuskText.arabicCard.copyWith(color: AppColors.duskDeep),
              ),
            ),
          if (translation.isNotEmpty) ...[
            const SizedBox(height: AppValues.gapSmall),
            Text(
              translation,
              style: DuskText.bodyTight.copyWith(color: AppColors.inkBody),
            ),
          ],
          if (source.isNotEmpty) ...[
            const SizedBox(height: AppValues.gapXSmall),
            Text(
              source,
              style: DuskText.rowSubtitleStrong
                  .copyWith(color: AppColors.inkMuted),
            ),
          ],
        ],
      ),
    );
  }

  // ── Quick access ──────────────────────────────────────────────────────────

  Widget _quickAccess(AppLocalizations l10n) {
    final items = <_QuickItem>[
      _QuickItem(
        label: l10n.tileQibla,
        icon: PhosphorIconsRegular.compass,
        onTap: controller.openQibla,
      ),
      _QuickItem(
        label: l10n.tileMasjid,
        icon: PhosphorIconsRegular.mosque,
        onTap: controller.openMasjidFinder,
      ),
      _QuickItem(
        label: l10n.tileDua,
        icon: PhosphorIconsRegular.handHeart,
        onTap: controller.openDua,
      ),
      _QuickItem(
        label: l10n.tileZakat,
        icon: PhosphorIconsRegular.calculator,
        onTap: controller.openZakat,
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: AppValues.cardGapWide),
          Expanded(child: items[i]),
        ],
      ],
    );
  }

  static double _screenPadding(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppValues.breakpointNarrow
          ? AppValues.screenPaddingTight
          : AppValues.screenPadding;
}

// ── Hero ────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.controller, required this.l10n});

  final HomeController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = controller.heroTheme;
    final prayer = controller.prayerTimes;
    final times = prayer?.dayTimes.value;

    return DuskHero(
      theme: theme,
      bottomRadius: DuskRadius.heroHome,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _greetingRow(theme),
          if (times == null || prayer == null)
            _loadingBlock(theme)
          else
            _nextPrayerBlock(theme, times),
          const SizedBox(height: AppValues.space_22),
          if (times != null) _prayerStrip(context, theme, times),
        ],
      ),
    );
  }

  Widget _greetingRow(DuskHeroTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.heroPadding,
        AppValues.gapXSmall,
        AppValues.heroPadding,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.greeting,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_12_5,
                    weight: FontWeight.w600,
                    color: theme.onMuted,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      PhosphorIconsFill.mapPin,
                      size: AppValues.icon_14,
                      color: theme.accent,
                    ),
                    const SizedBox(width: AppValues.gap_5),
                    Flexible(
                      child: Obx(() {
                        final label =
                            controller.prayerTimes?.locationLabel.value ?? '';
                        return Text(
                          label.isEmpty ? l10n.locationUnknown : label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DuskText.bangla(
                            size: AppValues.fontSize_16,
                            weight: FontWeight.w700,
                            color: theme.onPrimary,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => DuskHeroIconButton(
              icon: PhosphorIconsRegular.bell,
              theme: theme,
              size: AppValues.heroBellButton,
              iconSize: AppValues.icon_19,
              badge: controller.hasUnreadNotifications.value,
              semanticLabel: l10n.notificationsSemantic,
              onTap: controller.openNotifications,
            ),
          ),
        ],
      ),
    );
  }

  /// The loading state keeps the hero's shape and swaps the times for em
  /// dashes. A spinner here would throw away the one piece of layout the user
  /// is waiting to read.
  Widget _loadingBlock(DuskHeroTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.heroPadding,
        AppValues.space_22,
        AppValues.heroPadding,
        0,
      ),
      child: Column(
        children: [
          Text(
            l10n.nextPrayerOverline,
            style: DuskText.overlineHero.copyWith(color: theme.accent),
          ),
          Text(
            '—',
            style: DuskText.heroPrayerName.copyWith(color: theme.onPrimary),
          ),
          Text(
            l10n.preparingPrayerTimes,
            style: DuskText.bangla(
              size: AppValues.fontSize_12_5,
              weight: FontWeight.w400,
              color: theme.onMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextPrayerBlock(DuskHeroTheme theme, DayPrayerTimes times) {
    // Just after a window opens, the sentence the user wants is "it is Maghrib
    // now", not "Isha in 1:12" — so for that stretch the headline names the
    // window that has just started and the countdown keeps pointing at the
    // next one. The rest of the day the headline is simply what is coming.
    final justStarted = controller.justStartedWindow;
    final headlinePrayer = justStarted ?? times.next;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.heroPadding,
        AppValues.space_22,
        AppValues.heroPadding,
        0,
      ),
      child: Column(
        children: [
          Text(
            justStarted != null
                ? l10n
                    .currentWindowOverline(controller.prayerLabel(justStarted))
                : l10n.nextPrayerOverline,
            textAlign: TextAlign.center,
            style: DuskText.overlineHero.copyWith(color: theme.accent),
          ),
          const SizedBox(height: 2),
          Text(
            controller.prayerLabel(headlinePrayer),
            style: DuskText.heroPrayerName.copyWith(color: theme.onPrimary),
          ),
          Text(
            controller.arabicPrayerName(headlinePrayer),
            style: DuskText.arabicHeroName.copyWith(color: theme.onMuted),
          ),
          const SizedBox(height: AppValues.groupGap),
          _countdownPill(theme, times),
          const SizedBox(height: AppValues.gapXSmall),
          _subLine(theme, times),
        ],
      ),
    );
  }

  Widget _countdownPill(DuskHeroTheme theme, DayPrayerTimes times) {
    return Obx(() {
      final remaining =
          controller.prayerTimes?.remaining.value ?? Duration.zero;
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppValues.gapXSmall,
          horizontal: AppValues.gap,
        ),
        decoration: BoxDecoration(
          color: theme.accent.withValues(alpha: 0.18),
          border: Border.all(color: theme.accent.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(DuskRadius.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIconsRegular.hourglass,
              size: AppValues.fontSize_15,
              color: AppColors.goldBright,
            ),
            const SizedBox(width: AppValues.gapXSmall),
            Text(
              formatRemainingWords(remaining),
              style: DuskText.bangla(
                size: AppValues.fontSize_15,
                weight: FontWeight.w700,
                color: const Color(0xFFF2E4B8),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _subLine(DuskHeroTheme theme, DayPrayerTimes times) {
    final start = times.nextTime;
    final jamaat = controller.prayerTimes?.jamaatTimeFor(times.next);

    return Text(
      jamaat == null
          ? l10n.windowStartsAt(formatClockWithPeriod(start))
          : l10n.windowStartsWithJamaat(
              formatClockWithPeriod(start),
              formatClock(jamaat),
            ),
      textAlign: TextAlign.center,
      style: DuskText.bangla(
        size: AppValues.fontSize_12_5,
        weight: FontWeight.w400,
        color: theme.onMuted,
      ),
    );
  }

  /// The five-prayer strip. Below 340dp it scrolls rather than compressing
  /// further — five Bangla names in 320 logical pixels stops being readable
  /// before it stops fitting.
  Widget _prayerStrip(
    BuildContext context,
    DuskHeroTheme theme,
    DayPrayerTimes times,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < AppValues.breakpointNarrow;
    final veryNarrow = width < AppValues.breakpointVeryNarrow;

    final cells = [
      for (final prayer in trackedPrayers)
        _StripCell(
          label: controller.prayerLabel(prayer),
          time: formatClock(times.entryFor(prayer)?.time ?? times.date),
          active: times.current == prayer,
          theme: theme,
          narrow: narrow,
        ),
    ];

    if (veryNarrow) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppValues.cardPadding),
        child: Row(
          children: [
            for (final cell in cells)
              Padding(
                padding: const EdgeInsets.only(right: AppValues.gap_4),
                child: SizedBox(width: 66, child: cell),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.cardPadding),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0) SizedBox(width: narrow ? AppValues.gap_4 : AppValues.gap_6),
            Expanded(child: cells[i]),
          ],
        ],
      ),
    );
  }
}

class _StripCell extends StatelessWidget {
  const _StripCell({
    required this.label,
    required this.time,
    required this.active,
    required this.theme,
    required this.narrow,
  });

  final String label;
  final String time;
  final bool active;
  final DuskHeroTheme theme;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppValues.heroCrossFade,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.gapSmall,
        horizontal: AppValues.gap_4,
      ),
      decoration: BoxDecoration(
        color: active ? theme.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(AppValues.gap),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DuskText.bangla(
              size: narrow ? AppValues.fontSize_11 : AppValues.fontSize_11_5,
              weight: active ? FontWeight.w700 : FontWeight.w600,
              color: active ? AppColors.goldInkSoft : theme.onMuted,
            ),
          ),
          Text(
            time,
            maxLines: 1,
            style: DuskText.bangla(
              size: narrow ? AppValues.fontSize_13 : AppValues.fontSize_14,
              weight: FontWeight.w700,
              color: active ? theme.accentInk : theme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Body pieces ─────────────────────────────────────────────────────────────

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.label,
    required this.value,
    required this.background,
    required this.labelColor,
    required this.valueColor,
    required this.shadow,
  });

  final String label;
  final String value;
  final Color background;
  final Color labelColor;
  final Color valueColor;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.cardSmall,
      color: background,
      shadow: shadow,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_14,
        horizontal: AppValues.cardPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: DuskText.rowSubtitleStrong.copyWith(color: labelColor),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DuskText.bangla(
              size: AppValues.fontSize_14_5,
              weight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerColumn extends StatelessWidget {
  const _TrackerColumn({
    required this.label,
    required this.state,
    required this.onTap,
  });

  final String label;
  final TrackerState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final due = state == TrackerState.due;

    return Column(
      children: [
        TrackerCircle(
          state: state,
          semanticLabel: label,
          onTap: state == TrackerState.future ? null : onTap,
        ),
        const SizedBox(height: AppValues.gap_6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DuskText.tileLabel.copyWith(
            fontWeight: due ? FontWeight.w700 : FontWeight.w600,
            color: switch (state) {
              TrackerState.due => AppColors.goldOnCanvas,
              TrackerState.future => AppColors.inkMuted,
              TrackerState.missed => AppColors.inkMuted,
              TrackerState.done => AppColors.ink,
            },
          ),
        ),
      ],
    );
  }
}

class _QuickItem extends StatelessWidget {
  const _QuickItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.cardSmall,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_12,
        horizontal: AppValues.gap_6,
      ),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DuskIconChip(
            icon: icon,
            size: AppValues.tileIconChip,
            radius: DuskRadius.iconChipLarge,
            iconSize: AppValues.icon_19,
          ),
          const SizedBox(height: AppValues.space_7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DuskText.tileLabel,
          ),
        ],
      ),
    );
  }
}
