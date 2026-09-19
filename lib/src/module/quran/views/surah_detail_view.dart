import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:quran_flutter/quran_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:al_muttaqee/src/module/quran/views/ayah_action_sheet.dart';
import 'package:al_muttaqee/src/module/quran/views/reader_theme.dart';

/// সূরা পাঠ — frames ০৫ and ০৬.
///
/// Not a hero screen. The reading surface is the page, and a gradient band
/// across the top would only push the text down and compete with it.
class SurahDetailView extends BaseView<QuranController> {
  SurahDetailView({
    super.key,
    required this.surahNumber,
    this.initialAyahNumber = 1,
  });

  final int surahNumber;
  final int initialAyahNumber;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() =>
      controller.nightMode.value ? AppColors.nightBg : AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  SurahMeta? get _surah =>
      controller.surahs.firstWhereOrNull((s) => s.number == surahNumber);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final theme = ReaderTheme.of(controller.nightMode.value);
      final surah = _surah;
      final arabic = controller.getSurahVersesArabic(surahNumber);
      final translated = controller.getSurahVersesTranslated(surahNumber);

      return ColoredBox(
        color: theme.page,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _topBar(context, l10n, theme, surah),
                  _progressTrack(theme, arabic.length),
                  Expanded(
                    child: ListView.separated(
                      controller: controller.surahScrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppValues.screenPadding,
                        AppValues.cardPadding,
                        AppValues.screenPadding,
                        // Clear of the player bar, which floats over the list.
                        150,
                      ),
                      itemCount: arabic.length + 1,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppValues.cardGap),
                      itemBuilder: (context, index) {
                        if (index == 0) return _bismillah(theme);

                        final number = index;
                        return _AyahCard(
                          controller: controller,
                          theme: theme,
                          surah: surahNumber,
                          surahName: surah?.banglaName ?? '',
                          ayah: number,
                          arabic: _textOf(arabic, number),
                          translation: _textOf(translated, number),
                          l10n: l10n,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _PlayerBar(
                  controller: controller,
                  surah: surahNumber,
                  ayahCount: arabic.length,
                  l10n: l10n,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _textOf(List<Verse> verses, int number) {
    final verse = verses.firstWhereOrNull((v) => v.verseNumber == number);
    return verse?.text ?? '';
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _topBar(
    BuildContext context,
    AppLocalizations l10n,
    ReaderTheme theme,
    SurahMeta? surah,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppValues.gapXSmall,
        AppValues.gap_4,
        AppValues.gapXSmall,
        AppValues.gapSmall,
      ),
      decoration: BoxDecoration(
        color: theme.page,
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Row(
        children: [
          InkResponse(
            onTap: Get.back,
            radius: AppValues.space_22,
            child: SizedBox(
              width: AppValues.minTapTarget,
              height: AppValues.minTapTarget,
              child: Icon(
                PhosphorIconsRegular.arrowLeft,
                size: AppValues.icon_21,
                color: theme.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  surah?.banglaName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_16,
                    weight: FontWeight.w700,
                    color: theme.primary,
                  ),
                ),
                Text(
                  '${formatNumberWithLocale(surahNumber)} · '
                  '${l10n.quranAyahCount(formatNumberWithLocale(surah?.ayahCount ?? 0))}'
                  ' · ${surah?.isMeccan ?? true ? l10n.quranRevelationMeccan : l10n.quranRevelationMedinan}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_11,
                    weight: FontWeight.w400,
                    color: theme.muted,
                  ),
                ),
              ],
            ),
          ),
          _barAction(
            icon: PhosphorIconsRegular.textAa,
            theme: theme,
            label: l10n.quranTypeSettings,
            onTap: () => _typeSheet(context, l10n),
          ),
          _barAction(
            icon: controller.nightMode.value
                ? PhosphorIconsFill.moon
                : PhosphorIconsRegular.moon,
            theme: theme,
            label: l10n.settingNightMode,
            onTap: controller.toggleNightMode,
            highlighted: controller.nightMode.value,
          ),
        ],
      ),
    );
  }

  Widget _barAction({
    required IconData icon,
    required ReaderTheme theme,
    required String label,
    required VoidCallback onTap,
    bool highlighted = false,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: AppValues.space_22,
        child: SizedBox(
          width: AppValues.minTapTarget,
          height: AppValues.minTapTarget,
          child: Icon(
            icon,
            size: AppValues.icon_20,
            color: highlighted ? theme.accent : theme.primary,
          ),
        ),
      ),
    );
  }

