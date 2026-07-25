import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurahDetailView extends BaseView<QuranController> {
  SurahDetailView({
    super.key,
    required this.surahNumber,
    this.initialAyahNumber = 1,
  });

  final int surahNumber;
  final int initialAyahNumber;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final SurahMeta? surah = controller.surahs.firstWhereOrNull(
      (element) => element.number == surahNumber,
    );

    return AppBar(
      backgroundColor: AppColors.baseWhite,
      foregroundColor: AppColors.brand800,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (surah != null)
            Text(
              surah.arabicName,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (surah != null)
            Text(
              surah.localizedName(controller.currentLocale),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.grey700),
            ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final SurahMeta? surah = controller.surahs.firstWhereOrNull(
      (element) => element.number == surahNumber,
    );

    if (surah == null) {
      return Center(
        child: Text(
          l10n.quran,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.grey800),
        ),
      );
    }

    final arabicVerses = controller.getSurahVersesArabic(surahNumber);
    final translatedVerses = controller.getSurahVersesTranslated(surahNumber);
    final verseCount = arabicVerses.length;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.baseBackground,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: controller.surahScrollController,
              padding: const EdgeInsets.all(AppValues.gap),
              itemCount: verseCount,
              separatorBuilder: (_, index) =>
                  const Divider(height: 1, color: AppColors.grey200),
              itemBuilder: (context, index) {
                final arabic = arabicVerses[index];
                final translation = index < translatedVerses.length
                    ? translatedVerses[index]
                    : null;
                final locale = controller.currentLocale;

                return Obx(() {
                  final isPlayingAyah =
                      controller.playingSurahNumber == surahNumber &&
                      controller.playingAyahNumber == arabic.verseNumber;
                  return InkWell(
                    borderRadius: BorderRadius.circular(AppValues.radiusSmall),
                    onTap: () {
                      controller.setLastRead(surah, arabic.verseNumber);
                      controller.togglePlayback(
                        surahNumber,
                        arabic.verseNumber,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.gap,
                        vertical: AppValues.space_8,
                      ),
                      decoration: BoxDecoration(
                        color: isPlayingAyah
                            ? AppColors.brand100
                            : AppColors.baseWhite,
                        borderRadius: BorderRadius.circular(
                          AppValues.radiusSmall,
                        ),
                        border: isPlayingAyah
                            ? Border.all(color: AppColors.brand500)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.baseBlack.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.brand100,
                                foregroundColor: AppColors.brand800,
                                child: Text(
                                  formatNumberWithLocale(
                                    arabic.verseNumber,
                                    locale,
                                  ),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: AppValues.space_8),
                              Expanded(
                                child: Text(
                                  arabic.text,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppColors.grey900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              if (isPlayingAyah)
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: AppValues.space_4,
                                  ),
                                  child: Icon(
                                    Icons.volume_up_rounded,
                                    color: AppColors.brand700,
                                  ),
                                ),
                            ],
                          ),
                          if (translation != null) ...[
                            const SizedBox(height: AppValues.space_8),
                            Text(
                              translation.text,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.grey800),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          _RecitationPlayerBar(
            controller: controller,
            surah: surah,
            initialAyahNumber: initialAyahNumber,
            l10n: l10n,
          ),
        ],
      ),
    );
  }
}

class _RecitationPlayerBar extends StatelessWidget {
  const _RecitationPlayerBar({
    required this.controller,
    required this.surah,
    required this.initialAyahNumber,
    required this.l10n,
  });

  final QuranController controller;
  final SurahMeta surah;
  final int initialAyahNumber;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeAyah = controller.playingSurahNumber == surah.number
          ? controller.playingAyahNumber
          : null;
      final isCurrentSurahPlaying = controller.isPlaying && activeAyah != null;
      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppValues.gap,
            AppValues.space_8,
            AppValues.gap,
            AppValues.space_8,
          ),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            border: const Border(top: BorderSide(color: AppColors.grey200)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showReciterPicker(context),
                      icon: const Icon(Icons.record_voice_over_outlined),
                      label: Text(
                        '${l10n.reciter}: ${controller.selectedReciter.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.offlineDownload,
                    onPressed:
                        controller.isSurahDownloaded(surah.number) ||
                            controller.isDownloadingSurah(surah.number)
                        ? null
                        : () => controller.downloadSurah(surah.number),
                    icon: controller.isDownloadingSurah(surah.number)
                        ? const SizedBox(
                            width: AppValues.iconSmall,
                            height: AppValues.iconSmall,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            controller.isSurahDownloaded(surah.number)
                                ? Icons.download_done_rounded
                                : Icons.download_for_offline_outlined,
                          ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    tooltip: l10n.repeatAyah,
                    onPressed: controller.toggleRepeatAyah,
                    color: controller.repeatAyah
                        ? AppColors.brand700
                        : AppColors.grey700,
                    icon: const Icon(Icons.repeat_one_rounded),
                  ),
                  IconButton.filled(
                    tooltip: isCurrentSurahPlaying ? l10n.pause : l10n.play,
                    onPressed: () => controller.togglePlayback(
                      surah.number,
                      activeAyah ??
                          initialAyahNumber.clamp(1, surah.ayahCount).toInt(),
                    ),
                    icon: Icon(
                      isCurrentSurahPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.repeatSurah,
                    onPressed: controller.toggleRepeatSurah,
                    color: controller.repeatSurah
                        ? AppColors.brand700
                        : AppColors.grey700,
                    icon: const Icon(Icons.repeat_rounded),
                  ),
                  PopupMenuButton<double>(
                    tooltip: l10n.playbackSpeed,
                    initialValue: controller.playbackSpeed,
                    onSelected: controller.setPlaybackSpeed,
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 0.75, child: Text('0.75x')),
                      PopupMenuItem(value: 1.0, child: Text('1x')),
                      PopupMenuItem(value: 1.25, child: Text('1.25x')),
                      PopupMenuItem(value: 1.5, child: Text('1.5x')),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(AppValues.space_8),
                      child: Text(
                        '${controller.playbackSpeed}x',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.brand700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showReciterPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: QuranController.reciters
              .map(
                (reciter) => ListTile(
                  title: Text(reciter.name),
                  trailing: reciter.id == controller.selectedReciter.id
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.brand700,
                        )
                      : null,
                  onTap: () async {
                    await controller.selectReciter(reciter);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
