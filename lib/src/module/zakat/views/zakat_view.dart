import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/application_bar.dart';
import 'package:al_muttaqee/src/module/zakat/controllers/zakat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ZakatView extends BaseView<ZakatController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      ApplicationBar(appTitleText: AppLocalizations.of(context)!.zakat);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      final money = NumberFormat.currency(symbol: '\$');
      final rates = controller.rates.value;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(l10n.cash, 'cash'),
          _field(l10n.goldGrams, 'gold'),
          _field(l10n.silverGrams, 'silver'),
          _field(l10n.businessAssets, 'business'),
          _field(l10n.debtsOwedToYou, 'owed'),
          _field(l10n.debtsYouOwe, 'debts'),
          SwitchListTile(
            title: Text(l10n.useGoldNisab, style: kFigtree600W14S),
            value: controller.useGoldNisab.value,
            onChanged: (value) => controller.useGoldNisab.value = value,
          ),
          if (rates != null)
            Text(
              l10n.ratesLastUpdated(DateFormat.yMMMd().format(rates.updatedAt)),
              style: kFigtree400W12S.copyWith(color: AppColors.grey600),
            ),
          const SizedBox(height: 16),
          _result(l10n.nisabThreshold, money.format(controller.nisab)),
          _result(l10n.zakatDue, money.format(controller.zakatDue), prominent: true),
        ],
      );
    });
  }

  Widget _field(String label, String field) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => controller.updateField(field, value),
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
      );

  Widget _result(String label, String value, {bool prominent = false}) => Card(
        color: prominent ? AppColors.brand100 : AppColors.baseWhite,
        child: ListTile(
          title: Text(label, style: kFigtree600W14S),
          trailing: Text(value, style: prominent ? kFigtree700W22S : kFigtree600W16S),
        ),
      );
}
