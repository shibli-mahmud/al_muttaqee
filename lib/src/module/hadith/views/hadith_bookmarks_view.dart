import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/module/hadith/controllers/hadith_controller.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';
import 'package:al_muttaqee/src/module/hadith/views/hadith_widgets.dart';

/// Saved hadiths.
class HadithBookmarksView extends BaseView<HadithController> {
  HadithBookmarksView({super.key});

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
          child: DuskHeroTitleRow(
            title: l10n.hadithBookmarksTitle,
            theme: theme,
            onBack: Get.back,
          ),
        ),
        Expanded(
          // Keyed on the bookmark set so removing one from this screen
          // re-runs the query and the row actually leaves the list.
          child: Obx(
            () => FutureBuilder<List<HadithHit>>(
              key: ValueKey(controller.bookmarkIds.join(',')),
              future: controller.loadBookmarks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(AppValues.screenPadding),
                    itemCount: 3,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: AppValues.cardGap),
                      child: DuskSkeleton(
                        width: double.infinity,
                        height: 150,
                        radius: DuskRadius.cardTight,
                      ),
                    ),
                  );
                }

                final hits = snapshot.data ?? const <HadithHit>[];
                if (hits.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppValues.space_34),
                      child: DuskEmptyState(
                        icon: PhosphorIconsRegular.bookmarkSimple,
                        message: l10n.hadithNoBookmarks,
                        actionLabel: l10n.hadithBrowseCollections,
                        onAction: Get.back,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppValues.screenPadding,
                    AppValues.cardPadding,
                    AppValues.screenPadding,
                    AppValues.space_24,
                  ),
                  itemCount: hits.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppValues.cardGap),
                  itemBuilder: (context, index) => HadithCard(
                    hadith: hits[index].hadith,
                    controller: controller,
                    bookName: hits[index].bookName,
                    chapterName: hits[index].chapterName,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
