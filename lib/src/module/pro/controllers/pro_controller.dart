import 'dart:async';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ProController extends BaseController {
  static const _proProductId = 'al_muttaqee_pro';
  static const _supportProductId = 'al_muttaqee_support';
  static const _proPreference = 'pro_unlocked';

  final isPro = false.obs;
  final storeAvailable = false.obs;
  final products = <ProductDetails>[].obs;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    isPro.value = await PreferenceManagerImpl.to.getBool(
      _proPreference,
      defaultValue: false,
    );
    _subscription = InAppPurchase.instance.purchaseStream.listen(_handlePurchases);
    storeAvailable.value = await InAppPurchase.instance.isAvailable();
    if (!storeAvailable.value) return;
    final response = await InAppPurchase.instance.queryProductDetails({
      _proProductId,
      _supportProductId,
    });
    products.assignAll(response.productDetails);
  }

  Future<void> buyPro() => _buy(_proProductId, consumable: false);
  Future<void> supportApp() => _buy(_supportProductId, consumable: true);

  Future<void> _buy(String id, {required bool consumable}) async {
    final product = products.firstWhereOrNull((item) => item.id == id);
    if (product == null) {
      showErrorMessage(appLocalization.storeUnavailable);
      return;
    }
    final param = PurchaseParam(productDetails: product);
    if (consumable) {
      await InAppPurchase.instance.buyConsumable(purchaseParam: param);
    } else {
      await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> restorePurchases() => InAppPurchase.instance.restorePurchases();

  Future<void> setDebugPro(bool value) async {
    isPro.value = value;
    await PreferenceManagerImpl.to.setBool(_proPreference, value);
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID == _proProductId &&
          purchase.status == PurchaseStatus.purchased) {
        await setDebugPro(true);
      }
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
