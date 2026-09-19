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
import 'package:al_muttaqee/src/module/hadith/views/hadith_widgets.dart';

/// The hadiths of one kitab.
class HadithChapterView extends BaseView<HadithController> {
  HadithChapterView({super.key});

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

    return Obx(() {
      final chapter = controller.openChapter.value;
      final book = controller.openBook.value;

      return Column(
        children: [
          DuskHero(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuskHeroTitleRow(
                  title: chapter?.nameBn ?? l10n.hadith,
                  theme: theme,
                  onBack: Get.back,
                  actions: [
                    DuskHeroIconButton(
                      icon: PhosphorIconsRegular.bookmarkSimple,
                      theme: theme,
                      semanticLabel: l10n.bookmark,
                      onTap: controller.openBookmarks,
                    ),
                  ],
                ),
                if (book != null) ...[
                  const SizedBox(height: AppValues.gap_4),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.heroPadding,
                    ),
                    child: Text(
                      '${book.nameBn} · '
                      '${l10n.hadithChapterMeta(formatNumberWithLocale(chapter?.hadithCount ?? 0))}',
                      style: DuskText.bangla(
                        size: AppValues.fontSize_12_5,
                        weight: FontWeight.w400,
                        color: theme.onMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: controller.isLoadingHadiths.value
                ? ListView.builder(
                    padding: const EdgeInsets.all(AppValues.screenPadding),
                    itemCount: 4,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: AppValues.cardGap),
                      child: DuskSkeleton(
                        width: double.infinity,
                        height: 180,
                        radius: DuskRadius.cardTight,
                      ),
                    ),
                  )
                // Builder, not a Column: a kitab can run to several hundred
                // hadiths and each card carries two long text blocks, so they
                // have to be built lazily or the screen janks on open.
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppValues.screenPadding,
                      AppValues.cardPadding,
                      AppValues.screenPadding,
                      AppValues.space_24,
                    ),
                    itemCount: controller.hadiths.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppValues.cardGap),
                    itemBuilder: (context, index) => HadithCard(
                      hadith: controller.hadiths[index],
                      controller: controller,
                      bookName: book?.nameBn,
                      chapterName: chapter?.nameBn,
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
