import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_library_models.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:al_muttaqee/src/module/quran/views/surah_detail_view.dart';

/// কুরআন — frame ০৪.
///
/// The hero is the last-read card, not a title: the overwhelmingly common
/// reason to open this tab is to carry on from yesterday, and making that a
/// single tap at the top is worth more than anything else on the screen.
class QuranView extends BaseView<QuranController> {
  QuranView({super.key});

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

    return Obx(
      () => Column(
        children: [
          DuskHero(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuskHeroTitleRow(
                  title: l10n.quran,
                  theme: theme,
                  large: true,
                  actions: [
                    DuskHeroIconButton(
                      icon: PhosphorIconsRegular.magnifyingGlass,
                      theme: theme,
                      semanticLabel: l10n.search,
                      onTap: () => _search(context, l10n),
                    ),
                    DuskHeroIconButton(
                      icon: PhosphorIconsRegular.slidersHorizontal,
                      theme: theme,
                      semanticLabel: l10n.quranPlanTitle,
                      onTap: () => Get.toNamed(Routes.readingPlan),
                    ),
                  ],
                ),
                const SizedBox(height: AppValues.cardPadding),
                _lastReadCard(l10n, theme),
              ],
            ),
          ),
          Expanded(child: _list(context, l10n)),
        ],
      ),
    );
  }

  // ── Last read ─────────────────────────────────────────────────────────────

  Widget _lastReadCard(AppLocalizations l10n, DuskHeroTheme theme) {
    final surah = controller.lastReadSurah;
    final ayah = controller.lastReadAyah;
    final progress = controller.planProgress;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
      child: Material(
        color: AppColors.gold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(DuskRadius.cardTight),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => surah == null
              ? controller.openSurah(controller.surahs.first, ayah: 1)
              : controller.openSurah(surah, ayah: ayah),
          child: Container(
            padding: const EdgeInsets.all(AppValues.cardPadding),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(DuskRadius.cardTight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah == null
                            ? l10n.quranStartReading
                            : l10n.quranLastRead,
                        style: DuskText.overline
                            .copyWith(color: AppColors.goldBright),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        surah == null
                            ? l10n.quranNoLastReadYet
                            : '${surah.banglaName} · '
                                '${l10n.quranAyahNumberLabel(ayah)}',
                        style: DuskText.bangla(
                          size: AppValues.fontSize_21,
                          weight: FontWeight.w700,
                          color: theme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: AppValues.gap_6),
                      _planLine(l10n, theme, progress),
                    ],
                  ),
                ),
                const SizedBox(width: AppValues.space_12),
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    PhosphorIconsBold.arrowRight,
                    size: AppValues.icon_20,
                    color: AppColors.goldInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planLine(
    AppLocalizations l10n,
    DuskHeroTheme theme,
    double? progress,
  ) {
    // No plan set is not a failure state — it is an invitation, so it reads as
    // one rather than as an empty progress bar.
    if (progress == null) {
      return Text(
        l10n.quranNoPlanYet,
        style: DuskText.bangla(
          size: AppValues.fontSize_12_5,
          weight: FontWeight.w400,
          color: theme.onMuted,
        ),
      );
    }

    final target = controller.plan.value.dailyAyahTarget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          target > 0
              ? l10n.quranPlanProgress(
                  formatNumberWithLocale(
                    controller.todayProgress.value.ayahsRead,
                  ),
                  formatNumberWithLocale(target),
                )
              : l10n.quranPlanMinutesProgress(
                  formatNumberWithLocale(
                    controller.todayProgress.value.minutesRead,
                  ),
                  formatNumberWithLocale(controller.plan.value.target),
                ),
          style: DuskText.bangla(
            size: AppValues.fontSize_12_5,
            weight: FontWeight.w400,
            color: theme.onMuted,
          ),
        ),
        const SizedBox(height: AppValues.gap_6),
        ClipRRect(
          borderRadius: BorderRadius.circular(DuskRadius.chip),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor:
                AppColors.onDeepPrimary.withValues(alpha: 0.22),
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
          ),
        ),
      ],
    );
  }

  // ── Tabs and list ─────────────────────────────────────────────────────────

  Widget _list(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: AppValues.cardPadding),
        _tabs(l10n),
        const SizedBox(height: AppValues.space_12),
        Expanded(
          child: switch (controller.indexTab.value) {
            1 => _paraList(l10n),
            2 => _bookmarkList(l10n),
            _ => _surahList(l10n),
          },
        ),
      ],
    );
  }

  Widget _tabs(AppLocalizations l10n) {
    final labels = [
      l10n.quranSurahTab,
      l10n.quranParaTab,
      l10n.quranBookmarkTab,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: AppValues.gapXSmall),
            Expanded(
              child: _PillTab(
                label: labels[i],
                active: controller.indexTab.value == i,
                onTap: () => controller.indexTab.value = i,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _surahList(AppLocalizations l10n) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        0,
        AppValues.screenPadding,
        AppValues.space_24,
      ),
      itemCount: controller.surahs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.cardGap),
      itemBuilder: (context, index) {
        final surah = controller.surahs[index];
        return _SurahCard(
          surah: surah,
          downloaded: controller.isSurahDownloaded(surah.number),
          onTap: () => controller.openSurah(surah),
          l10n: l10n,
        );
      },
    );
  }

  Widget _paraList(AppLocalizations l10n) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        0,
        AppValues.screenPadding,
        AppValues.space_24,
      ),
      itemCount: controller.paras.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.cardGap),
      itemBuilder: (context, index) {
        final para = controller.paras[index];
        final surah = controller.surahs.firstWhereOrNull(
          (s) => s.number == para.startSurahNumber,
        );
        return DuskCard(
          radius: DuskRadius.cardSmall,
          onTap: surah == null
              ? null
              : () => controller.openSurah(surah, ayah: para.startVerseNumber),
          child: Row(
            children: [
              _NumberChip(value: para.number),
              const SizedBox(width: AppValues.space_12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quranParaLabel(para.number),
                      style: DuskText.cardHeading,
                    ),
                    Text(
                      surah?.banglaName ?? '',
                      style: DuskText.rowSubtitle
                          .copyWith(color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
              const Icon(
                PhosphorIconsRegular.caretRight,
                size: AppValues.icon_17,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bookmarkList(AppLocalizations l10n) {
    final refs = controller.bookmarks.toList()
      ..sort((a, b) {
        final bySurah = a.surah.compareTo(b.surah);
        return bySurah != 0 ? bySurah : a.ayah.compareTo(b.ayah);
      });

    if (refs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.space_34),
          child: DuskEmptyState(
            icon: PhosphorIconsRegular.bookmarkSimple,
            message: l10n.quranNoBookmarks,
            actionLabel: l10n.quranStartReading,
            onAction: () => controller.indexTab.value = 0,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        0,
        AppValues.screenPadding,
        AppValues.space_24,
      ),
      itemCount: refs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.cardGap),
      itemBuilder: (context, index) {
        final ref = refs[index];
        final surah = controller.surahs.firstWhereOrNull(
          (s) => s.number == ref.surah,
        );
        final note = controller.noteFor(ref.surah, ref.ayah);

        return DuskCard(
          radius: DuskRadius.cardSmall,
          onTap: surah == null
              ? null
              : () => controller.openSurah(surah, ayah: ref.ayah),
          child: Row(
            children: [
              const DuskIconChip(
                icon: PhosphorIconsFill.bookmarkSimple,
                background: AppColors.goldTint,
                foreground: AppColors.goldOnIvory,
              ),
              const SizedBox(width: AppValues.space_12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${surah?.banglaName ?? ''} · '
                      '${l10n.quranAyahNumberLabel(ref.ayah)}',
                      style: DuskText.rowTitle,
                    ),
                    if (note != null && note.isNotEmpty)
                      Text(
                        note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: DuskText.rowSubtitle
                            .copyWith(color: AppColors.inkMuted),
                      ),
                  ],
                ),
              ),
              if (note != null && note.isNotEmpty)
                const Icon(
                  PhosphorIconsRegular.pencilSimple,
                  size: AppValues.iconSmall,
                  color: AppColors.inkMuted,
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Search ────────────────────────────────────────────────────────────────

  Future<void> _search(BuildContext context, AppLocalizations l10n) async {
    final query = ValueNotifier<String>('');

    await Get.bottomSheet<void>(
      Container(
        height: MediaQuery.sizeOf(context).height * 0.82,
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
          0,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.grabHandle,
                  borderRadius: BorderRadius.circular(DuskRadius.chip),
                ),
              ),
              const SizedBox(height: AppValues.space_18),
              TextField(
                autofocus: true,
                onChanged: (value) => query.value = value,
                style: DuskText.rowTitle,
                decoration: InputDecoration(
                  hintText: l10n.quranSearchHint,
                  hintStyle: DuskText.rowSubtitle
                      .copyWith(color: AppColors.inkMuted),
                  prefixIcon: const Icon(
                    PhosphorIconsRegular.magnifyingGlass,
                    size: AppValues.icon_19,
                    color: AppColors.inkMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DuskRadius.inner),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppValues.space_12),
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: query,
                  builder: (context, value, _) {
                    final needle = value.trim().toLowerCase();
                    // Matches the Bangla name, the English name and the
                    // number, because people look surahs up by all three.
                    final results = needle.isEmpty
                        ? controller.surahs
                        : controller.surahs.where((s) {
                            return s.banglaName.toLowerCase().contains(needle) ||
                                s.englishName
                                    .toLowerCase()
                                    .contains(needle) ||
                                s.number.toString() == needle;
                          }).toList();

                    return ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppValues.cardGap),
                      itemBuilder: (context, index) => _SurahCard(
                        surah: results[index],
                        downloaded:
                            controller.isSurahDownloaded(results[index].number),
                        l10n: l10n,
                        onTap: () {
                          Get.back<void>();
                          controller.openSurah(results[index]);
                        },
                      ),
                    );
                  },
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

class _PillTab extends StatelessWidget {
  const _PillTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.duskDeep : AppColors.surface,
      borderRadius: BorderRadius.circular(DuskRadius.chip),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.space_11),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: DuskText.bangla(
              size: AppValues.fontSize_13,
              weight: FontWeight.w700,
              color: active
                  ? AppColors.onDeepPrimary
                  : AppColors.inkSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.sage,
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: Text(
        formatNumberWithLocale(value),
        style: DuskText.bangla(
          size: AppValues.fontSize_13_5,
          weight: FontWeight.w800,
          color: AppColors.duskMid,
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  const _SurahCard({
    required this.surah,
    required this.downloaded,
    required this.onTap,
    required this.l10n,
  });

  final SurahMeta surah;
  final bool downloaded;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.cardSmall,
      onTap: onTap,
      child: Row(
        children: [
          _NumberChip(value: surah.number),
          const SizedBox(width: AppValues.space_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(surah.banglaName, style: DuskText.cardHeading),
                Text(
                  '${surah.isMeccan ? l10n.quranRevelationMeccan : l10n.quranRevelationMedinan}'
                  ' · ${l10n.quranAyahCount(formatNumberWithLocale(surah.ayahCount))}',
                  style: DuskText.rowSubtitle
                      .copyWith(color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          if (downloaded) ...[
            const Icon(
              PhosphorIconsFill.checkCircle,
              size: AppValues.iconSmall,
              color: AppColors.goldOnIvory,
            ),
            const SizedBox(width: AppValues.gapXSmall),
          ],
          Text(
            surah.arabicName,
            style: DuskText.arabicSurahName.copyWith(color: AppColors.duskMid),
          ),
        ],
      ),
    );
  }
}
