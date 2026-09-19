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
import 'package:al_muttaqee/src/module/hadith/controllers/hadith_controller.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';

/// হাদিস — frame ১৫.
///
/// The hadith of the day lives inside the hero, so the screen gives something
/// to read before it gives something to browse. Underneath, the collections.
class HadithView extends BaseView<HadithController> {
  HadithView({super.key});

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
                  title: l10n.hadith,
                  theme: theme,
                  onBack: Get.back,
                  actions: [
                    DuskHeroIconButton(
                      icon: PhosphorIconsRegular.magnifyingGlass,
                      theme: theme,
                      semanticLabel: l10n.search,
                      onTap: controller.openSearch,
                    ),
                    DuskHeroIconButton(
                      icon: PhosphorIconsRegular.bookmarkSimple,
                      theme: theme,
                      semanticLabel: l10n.bookmark,
                      onTap: controller.openBookmarks,
                    ),
                  ],
                ),
                const SizedBox(height: AppValues.cardPadding),
                _dailyCard(l10n, theme),
              ],
            ),
          ),
          Expanded(child: _body(l10n)),
        ],
      ),
    );
  }

  // ── Hadith of the day ─────────────────────────────────────────────────────

  Widget _dailyCard(AppLocalizations l10n, DuskHeroTheme theme) {
    final hit = controller.dailyHadith.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
      child: Container(
        padding: const EdgeInsets.all(AppValues.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.14),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(DuskRadius.card),
        ),
        child: hit == null
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DuskSkeleton.line(width: 96, height: 12),
                  SizedBox(height: AppValues.space_12),
                  DuskSkeleton.line(height: AppValues.space_22),
                  SizedBox(height: AppValues.gapSmall),
                  DuskSkeleton.line(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.hadithOfTheDay,
                    style: DuskText.overline
                        .copyWith(color: AppColors.goldBright),
                  ),
                  if (hit.hadith.arabic.isNotEmpty) ...[
                    const SizedBox(height: AppValues.gapSmall),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        hit.hadith.arabic,
                        textAlign: TextAlign.right,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: DuskText.arabic(size: AppValues.fontSize_24)
                            .copyWith(color: theme.onPrimary),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppValues.gapSmall),
                  Text(
                    hit.hadith.bengali,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: DuskText.bangla(
                      size: AppValues.fontSize_15,
                      weight: FontWeight.w500,
                      height: 1.75,
                      color: theme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: AppValues.space_12),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.gold.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: AppValues.gapSmall),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${hit.bookName} · '
                          '${formatNumberWithLocale(hit.hadith.number)}',
                          style: DuskText.bangla(
                            size: AppValues.fontSize_12,
                            weight: FontWeight.w700,
                            color: theme.onMuted,
                          ),
                        ),
                      ),
                      Obx(
                        () => InkResponse(
                          onTap: () => controller.toggleBookmark(hit.hadith),
                          radius: AppValues.space_20,
                          child: Icon(
                            controller.isBookmarked(hit.hadith)
                                ? PhosphorIconsFill.bookmarkSimple
                                : PhosphorIconsRegular.bookmarkSimple,
                            size: AppValues.icon_18,
                            color: AppColors.goldBright,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // ── Collections ───────────────────────────────────────────────────────────

  Widget _body(AppLocalizations l10n) {
    if (controller.loadError.value.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: DuskErrorPanel(
          title: l10n.hadithLoadFailedTitle,
          message: l10n.hadithLoadFailedBody,
          actionLabel: l10n.retry,
          onAction: controller.load,
        ),
      );
    }

    if (controller.isLoading.value) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(
          AppValues.screenPadding,
          AppValues.cardPadding,
          AppValues.screenPadding,
          AppValues.space_24,
        ),
        children: [
          // The first launch inflates a 113 MB corpus, which takes a couple of
          // seconds. Saying so beats a bare spinner, because the wait only
          // ever happens once and the user should know that.
          Text(
            l10n.hadithPreparing,
            style: DuskText.bodySmall.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppValues.groupGap),
          for (var i = 0; i < 5; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppValues.cardGap),
              child: DuskSkeleton(
                width: double.infinity,
                height: 72,
                radius: DuskRadius.cardTight,
              ),
            ),
        ],
      );
    }

    final curated = controller.curated;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.cardPadding,
        AppValues.screenPadding,
        AppValues.space_24,
      ),
      children: [
        DuskOverline(l10n.hadithCollectionsOverline),
        for (final book in controller.browsable)
          Padding(
            padding: const EdgeInsets.only(bottom: AppValues.cardGap),
            child: _CollectionCard(
              book: book,
              onTap: () => controller.selectBook(book),
            ),
          ),
        if (curated != null) ...[
          const SizedBox(height: AppValues.gap_4),
          _CuratedCard(
            book: curated,
            onTap: () => controller.selectBook(curated),
          ),
        ],
        const SizedBox(height: AppValues.groupGap),
        Text(
          l10n.hadithAttribution,
          style: DuskText.caption.copyWith(color: AppColors.inkMuted),
        ),
      ],
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.book, required this.onTap});

  final HadithBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DuskCard(
      radius: DuskRadius.cardTight,
      onTap: onTap,
      child: Row(
        children: [
          const DuskIconChip(
            icon: PhosphorIconsRegular.book,
            size: AppValues.tileIconChip,
            radius: DuskRadius.iconChipLarge - 1,
            iconSize: AppValues.icon_19,
          ),
          const SizedBox(width: AppValues.space_13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.nameBn, style: DuskText.cardHeading),
                Text(
                  l10n.hadithCollectionMeta(
                    formatNumberWithLocale(book.chapterCount),
                    formatGrouped(book.hadithCount),
                  ),
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
  }
}

/// ৪০ হাদিস নববি — the curated entry point, given a gold chip and an explicit
/// "start here" pill instead of a chevron, because for a newcomer the right
/// first move is not to open Bukhari at chapter one.
class _CuratedCard extends StatelessWidget {
  const _CuratedCard({required this.book, required this.onTap});

  final HadithBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DuskCard(
      radius: DuskRadius.cardTight,
      color: AppColors.goldTintCard,
      border: Border.all(color: AppColors.goldTintBorder),
      shadow: const [],
      onTap: onTap,
      child: Row(
        children: [
          const DuskIconChip(
            icon: PhosphorIconsFill.sparkle,
            size: AppValues.tileIconChip,
            radius: DuskRadius.iconChipLarge - 1,
            background: AppColors.goldTint,
            foreground: AppColors.goldOnIvory,
            iconSize: AppValues.icon_19,
          ),
          const SizedBox(width: AppValues.space_13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.nameBn,
                  style: DuskText.cardHeading
                      .copyWith(color: AppColors.goldTintInk),
                ),
                Text(
                  l10n.hadithCuratedSubtitle(
                    formatNumberWithLocale(book.hadithCount),
                  ),
                  style: DuskText.rowSubtitleStrong
                      .copyWith(color: AppColors.goldOnCanvas),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.gapXSmall),
          DuskPill(
            label: l10n.hadithStartHere,
            background: AppColors.gold,
            foreground: AppColors.goldInk,
          ),
        ],
      ),
    );
  }
}
