import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/module/hadith/controllers/hadith_controller.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// BaseView does not expose a key constructor; follows existing module views.
// ignore: use_key_in_widget_constructors
class HadithView extends BaseView<HadithController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppColors.baseBackground,
      padding: const EdgeInsets.all(AppValues.gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hadith,
            style: kFigtree700W22S.copyWith(color: AppColors.brand700),
          ),
          const SizedBox(height: AppValues.gapXSmall),
          Text(
            l10n.hadithSourcesAttribution,
            style: kFigtree400W12S.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: AppValues.gap),
          Expanded(
            child: ListView.separated(
              itemCount: HadithBook.values.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppValues.gapSmall),
              itemBuilder: (context, index) {
                final book = HadithBook.values[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(AppValues.radius),
                  onTap: () async {
                    await controller.openBook(book);
                    Get.to(() => HadithChapterListView(book: book));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppValues.gap),
                    decoration: BoxDecoration(
                      color: AppColors.baseWhite,
                      borderRadius: BorderRadius.circular(AppValues.radius),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.brand100,
                          foregroundColor: AppColors.brand700,
                          child: Icon(PhosphorIconsRegular.bookOpenText),
                        ),
                        const SizedBox(width: AppValues.gap),
                        Expanded(
                          child: Text(
                            _bookName(l10n, book),
                            style: kFigtree600W16S,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.brand600,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HadithChapterListView extends GetView<HadithController> {
  const HadithChapterListView({required this.book, super.key});
  final HadithBook book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      appBar: AppBar(
        title: Text(_bookName(l10n, book), style: kFigtree600W16S),
        backgroundColor: AppColors.baseWhite,
        foregroundColor: AppColors.brand700,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.chapters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppValues.gap),
          itemCount: controller.chapters.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppValues.gapSmall),
          itemBuilder: (context, index) {
            final chapter = controller.chapters[index];
            final title = chapter.title.isEmpty
                ? l10n.hadithAllChapters
                : chapter.title;
            return ListTile(
              tileColor: AppColors.baseWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppValues.radiusSmall),
              ),
              leading: CircleAvatar(
                backgroundColor: AppColors.brand100,
                foregroundColor: AppColors.brand700,
                child: Text('${chapter.number}', style: kFigtree600W14S),
              ),
              title: Text(
                '${l10n.chapter} ${chapter.number}',
                style: kFigtree600W16S,
              ),
              subtitle: title == l10n.hadithAllChapters
                  ? null
                  : Text(title, style: kFigtree400W14S),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.brand600,
              ),
              onTap: () async {
                await controller.openChapter(chapter);
                Get.to(() => HadithDetailView(book: book, chapter: chapter));
              },
            );
          },
        );
      }),
    );
  }
}

class HadithDetailView extends GetView<HadithController> {
  const HadithDetailView({
    required this.book,
    required this.chapter,
    super.key,
  });
  final HadithBook book;
  final HadithChapter chapter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      appBar: AppBar(
        title: Text(
          '${l10n.chapter} ${chapter.number}',
          style: kFigtree600W16S,
        ),
        backgroundColor: AppColors.baseWhite,
        foregroundColor: AppColors.brand700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppValues.gap),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: l10n.search,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.baseWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.radiusSmall),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final hadiths = controller.filteredHadiths;
              if (hadiths.isEmpty) {
                return Center(
                  child: Text(l10n.noResults, style: kFigtree400W14S),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppValues.gap,
                  0,
                  AppValues.gap,
                  AppValues.gap,
                ),
                itemCount: hadiths.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppValues.gapSmall),
                itemBuilder: (context, index) =>
                    _HadithCard(hadith: hadiths[index], l10n: l10n),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(AppValues.gap),
            child: Text(
              '${l10n.sources}: ${l10n.hadithSourcesAttribution}',
              style: kFigtree400W12S.copyWith(color: AppColors.grey600),
            ),
          ),
        ],
      ),
    );
  }
}

class _HadithCard extends GetView<HadithController> {
  const _HadithCard({required this.hadith, required this.l10n});
  final Hadith hadith;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppValues.gap),
    decoration: BoxDecoration(
      color: AppColors.baseWhite,
      borderRadius: BorderRadius.circular(AppValues.radiusSmall),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '${l10n.hadith} ${hadith.number}',
              style: kFigtree600W14S.copyWith(color: AppColors.brand700),
            ),
            const Spacer(),
            Obx(
              () => IconButton(
                tooltip: controller.isBookmarked(hadith)
                    ? l10n.bookmarked
                    : l10n.bookmark,
                onPressed: () => controller.toggleBookmark(hadith),
                icon: Icon(
                  controller.isBookmarked(hadith)
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: AppColors.brand600,
                ),
              ),
            ),
          ],
        ),
        if (hadith.arabic.isNotEmpty)
          Text(
            hadith.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: kFigtree600W18S.copyWith(color: AppColors.grey900),
          ),
        if (controller.localizedText(hadith).isNotEmpty) ...[
          const SizedBox(height: AppValues.gapSmall),
          Text(
            controller.localizedText(hadith),
            style: kFigtree400W14S.copyWith(color: AppColors.grey800),
          ),
        ],
        if (hadith.narrator.isNotEmpty) ...[
          const SizedBox(height: AppValues.gapSmall),
          Text(
            '${l10n.narrator}: ${hadith.narrator}',
            style: kFigtree400W12S.copyWith(color: AppColors.grey600),
          ),
        ],
      ],
    ),
  );
}

String _bookName(AppLocalizations l10n, HadithBook book) => switch (book) {
  HadithBook.bukhari => l10n.hadithBukhari,
  HadithBook.muslim => l10n.hadithMuslim,
  HadithBook.abuDaud => l10n.hadithAbuDaud,
  HadithBook.ibnMajah => l10n.hadithIbnMajah,
  HadithBook.tirmidi => l10n.hadithTirmidhi,
};
