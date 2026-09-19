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

/// Full-text search across all 34,051 hadiths.
class HadithSearchView extends BaseView<HadithController> {
  HadithSearchView({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DuskHeroTitleRow(
                title: l10n.hadithSearchTitle,
                theme: theme,
                onBack: () {
                  controller.clearSearch();
                  Get.back<void>();
                },
              ),
              const SizedBox(height: AppValues.space_12),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.heroPadding,
                ),
                child: _field(l10n, theme),
              ),
            ],
          ),
        ),
        Expanded(child: Obx(() => _results(l10n))),
      ],
    );
  }

  Widget _field(AppLocalizations l10n, DuskHeroTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onDeepPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DuskRadius.inner),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppValues.space_14),
      child: Row(
        children: [
          Icon(
            PhosphorIconsRegular.magnifyingGlass,
            size: AppValues.icon_19,
            color: theme.onMuted,
          ),
          const SizedBox(width: AppValues.gapSmall),
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: controller.onSearchChanged,
              textInputAction: TextInputAction.search,
              cursorColor: theme.accent,
              style: DuskText.bangla(
                size: AppValues.fontSize_15,
                weight: FontWeight.w600,
                color: theme.onPrimary,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppValues.space_14,
                ),
                hintText: l10n.hadithSearchHint,
                hintStyle: DuskText.bangla(
                  size: AppValues.fontSize_15,
                  weight: FontWeight.w400,
                  color: theme.onMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _results(AppLocalizations l10n) {
    if (controller.isSearching.value) {
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

    final query = controller.searchQuery.value.trim();

    if (query.length < 2) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.space_34),
          child: DuskEmptyState(
            icon: PhosphorIconsRegular.magnifyingGlass,
            message: l10n.hadithSearchPrompt,
          ),
        ),
      );
    }

    if (controller.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.space_34),
          child: DuskEmptyState(
            icon: PhosphorIconsRegular.magnifyingGlass,
            message: l10n.noResults,
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
      itemCount: controller.searchResults.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.cardGap),
      itemBuilder: (context, index) {
        if (index == 0) {
          return DuskOverline(
            l10n.hadithSearchCount(
              formatNumberWithLocale(controller.searchResults.length),
            ),
            padding: EdgeInsets.zero,
          );
        }
        final hit = controller.searchResults[index - 1];
        return HadithCard(
          hadith: hit.hadith,
          controller: controller,
          bookName: hit.bookName,
          chapterName: hit.chapterName,
          highlight: query,
        );
      },
    );
  }
}