  /// Position in the surah, as a hairline under the top bar.
  Widget _progressTrack(ReaderTheme theme, int total) {
    return SizedBox(
      height: 4,
      child: Obx(() {
        final playing = controller.playingSurahNumber == surahNumber
            ? controller.playingAyahNumber ?? 0
            : 0;
        final value = total <= 0 ? 0.0 : (playing / total).clamp(0.0, 1.0);
        return LinearProgressIndicator(
          value: value,
          minHeight: 4,
          backgroundColor: theme.page == AppColors.nightBg
              ? AppColors.nightBorder
              : AppColors.trackEmpty,
          valueColor: AlwaysStoppedAnimation(theme.accent),
        );
      }),
    );
  }

  // ── Bismillah ─────────────────────────────────────────────────────────────

  Widget _bismillah(ReaderTheme theme) {
    // At-Tawbah is the one surah that does not open with the basmala.
    if (surahNumber == 9) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_20,
        horizontal: AppValues.cardPadding,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.duskDeep, AppColors.duskMid],
        ),
        borderRadius: BorderRadius.circular(DuskRadius.cardTight),
      ),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: DuskText.arabic(
          size: AppValues.fontSize_23 * controller.arabicScale.value,
        ).copyWith(color: AppColors.onDeepPrimary),
      ),
    );
  }

  // ── Type settings ─────────────────────────────────────────────────────────

  Future<void> _typeSheet(BuildContext context, AppLocalizations l10n) async {
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
          child: Obx(
            () => Column(
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
                Text(l10n.quranTypeSettings, style: DuskText.cardHeading),
                const SizedBox(height: AppValues.space_18),
                _ScaleRow(
                  label: l10n.quranArabicSize,
                  value: controller.arabicScale.value,
                  onChanged: controller.setArabicScale,
                  sample: 'بِسْمِ اللَّه',
                  sampleStyle: DuskText.arabic(
                    size: AppValues.fontSize_23 * controller.arabicScale.value,
                  ).copyWith(color: AppColors.duskDeep),
                ),
                const SizedBox(height: AppValues.space_18),
                _ScaleRow(
                  label: l10n.quranTranslationSize,
                  value: controller.translationScale.value,
                  onChanged: controller.setTranslationScale,
                  sample: 'পরম করুণাময়',
                  sampleStyle: DuskText.bodyTight.copyWith(
                    fontSize:
                        AppValues.fontSize_14 *
                        controller.translationScale.value,
                    color: AppColors.inkBody,
                  ),
                ),
                const SizedBox(height: AppValues.space_18),
                GroupedCard(
                  children: [
                    GroupedRow(
                      title: l10n.quranShowTranslation,
                      titleStyle: DuskText.rowLabel.copyWith(
                        color: AppColors.ink,
                      ),
                      trailing: DuskSwitch(
                        value: controller.showTranslation.value,
                        onChanged: (_) => controller.toggleTranslation(),
                      ),
                    ),
                    GroupedRow(
                      title: l10n.settingNightMode,
                      titleStyle: DuskText.rowLabel.copyWith(
                        color: AppColors.ink,
                      ),
                      trailing: DuskSwitch(
                        value: controller.nightMode.value,
                        onChanged: (_) => controller.toggleNightMode(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }
}

/// One ayah.
class _AyahCard extends StatelessWidget {
  const _AyahCard({
    required this.controller,
    required this.theme,
    required this.surah,
    required this.surahName,
    required this.ayah,
    required this.arabic,
    required this.translation,
    required this.l10n,
  });

  final QuranController controller;
  final ReaderTheme theme;
  final int surah;
  final String surahName;
  final int ayah;
  final String arabic;
  final String translation;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final playing =
          controller.playingSurahNumber == surah &&
          controller.playingAyahNumber == ayah;
      final bookmarked = controller.isBookmarked(surah, ayah);
      final note = controller.noteFor(surah, ayah);

      return GestureDetector(
        // Tapping the body does nothing on purpose. It used to start
        // playback, which fired constantly by accident mid-read.
        onLongPress: () => showAyahActionSheet(
          context: context,
          controller: controller,
          surah: surah,
          ayah: ayah,
          arabic: arabic,
          translation: translation,
          surahName: surahName,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppValues.cardPaddingWide),
          decoration: BoxDecoration(
            color: playing ? theme.playingFill : theme.card,
            borderRadius: BorderRadius.circular(DuskRadius.cardTight),
            border: playing ? Border.all(color: theme.playingBorder) : null,
            boxShadow: playing || theme.page == AppColors.nightBg
                ? const []
                : AppColors.shadowCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(playing, bookmarked),
              const SizedBox(height: AppValues.space_12),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  arabic,
                  textAlign: TextAlign.right,
                  style: DuskText.ayah.copyWith(
                    fontSize:
                        AppValues.fontSize_25 * controller.arabicScale.value,
                    color: theme.arabic,
                  ),
                ),
              ),
              if (controller.showTranslation.value &&
                  translation.isNotEmpty) ...[
                const SizedBox(height: AppValues.space_12),
                Text(
                  translation,
                  style: DuskText.body.copyWith(
                    fontSize:
                        AppValues.fontSize_14 *
                        controller.translationScale.value,
                    color: theme.body,
                  ),
                ),
              ],
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: AppValues.space_12),
                _note(note),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _header(bool playing, bool bookmarked) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppValues.gap_3,
            horizontal: AppValues.gapSmall,
          ),
          decoration: BoxDecoration(
            color: playing ? theme.accent : theme.chip,
            borderRadius: BorderRadius.circular(DuskRadius.chip),
          ),
          child: Text(
            formatNumberWithLocale(ayah),
            style: DuskText.bangla(
              size: AppValues.fontSize_12,
              weight: FontWeight.w800,
              color: playing ? theme.accentInk : theme.chipInk,
            ),
          ),
        ),
        if (playing) ...[
          const SizedBox(width: AppValues.gap_6),
          Icon(
            PhosphorIconsFill.waveform,
            size: AppValues.iconSmall,
            color: theme.playingInk,
          ),
          const SizedBox(width: AppValues.gap_4),
          Text(
            l10n.quranPlayingNow,
            style: DuskText.bangla(
              size: AppValues.fontSize_11_5,
              weight: FontWeight.w700,
              color: theme.playingInk,
            ),
          ),
        ],
        const Spacer(),
        InkResponse(
          onTap: () => controller.toggleBookmark(surah, ayah),
          radius: AppValues.space_20,
          child: Icon(
            bookmarked
                ? PhosphorIconsFill.bookmarkSimple
                : PhosphorIconsRegular.bookmarkSimple,
            size: AppValues.iconSmall,
            color: bookmarked ? AppColors.goldOnIvory : theme.muted,
          ),
        ),
      ],
    );
  }

  Widget _note(String note) {
    return Container(
      padding: const EdgeInsets.all(AppValues.space_11),
      decoration: BoxDecoration(
        color: theme.page == AppColors.nightBg
            ? AppColors.nightChip
            : AppColors.neutralFill,
        borderRadius: BorderRadius.circular(DuskRadius.iconChip),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIconsRegular.pencilSimple,
            size: AppValues.iconXSmall,
            color: theme.muted,
          ),
          const SizedBox(width: AppValues.gap_6),
          Expanded(
            child: Text(
              note,
              style: DuskText.bodySmall.copyWith(color: theme.body),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleRow extends StatelessWidget {
  const _ScaleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.sample,
    required this.sampleStyle,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String sample;
  final TextStyle sampleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: DuskText.rowLabel.copyWith(color: AppColors.ink),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: DuskText.rowTrailing.copyWith(color: AppColors.inkMuted),
            ),
          ],
        ),
        // A live sample, so the slider is judged against the real face at the
        // real size rather than against a percentage.
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.gap_6),
          child: Text(sample, style: sampleStyle),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.gold,
            inactiveTrackColor: AppColors.trackEmpty,
            thumbColor: AppColors.duskMid,
            overlayColor: AppColors.sage.withValues(alpha: 0.4),
          ),
          child: Slider(
            value: value,
            min: 0.8,
            max: 1.8,
            divisions: 10,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// The player, fixed above the page.
///
/// It floats rather than scrolling with the list because playback is a mode
/// the reader is in, not an item on the page — and because the one control
/// somebody reaches for mid-recitation is pause, which must not have scrolled
/// away.
class _PlayerBar extends StatelessWidget {
  const _PlayerBar({
    required this.controller,
    required this.surah,
    required this.ayahCount,
    required this.l10n,
  });

  final QuranController controller;
  final int surah;
  final int ayahCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.playingSurahNumber == surah;
      final ayah = active ? (controller.playingAyahNumber ?? 1) : 1;
      final playing = active && controller.isPlaying;

      return Container(
        margin: const EdgeInsets.all(AppValues.space_14),
        padding: const EdgeInsets.symmetric(
          vertical: AppValues.space_14,
          horizontal: AppValues.cardPaddingWide,
        ),
        decoration: BoxDecoration(
          color: AppColors.duskDeep,
          borderRadius: BorderRadius.circular(AppValues.space_28),
          boxShadow: AppColors.shadowNav,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  PhosphorIconsFill.microphone,
                  size: AppValues.fontSize_15,
                  color: AppColors.gold,
                ),
                const SizedBox(width: AppValues.gap_6),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _reciterSheet(context),
                    child: Text(
                      controller.selectedReciter.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DuskText.bangla(
                        size: AppValues.fontSize_12_5,
                        weight: FontWeight.w600,
                        color: AppColors.onDeepPrimary,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _cycleSpeed,
                  child: Text(
                    '${formatNumberWithLocale(controller.playbackSpeed.round())}'
                    '${controller.playbackSpeed % 1 == 0 ? '' : '.৫'}×',
                    style: DuskText.bangla(
                      size: AppValues.fontSize_11_5,
                      weight: FontWeight.w700,
                      color: AppColors.goldBright,
                    ),
                  ),
                ),
                const SizedBox(width: AppValues.gapSmall),
                InkResponse(
                  onTap: () => controller.downloadSurah(surah),
                  radius: AppValues.space_20,
                  child: Icon(
                    controller.isSurahDownloaded(surah)
                        ? PhosphorIconsBold.checks
                        : PhosphorIconsRegular.arrowCircleDown,
                    size: AppValues.icon_19,
                    color: controller.isSurahDownloaded(surah)
                        ? AppColors.goldBright
                        : AppColors.onDeepPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.space_12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _control(
                  icon: PhosphorIconsRegular.repeatOnce,
                  active: controller.repeatAyah,
                  onTap: controller.toggleRepeatAyah,
                ),
                _control(
                  icon: PhosphorIconsFill.skipBack,
                  onTap: ayah > 1
                      ? () => controller.playAyah(surah, ayah - 1)
                      : null,
                ),
                GestureDetector(
                  onTap: () => controller.togglePlayback(surah, ayah),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      playing
                          ? PhosphorIconsFill.pause
                          : PhosphorIconsFill.play,
                      size: AppValues.icon_22,
                      color: AppColors.goldInk,
                    ),
                  ),
                ),
                _control(
                  icon: PhosphorIconsFill.skipForward,
                  onTap: ayah < ayahCount
                      ? () => controller.playAyah(surah, ayah + 1)
                      : null,
                ),
                _control(
                  icon: PhosphorIconsRegular.repeat,
                  active: controller.repeatSurah,
                  onTap: controller.toggleRepeatSurah,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _control({
    required IconData icon,
    VoidCallback? onTap,
    bool active = false,
  }) {
    return InkResponse(
      onTap: onTap,
      radius: AppValues.space_24,
      child: SizedBox(
        width: AppValues.minTapTarget,
        height: AppValues.minTapTarget,
        child: Icon(
          icon,
          size: AppValues.icon_21,
          color: active
              ? AppColors.gold
              : onTap == null
              ? AppColors.onDeepMuted.withValues(alpha: 0.4)
              : AppColors.onDeepPrimary,
        ),
      ),
    );
  }

  /// Steps through the speeds people actually use. A slider would be more
  /// flexible and much worse: nobody wants 1.37x recitation.
  void _cycleSpeed() {
    const speeds = [0.75, 1.0, 1.25, 1.5];
    final index = speeds.indexOf(controller.playbackSpeed);
    controller.setPlaybackSpeed(speeds[(index + 1) % speeds.length]);
  }

  Future<void> _reciterSheet(BuildContext context) async {
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
              Text(l10n.reciter, style: DuskText.cardHeading),
              const SizedBox(height: AppValues.gapSmall),
              Obx(
                () => GroupedCard(
                  children: [
                    for (final reciter in QuranController.reciters)
                      GroupedRow(
                        title: reciter.name,
                        titleStyle: DuskText.rowLabel.copyWith(
                          color: reciter.id == controller.selectedReciter.id
                              ? AppColors.goldTintInk
                              : AppColors.ink,
                        ),
                        tinted: reciter.id == controller.selectedReciter.id,
                        trailing: Icon(
                          reciter.id == controller.selectedReciter.id
                              ? PhosphorIconsFill.checkCircle
                              : PhosphorIconsRegular.circle,
                          size: AppValues.icon_20,
                          color: reciter.id == controller.selectedReciter.id
                              ? AppColors.goldOnIvory
                              : AppColors.dashedBorder,
                        ),
                        onTap: () {
                          controller.selectReciter(reciter);
                          Get.back<void>();
                        },
                      ),
                  ],
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
