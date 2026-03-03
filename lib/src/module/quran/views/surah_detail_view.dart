import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';

class SurahDetailView extends BaseView<QuranController> {
  SurahDetailView({
    required this.surahNumber,
    this.initialAyahNumber = 1,
  });

  final int surahNumber;
  final int initialAyahNumber;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final SurahMeta? surah = controller.surahs
        .firstWhereOrNull((element) => element.number == surahNumber);

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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey700,
                  ),
            ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final SurahMeta? surah = controller.surahs
        .firstWhereOrNull((element) => element.number == surahNumber);

    if (surah == null) {
      return Center(
        child: Text(
          'Surah not found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey800,
              ),
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
      child: ListView.separated(
        padding: const EdgeInsets.all(AppValues.gap),
        itemCount: verseCount,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: AppColors.grey200,
        ),
        itemBuilder: (context, index) {
          final arabic = arabicVerses[index];
          final translation = index < translatedVerses.length
              ? translatedVerses[index]
              : null;

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.gap,
              vertical: AppValues.space_8,
            ),
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: BorderRadius.circular(AppValues.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: AppColors.baseBlack.withOpacity(0.02),
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
                        arabic.verseNumber.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(width: AppValues.space_8),
                    Expanded(
                      child: Text(
                        arabic.text,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.grey900,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ),
                if (translation != null) ...[
                  const SizedBox(height: AppValues.space_8),
                  Text(
                    translation.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey800,
                        ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
