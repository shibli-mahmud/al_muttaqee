import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/application_bar.dart';
import 'package:al_muttaqee/src/module/pro/controllers/pro_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProView extends BaseView<ProController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      ApplicationBar(appTitleText: AppLocalizations.of(context)!.supportApp);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(
      () => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(Icons.volunteer_activism, size: 64, color: AppColors.brand600),
          const SizedBox(height: 12),
          Text(l10n.proUnlock, textAlign: TextAlign.center, style: kFigtree700W22S),
          const SizedBox(height: 12),
          Text(l10n.proBenefits, textAlign: TextAlign.center, style: kFigtree400W14S),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isPro.value ? null : controller.buyPro,
            child: Text(controller.isPro.value ? l10n.proUnlocked : l10n.proUnlock),
          ),
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text(l10n.restorePurchases),
          ),
          const Divider(height: 36),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.supportApp, style: kFigtree600W16S),
            subtitle: Text(l10n.supportDescription, style: kFigtree400W14S),
            onTap: controller.supportApp,
          ),
          if (!controller.storeAvailable.value)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l10n.storeUnavailable, style: kFigtree400W14S),
            ),
          if (kDebugMode)
            SwitchListTile(
              title: Text(l10n.debugProUnlock),
              value: controller.isPro.value,
              onChanged: controller.setDebugPro,
            ),
        ],
      ),
    );
  }
}
