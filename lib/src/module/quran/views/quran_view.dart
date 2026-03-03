import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:get/get.dart';

import 'surah_detail_view.dart';
import 'para_surah_list_view.dart';

class QuranView extends BaseView<QuranController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    final l10n = appLocalization;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.baseBackground,
      padding: const EdgeInsets.all(AppValues.gapLarge),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quran,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.brand800,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppValues.space_8),
            Text(
              l10n.quranLastRead,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey700,
                  ),
            ),
            const SizedBox(height: AppValues.gap),
            _LastReadCard(controller: controller),
            const SizedBox(height: AppValues.gapLarge),
            _QuranTabBar(l10n: l10n),
            const SizedBox(height: AppValues.space_8),
            const Expanded(
              child: TabBarView(
                children: [
                  _SurahList(),
                  _ParaList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastReadCard extends StatelessWidget {
  const _LastReadCard({required this.controller});

  final QuranController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      final surah = controller.lastReadSurah;
      final ayah = controller.lastReadAyah;

      if (surah == null || ayah <= 0) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppValues.gap),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(AppValues.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.baseBlack.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quranNoLastReadYet,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey800,
                              ),
                    ),
                    const SizedBox(height: AppValues.space_4),
                    Text(
                      l10n.quranStartReading,
                      style:
                          Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.brand700,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      final locale = controller.currentLocale;
      final localizedName = surah.localizedName(locale);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppValues.gap),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.brand700,
              AppColors.brand500,
            ],
          ),
          borderRadius: BorderRadius.circular(AppValues.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand700.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    surah.arabicName,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.baseWhite,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppValues.space_4),
                  Text(
                    localizedName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.brand100,
                        ),
                  ),
                  const SizedBox(height: AppValues.space_4),
                  Text(
                    l10n.quranAyahNumberLabel(ayah),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.baseWhite,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppValues.gap),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.baseWhite,
                foregroundColor: AppColors.brand800,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.space_16,
                  vertical: AppValues.space_8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.radiusSmall),
                ),
              ),
              onPressed: () {
                Get.to(
                  () => SurahDetailView(
                    surahNumber: surah.number,
                    initialAyahNumber: ayah,
                  ),
                );
              },
              child: Text(
                l10n.quranContinueReading,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.brand800,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _QuranTabBar extends StatelessWidget {
  const _QuranTabBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(AppValues.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.baseBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: AppColors.brand700,
          borderRadius: BorderRadius.circular(AppValues.radiusLarge),
        ),
        labelColor: AppColors.baseWhite,
        unselectedLabelColor: AppColors.grey700,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelStyle:
            Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
        tabs: [
          Tab(text: l10n.quranSurahTab),
          Tab(text: l10n.quranParaTab),
        ],
      ),
    );
  }
}

class _SurahList extends GetView<QuranController> {
  const _SurahList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      final surahs = controller.surahs;

      return ListView.separated(
        itemCount: surahs.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: AppColors.grey200,
        ),
        itemBuilder: (context, index) {
          final SurahMeta surah = surahs[index];
          final locale = controller.currentLocale;
          final localizedName = surah.localizedName(locale);

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppValues.gap,
              vertical: AppValues.space_4,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.brand100,
              foregroundColor: AppColors.brand800,
              child: Text(
                surah.number.toString(),
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
                '${surah.ayahCount} ${l10n.quranAyahNumberLabel(0).split(' ').first.toLowerCase()} • ${surah.revelationPlace}',
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
      );
    });
  }
}

class _ParaList extends GetView<QuranController> {
  const _ParaList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      final paras = controller.paras;
      final surahs = controller.surahs;

      return ListView.separated(
        itemCount: paras.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: AppColors.grey200,
        ),
        itemBuilder: (context, index) {
          final para = paras[index];
          final paraSurahs = surahs
              .where((s) => para.surahNumbers.contains(s.number))
              .toList();
          final subtitle = paraSurahs
              .map((s) => s.localizedName(controller.currentLocale))
              .join(', ');

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppValues.gap,
              vertical: AppValues.space_4,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.brand100,
              foregroundColor: AppColors.brand800,
              child: Text(
                para.number.toString(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            title: Text(
              '${l10n.quranParaLabel} ${para.number}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.brand800,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: subtitle.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: AppValues.space_4),
                    child: Text(
                      subtitle,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.grey600,
                              ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            onTap: () {
              Get.to(
                () => ParaSurahListView(
                  paraNumber: para.number,
                  surahNumbers: para.surahNumbers,
                ),
              );
            },
          );
        },
      );
    });
  }
}