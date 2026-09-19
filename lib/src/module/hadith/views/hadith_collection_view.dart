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

/// The kitab list for one collection.
class HadithCollectionView extends BaseView<HadithController> {
  HadithCollectionView({super.key});

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

    final slug = Get.parameters['collection'];
    if (slug != null) {
      // Entering by deep link rather than through the list, so the chapters
      // may not have been read yet. Scheduled off the build, since it writes
      // to observables the build is already reading.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.ensureChaptersFor(slug),
      );
    }

    return Obx(() {
      final book = controller.openBook.value;

      return Column(
        children: [
          DuskHero(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuskHeroTitleRow(
                  title: book?.nameBn ?? l10n.hadith,
                  theme: theme,
                  onBack: Get.back,
                  actions: [
                    DuskHeroIconButton(
                      icon: PhosphorIconsRegular.magnifyingGlass,
                      theme: theme,
                      semanticLabel: l10n.search,
                      onTap: controller.openSearch,
                    ),
                  ],
                ),
                if (book != null) ...[
                  const SizedBox(height: AppValues.gapXSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.heroPadding,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.hadithCollectionMeta(
                              formatNumberWithLocale(book.chapterCount),
                              formatGrouped(book.hadithCount),
                            ),
                            style: DuskText.bangla(
                              size: AppValues.fontSize_12_5,
                              weight: FontWeight.w400,
                              color: theme.onMuted,
                            ),
                          ),
                        ),
                        Text(
                          book.nameAr,
                          style: DuskText.arabic(size: AppValues.fontSize_19)
                              .copyWith(color: AppColors.goldBright),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: controller.isLoadingChapters.value
                ? ListView.builder(
                    padding: const EdgeInsets.all(AppValues.screenPadding),
                    itemCount: 8,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: AppValues.cardGap),
                      child: DuskSkeleton(
                        width: double.infinity,
                        height: 56,
                        radius: DuskRadius.cardSmall,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppValues.screenPadding,
                      AppValues.cardPadding,
                      AppValues.screenPadding,
                      AppValues.space_24,
                    ),
                    children: [
                      GroupedCard(
                        children: [
                          for (final chapter in controller.chapters)
                            GroupedRow(
                              title: chapter.nameBn,
                              subtitle: l10n.hadithChapterMeta(
                                formatNumberWithLocale(chapter.hadithCount),
                              ),
                              leading: DuskIconChip(
                                icon: PhosphorIconsRegular.bookBookmark,
                                background: AppColors.sage,
                                foreground: AppColors.duskMid,
                              ),
                              chevron: true,
                              onTap: () => controller.selectChapter(chapter),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
