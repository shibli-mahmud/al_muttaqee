import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:get/get.dart';

import 'surah_detail_view.dart';

class ParaSurahListView extends BaseView<QuranController> {
  ParaSurahListView({
    required this.paraNumber,
    required this.surahNumbers,
  });

  final int paraNumber;
  final List<int> surahNumbers;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final l10n = appLocalization;
    final locale = controller.currentLocale;
    final paraNumberText = formatNumberWithLocale(paraNumber, locale);
    return AppBar(
      backgroundColor: AppColors.baseWhite,
      foregroundColor: AppColors.brand800,
      elevation: 0,
      title: Text(
        '${l10n.quranParaLabel} $paraNumberText',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.brand800,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final l10n = appLocalization;
    final List<SurahMeta> allSurahs = controller.surahs;
    final List<SurahMeta> paraSurahs = allSurahs
        .where((s) => surahNumbers.contains(s.number))
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.baseBackground,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppValues.gap),
        itemCount: paraSurahs.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: AppColors.grey200,
        ),
        itemBuilder: (context, index) {
          final surah = paraSurahs[index];
          final locale = controller.currentLocale;
          final localizedName = surah.localizedName(locale);
           final numberText = formatNumberWithLocale(surah.number, locale);
          final ayahCountText =
              formatNumberWithLocale(surah.ayahCount, locale);
          final placeText = surah.revelationPlace == 'Meccan'
              ? l10n.quranRevelationMeccan
              : surah.revelationPlace == 'Medinan'
                  ? l10n.quranRevelationMedinan
                  : surah.revelationPlace;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppValues.gap,
              vertical: AppValues.space_4,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.brand100,
              foregroundColor: AppColors.brand800,
              child: Text(
                numberText,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    localizedName,
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.brand800,
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                ),
                const SizedBox(width: AppValues.space_8),
                Text(
                  surah.arabicName,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.grey900,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: AppValues.space_4),
              child: Text(
                '$ayahCountText ${l10n.quranAyahNumberLabel(0).split(' ').first.toLowerCase()} • $placeText',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey600,
                    ),
              ),
            ),
            onTap: () {
              controller.setLastRead(surah, 1);
              Get.to(
                () => SurahDetailView(
                  surahNumber: surah.number,
                  initialAyahNumber: 1,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

