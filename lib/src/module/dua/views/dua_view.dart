import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/dua/controllers/dua_controller.dart';
import 'package:al_muttaqee/src/module/dua/models/dua_models.dart';

/// দুআ সংকলন — frame ১৬.
class DuaView extends BaseView<DuaController> {
  DuaView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  static IconData iconFor(String name) => switch (name) {
        'sunHorizon' => PhosphorIconsRegular.sunHorizon,
        'moon' => PhosphorIconsRegular.moon,
        'forkKnife' => PhosphorIconsRegular.forkKnife,
        'airplaneTilt' => PhosphorIconsRegular.airplaneTilt,
        'handsPraying' => PhosphorIconsRegular.handsPraying,
        'heartbeat' => PhosphorIconsRegular.heartbeat,
        'users' => PhosphorIconsRegular.users,
        'shield' => PhosphorIconsRegular.shield,
        _ => PhosphorIconsRegular.handHeart,
      };

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const theme = DuskHeroTheme.day;

    return Obx(
      () => Column(
        children: [
          DuskHero(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DuskHeroTitleRow(
                  title: l10n.tileDua,
                  theme: theme,
                  onBack: Get.back,
                ),
                const SizedBox(height: AppValues.groupGap),
                _chips(theme),
              ],
            ),
          ),
          Expanded(child: _content(l10n)),
        ],
      ),
    );
  }

  /// The contextual row. The active chip is chosen by the clock, not by the
  /// user — the overline underneath says so.
  Widget _chips(DuskHeroTheme theme) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppValues.heroPadding),
        itemCount: controller.contextualChips.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppValues.space_7),
        itemBuilder: (context, index) {
          final category = controller.contextualChips[index];
          final active = controller.active.value?.id == category.id;
          return DuskPill(
            label: category.label,
            background: active
                ? theme.accent
                : AppColors.onDeepPrimary.withValues(alpha: 0.14),
            foreground: active ? theme.accentInk : theme.onPrimary,
            onTap: () => controller.select(category),
          );
        },
      ),
    );
  }

  Widget _content(AppLocalizations l10n) {
    if (controller.loadError.value.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: DuskErrorPanel(
          title: l10n.hadithLoadFailedTitle,
          message: l10n.hadithLoadFailedBody,
          actionLabel: l10n.retry,
          onAction: controller.load,
        ),
      );
    }

    if (controller.isLoading.value) {
      return ListView.builder(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: AppValues.cardGap),
          child: DuskSkeleton(
            width: double.infinity,
            height: 160,
            radius: DuskRadius.card,
          ),
        ),
      );
    }

    final featured = controller.featured.value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.cardPadding,
        AppValues.screenPadding,
        AppValues.space_24,
      ),
      children: [
        if (featured != null) ...[
          DuskOverline(l10n.duaFeaturedOverline),
          _DuaCard(dua: featured, l10n: l10n, featured: true),
          const SizedBox(height: AppValues.groupGapWide),
        ],
        DuskOverline(
          controller.active.value == null
              ? l10n.duaRightNowOverline
              : '${l10n.duaRightNowOverline} · ${controller.active.value!.label}',
        ),
        for (final dua in controller.duas)
          Padding(
            padding: const EdgeInsets.only(bottom: AppValues.cardGap),
            child: _DuaCard(dua: dua, l10n: l10n),
          ),
        const SizedBox(height: AppValues.gapXSmall),
        DuskOverline(l10n.duaCategoriesOverline),
        _categoryGrid(l10n),
        const SizedBox(height: AppValues.groupGap),
        Text(
          l10n.duaAttribution,
          style: DuskText.caption.copyWith(color: AppColors.inkMuted),
        ),
      ],
    );
  }

  Widget _categoryGrid(AppLocalizations l10n) {
    final items = controller.gridCategories;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppValues.cardGapWide,
        crossAxisSpacing: AppValues.cardGapWide,
        mainAxisExtent: 86,
      ),
      itemBuilder: (context, index) {
        final category = items[index];
        final active = controller.active.value?.id == category.id;

        return DuskCard(
          radius: DuskRadius.cardTight,
          color: active ? AppColors.goldTintCard : AppColors.surface,
          border:
              active ? Border.all(color: AppColors.goldTintBorder) : null,
          shadow: active ? const [] : AppColors.shadowCard,
          padding: const EdgeInsets.all(AppValues.space_13),
          onTap: () => controller.select(category),
          child: Row(
            children: [
              DuskIconChip(
                icon: iconFor(category.icon),
                size: AppValues.tileIconChip,
                radius: DuskRadius.iconChipLarge - 1,
                background: active ? AppColors.goldTint : AppColors.sage,
                foreground:
                    active ? AppColors.goldOnIvory : AppColors.duskMid,
                iconSize: AppValues.icon_19,
              ),
              const SizedBox(width: AppValues.gapSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DuskText.bangla(
                        size: AppValues.fontSize_14,
                        weight: FontWeight.w700,
                        color:
                            active ? AppColors.goldTintInk : AppColors.ink,
                      ),
                    ),
                    Text(
                      l10n.duaCount(formatNumberWithLocale(category.count)),
                      style: DuskText.rowSubtitle
                          .copyWith(color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DuaCard extends StatelessWidget {
  const _DuaCard({
    required this.dua,
    required this.l10n,
    this.featured = false,
  });

  final Dua dua;
  final AppLocalizations l10n;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.card,
      color: featured ? AppColors.goldTintCard : AppColors.surface,
      border: featured ? Border.all(color: AppColors.goldTintBorder) : null,
      shadow: featured ? const [] : AppColors.shadowCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${dua.bookName} · ${formatNumberWithLocale(dua.number)}',
                  style: DuskText.rowSubtitleStrong.copyWith(
                    color: featured
                        ? AppColors.goldOnCanvas
                        : AppColors.inkMuted,
                  ),
                ),
              ),
              if (dua.grade.isNotEmpty)
                DuskPill(
                  label: dua.grade,
                  background: AppColors.sage,
                  foreground: AppColors.sageInk,
                ),
              const SizedBox(width: AppValues.gap_6),
              InkResponse(
                onTap: () => _copy(),
                radius: AppValues.space_20,
                child: const Icon(
                  PhosphorIconsRegular.copy,
                  size: AppValues.icon_18,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
          if (dua.arabic.isNotEmpty) ...[
            const SizedBox(height: AppValues.space_12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                dua.arabic,
                textAlign: TextAlign.right,
                style: DuskText.arabic(size: AppValues.fontSize_24, height: 2.0)
                    .copyWith(color: AppColors.duskDeep),
              ),
            ),
          ],
          if (dua.bengali.isNotEmpty) ...[
            const SizedBox(height: AppValues.space_12),
            Text(
              dua.bengali,
              style: DuskText.bangla(
                size: AppValues.fontSize_13_5,
                weight: FontWeight.w400,
                height: 1.75,
                color: AppColors.inkBody,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _copy() async {
    await Clipboard.setData(
      ClipboardData(
        text: '${dua.arabic}\n\n${dua.bengali}\n\n'
            '${dua.bookName} · ${formatNumberWithLocale(dua.number)}',
      ),
    );
  }
}
