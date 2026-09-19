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
import 'package:al_muttaqee/src/module/zakat/controllers/zakat_controller.dart';

/// যাকাত — frame ১৭.
///
/// The payable figure is pinned to the bottom rather than placed at the end of
/// the list. It is the answer the user came for, and it should stay on screen
/// while they are still typing the inputs that change it.
class ZakatView extends BaseView<ZakatController> {
  ZakatView({super.key});

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

    return Obx(
      () => Column(
        children: [
          _hero(context, l10n, theme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.cardPadding,
                AppValues.screenPadding,
                AppValues.space_18,
              ),
              children: [
                if (controller.ratesUnavailable) ...[
                  DuskErrorPanel(
                    title: l10n.zakatRatesUnavailableTitle,
                    message: l10n.zakatRatesUnavailableBody,
                    actionLabel: l10n.retry,
                    onAction: controller.refreshRates,
                  ),
                  const SizedBox(height: AppValues.groupGap),
                ],
                DuskOverline(l10n.zakatAssetsOverline),
                GroupedCard(
                  children: [
                    for (final line in controller.assets)
                      _AmountRow(
                        line: line,
                        l10n: l10n,
                        onTap: () => _editLine(context, l10n, line),
                      ),
                    _addRow(context, l10n),
                  ],
                ),
                const SizedBox(height: AppValues.groupGapWide),
                DuskOverline(l10n.zakatDeductionsOverline),
                GroupedCard(
                  children: [
                    for (final line in controller.deductions)
                      _AmountRow(
                        line: line,
                        l10n: l10n,
                        onTap: () => _editLine(context, l10n, line),
                      ),
                  ],
                ),
                const SizedBox(height: AppValues.groupGapWide),
                _nisabBasis(l10n),
              ],
            ),
          ),
          _totalPanel(l10n),
        ],
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _hero(
    BuildContext context,
    AppLocalizations l10n,
    DuskHeroTheme theme,
  ) {
    return DuskHero(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DuskHeroTitleRow(
            title: l10n.zakat,
            theme: theme,
            onBack: Get.back,
            actions: [
              DuskHeroIconButton(
                icon: PhosphorIconsRegular.question,
                theme: theme,
                semanticLabel: l10n.zakatHelp,
                onTap: () => _help(context, l10n),
              ),
            ],
          ),
          const SizedBox(height: AppValues.space_18),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.screenPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HeroStat(
                    label: controller.useGoldNisab.value
                        ? l10n.zakatNisabGold
                        : l10n.zakatNisabSilver,
                    value: formatTaka(controller.nisab),
                  ),
                ),
                const SizedBox(width: AppValues.cardGapWide),
                Expanded(
                  child: _HeroStat(
                    label: controller.useGoldNisab.value
                        ? l10n.zakatGoldPerBhori
                        : l10n.zakatSilverPerBhori,
                    value: formatTaka(
                      controller.useGoldNisab.value
                          ? controller.goldPerBhori
                          : controller.silverPerBhori,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addRow(BuildContext context, AppLocalizations l10n) {
    return GroupedRow(
      title: l10n.zakatAddCategory,
      titleStyle: DuskText.bangla(
        size: AppValues.fontSize_14,
        weight: FontWeight.w700,
        color: AppColors.duskMid,
      ),
      leading: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: AppValues.gap_3),
        decoration: const BoxDecoration(
          color: AppColors.sage,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          PhosphorIconsBold.plus,
          size: AppValues.iconSmall,
          color: AppColors.duskMid,
        ),
      ),
      onTap: () => _addCustom(context, l10n),
    );
  }

  Widget _nisabBasis(AppLocalizations l10n) {
    return GroupedCard(
      children: [
        GroupedRow(
          title: l10n.zakatUseGoldNisab,
          titleStyle: DuskText.rowLabel.copyWith(color: AppColors.ink),
          subtitle: l10n.zakatNisabExplainer,
          trailing: DuskSwitch(
            value: controller.useGoldNisab.value,
            onChanged: controller.setNisabBasis,
          ),
        ),
      ],
    );
  }

  // ── Total ─────────────────────────────────────────────────────────────────

  Widget _totalPanel(AppLocalizations l10n) {
    final below = !controller.meetsNisab;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        0,
        AppValues.screenPadding,
        AppValues.cardPadding,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.cardPaddingWide,
        horizontal: AppValues.space_20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.duskDeep, AppColors.duskMid],
        ),
        borderRadius: BorderRadius.circular(AppValues.space_28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.zakatTotalWealth,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_12_5,
                    weight: FontWeight.w600,
                    color: AppColors.onDeepMuted,
                  ),
                ),
              ),
              Text(
                formatTaka(controller.zakatableWealth),
                style: DuskText.bangla(
                  size: AppValues.fontSize_12_5,
                  weight: FontWeight.w600,
                  color: AppColors.onDeepMuted,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppValues.space_12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.onDeepMuted.withValues(alpha: 0.3),
            ),
          ),
          if (below)
            // Below nisab there is no figure to show, so the panel says the
            // ruling instead of printing a zero that looks like a bug.
            Row(
              children: [
                const Icon(
                  PhosphorIconsRegular.info,
                  size: AppValues.icon_19,
                  color: AppColors.goldBright,
                ),
                const SizedBox(width: AppValues.gapSmall),
                Expanded(
                  child: Text(
                    l10n.zakatBelowNisab,
                    style: DuskText.bangla(
                      size: AppValues.fontSize_14,
                      weight: FontWeight.w600,
                      height: 1.5,
                      color: AppColors.onDeepPrimary,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.zakatPayableOverline,
                        style: DuskText.overline
                            .copyWith(color: AppColors.gold),
                      ),
                      Text(
                        formatTaka(controller.payable),
                        style: DuskText.bangla(
                          size: AppValues.fontSize_34,
                          weight: FontWeight.w700,
                          color: AppColors.onDeepPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    PhosphorIconsBold.arrowRight,
                    size: AppValues.icon_20,
                    color: AppColors.goldInk,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ── Editing ───────────────────────────────────────────────────────────────

  Future<void> _editLine(
    BuildContext context,
    AppLocalizations l10n,
    ZakatLine line,
  ) async {
    final isMetal = line.id == 'gold' || line.id == 'silver';
    final gold = line.id == 'gold';

    final initial = isMetal
        ? (gold ? controller.goldBhori.value : controller.silverBhori.value)
        : line.amount;
    final field = TextEditingController(
      text: initial == 0 ? '' : _plain(initial),
    );

    await Get.bottomSheet<void>(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.ivory,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(DuskRadius.sheet),
            ),
            boxShadow: AppColors.shadowSheet,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppValues.screenPadding,
            AppValues.space_18,
            AppValues.screenPadding,
            AppValues.space_24,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(line.label, style: DuskText.cardHeading),
                Text(
                  isMetal ? l10n.zakatEnterBhori : l10n.zakatEnterTaka,
                  style: DuskText.bodySmall
                      .copyWith(color: AppColors.inkSecondary),
                ),
                const SizedBox(height: AppValues.space_12),
                TextField(
                  controller: field,
                  autofocus: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  // Western digits on the keypad: Bengali numerals are for
                  // reading, and no Android keyboard offers them for input.
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: DuskText.latin(
                    size: AppValues.fontSize_24,
                    weight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    prefixText: isMetal ? null : '৳ ',
                    suffixText: isMetal ? l10n.zakatBhoriUnit : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DuskRadius.inner),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (isMetal) ...[
                  const SizedBox(height: AppValues.gapSmall),
                  Text(
                    l10n.zakatRatePerBhori(
                      formatTaka(
                        gold
                            ? controller.goldPerBhori
                            : controller.silverPerBhori,
                      ),
                    ),
                    style: DuskText.caption
                        .copyWith(color: AppColors.inkMuted),
                  ),
                ],
                const SizedBox(height: AppValues.space_18),
                DuskPrimaryButton(
                  label: l10n.zakatSaveAmount,
                  icon: PhosphorIconsRegular.check,
                  onPressed: () {
                    final value = double.tryParse(field.text.trim()) ?? 0;
                    if (isMetal) {
                      controller.setMetal(gold: gold, bhori: value);
                    } else {
                      controller.setAmount(line.id, value);
                    }
                    Get.back<void>();
                  },
                ),
                if (line.custom) ...[
                  const SizedBox(height: AppValues.gapSmall),
                  DuskSecondaryButton(
                    label: l10n.zakatRemoveCategory,
                    icon: PhosphorIconsRegular.x,
                    onPressed: () {
                      controller.removeLine(line.id);
                      Get.back<void>();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }

  String _plain(double value) =>
      value == value.roundToDouble() ? value.round().toString() : '$value';

  Future<void> _addCustom(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final name = TextEditingController();
    final amount = TextEditingController();

    await Get.bottomSheet<void>(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.ivory,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(DuskRadius.sheet),
            ),
            boxShadow: AppColors.shadowSheet,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppValues.screenPadding,
            AppValues.space_18,
            AppValues.screenPadding,
            AppValues.space_24,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.zakatAddCategory, style: DuskText.cardHeading),
                const SizedBox(height: AppValues.space_12),
                TextField(
                  controller: name,
                  autofocus: true,
                  style: DuskText.rowTitle,
                  decoration: InputDecoration(
                    hintText: l10n.zakatCategoryNameHint,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DuskRadius.inner),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.gapSmall),
                TextField(
                  controller: amount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: DuskText.rowTitle,
                  decoration: InputDecoration(
                    prefixText: '৳ ',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DuskRadius.inner),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.space_18),
                DuskPrimaryButton(
                  label: l10n.zakatSaveAmount,
                  icon: PhosphorIconsRegular.check,
                  onPressed: () {
                    final label = name.text.trim();
                    if (label.isEmpty) return;
                    controller.addCustomLine(
                      label,
                      double.tryParse(amount.text.trim()) ?? 0,
                    );
                    Get.back<void>();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }

  Future<void> _help(BuildContext context, AppLocalizations l10n) async {
    await Get.bottomSheet<void>(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.ivory,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DuskRadius.sheet),
          ),
          boxShadow: AppColors.shadowSheet,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppValues.screenPadding,
          AppValues.space_18,
          AppValues.screenPadding,
          AppValues.space_24,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.zakatHelp, style: DuskText.cardHeading),
              const SizedBox(height: AppValues.gapSmall),
              Text(
                l10n.zakatHelpBody,
                style: DuskText.body.copyWith(color: AppColors.inkSecondary),
              ),
              const SizedBox(height: AppValues.space_12),
              Obx(
                () => Text(
                  l10n.ratesLastUpdated(
                    controller.rates.value == null
                        ? '—'
                        : formatDayMonth(controller.rates.value!.updatedAt),
                  ),
                  style: DuskText.caption
                      .copyWith(color: AppColors.inkMuted),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.space_13,
        horizontal: AppValues.cardPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.onDeepPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(DuskRadius.cardSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: DuskText.caption.copyWith(color: AppColors.onDeepMuted),
          ),
          const SizedBox(height: AppValues.gap_2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DuskText.bangla(
              size: AppValues.fontSize_15_5,
              weight: FontWeight.w700,
              color: AppColors.onDeepPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.line,
    required this.l10n,
    required this.onTap,
  });

  final ZakatLine line;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GroupedRow(
      title: line.label,
      titleStyle: DuskText.bangla(
        size: AppValues.fontSize_14,
        weight: FontWeight.w600,
        color: AppColors.ink,
      ),
      subtitle: line.subLabel.isEmpty ? null : line.subLabel,
      value: line.isDeduction
          ? formatTakaNegative(line.amount)
          : formatTaka(line.amount),
      valueStyle: DuskText.bangla(
        size: AppValues.fontSize_15,
        weight: FontWeight.w700,
        // A deduction is the one number on this screen that reduces the
        // answer, so it is the one number that is not ink-coloured.
        color: line.isDeduction && line.amount > 0
            ? AppColors.danger
            : AppColors.ink,
      ),
      onTap: onTap,
    );
  }
}
