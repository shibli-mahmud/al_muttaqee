import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/module/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeView extends BaseView<HomeController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppColors.baseBackground,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.prayerTimes?.refreshTimes();
            controller.reloadLocaleSensitive();
          },
          child: ListView(
            padding: const EdgeInsets.all(AppValues.gap),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.home,
                      style: kFigtree700W18S.copyWith(color: AppColors.brand700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.brand700),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.gapXSmall),
              _buildNextSalatCard(l10n),
              const SizedBox(height: AppValues.gap),
              _buildDateRow(l10n),
              const SizedBox(height: AppValues.gap),
              _buildDailyCards(l10n),
              const SizedBox(height: AppValues.gap),
              Text(l10n.quickAccess, style: kFigtree600W16S),
              const SizedBox(height: AppValues.gapSmall),
              _buildQuickAccess(l10n),
              const SizedBox(height: AppValues.gapLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextSalatCard(AppLocalizations l10n) {
    return Obx(() {
      final prayer = controller.prayerTimes;
      final times = prayer?.dayTimes.value;
      if (prayer == null || times == null) {
        return _HomeCard(
          child: Text(l10n.preparingPrayerTimes, style: kFigtree400W14S),
        );
      }

      final current = times.current;
      final timeFmt = DateFormat.jm();
      return InkWell(
        onTap: controller.openPrayerTimes,
        borderRadius: BorderRadius.circular(AppValues.radius),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppValues.gap),
          decoration: BoxDecoration(
            color: AppColors.brand500,
            borderRadius: BorderRadius.circular(AppValues.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (current != null) ...[
                Text(
                  l10n.currentPrayer,
                  style: kFigtree400W12S.copyWith(color: AppColors.brand200),
                ),
                Text(
                  controller.prayerLabel(current),
                  style: kFigtree600W16S.copyWith(color: AppColors.baseWhite),
                ),
                const SizedBox(height: AppValues.gapXSmall),
              ],
              Text(
                l10n.nextPrayer,
                style: kFigtree400W12S.copyWith(color: AppColors.brand200),
              ),
              Text(
                controller.prayerLabel(times.next),
                style: kFigtree700W22S.copyWith(color: AppColors.baseWhite),
              ),
              const SizedBox(height: AppValues.gap_4),
              Text(
                '${l10n.timeRemaining}: ${prayer.formatRemaining(prayer.remaining.value)}',
                style: kFigtree600W16S.copyWith(color: AppColors.baseWhite),
              ),
              Text(
                timeFmt.format(times.nextTime),
                style: kFigtree400W14S.copyWith(color: AppColors.brand100),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDateRow(AppLocalizations l10n) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _HomeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gregorianDate,
                    style: kFigtree400W12S.copyWith(color: AppColors.grey600),
                  ),
                  Text(controller.gregorianLabel.value, style: kFigtree600W14S),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppValues.gapSmall),
          Expanded(
            child: _HomeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hijriDate,
                    style: kFigtree400W12S.copyWith(color: AppColors.grey600),
                  ),
                  Text(controller.hijriLabel.value, style: kFigtree600W14S),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCards(AppLocalizations l10n) {
    return Obx(() {
      if (controller.dailyCards.isEmpty) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        height: 160,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.92),
          itemCount: controller.dailyCards.length,
          itemBuilder: (context, index) {
            final card = controller.dailyCards[index];
            final title = card.titleKey == 'hadith'
                ? l10n.hadithOfTheDay
                : l10n.duaOfTheDay;
            return Padding(
              padding: const EdgeInsets.only(right: AppValues.gapSmall),
              child: _HomeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: kFigtree600W14S.copyWith(color: AppColors.brand600),
                    ),
                    const SizedBox(height: AppValues.gapXSmall),
                    Expanded(
                      child: Text(
                        card.text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: kFigtree400W14S,
                      ),
                    ),
                    Text(
                      card.source,
                      style: kFigtree400W12S.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildQuickAccess(AppLocalizations l10n) {
    final items = [
      _QuickItem(
        label: l10n.continueReading,
        icon: PhosphorIconsRegular.bookOpenText,
        onTap: controller.openQuranContinue,
      ),
      _QuickItem(
        label: l10n.qibla,
        icon: PhosphorIconsRegular.compass,
        onTap: controller.openQibla,
      ),
      _QuickItem(
        label: l10n.tasbih,
        icon: PhosphorIconsRegular.handsPraying,
        onTap: controller.openTasbih,
      ),
      _QuickItem(
        label: l10n.masjidFinder,
        icon: PhosphorIconsRegular.mapPin,
        onTap: controller.openMasjidFinder,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppValues.gapSmall,
        crossAxisSpacing: AppValues.gapSmall,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(AppValues.radiusSmall),
          child: _HomeCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: AppColors.brand500, size: AppValues.icon),
                const SizedBox(height: AppValues.gap_4),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: kFigtree500W14S,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.gapSmall),
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(AppValues.radiusSmall),
      ),
      child: child,
    );
  }
}

class _QuickItem {
  const _QuickItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}
