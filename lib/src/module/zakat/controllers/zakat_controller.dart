import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/module/zakat/data/metal_rates_repository.dart';
import 'package:get/get.dart';

class ZakatController extends BaseController {
  ZakatController({MetalRatesRepository? repository})
      : _repository = repository ?? MetalRatesRepository();

  final MetalRatesRepository _repository;
  final cash = 0.0.obs;
  final goldGrams = 0.0.obs;
  final silverGrams = 0.0.obs;
  final businessAssets = 0.0.obs;
  final owedToYou = 0.0.obs;
  final debtsYouOwe = 0.0.obs;
  final useGoldNisab = true.obs;
  final rates = Rxn<MetalRates>();

  @override
  void onInit() {
    super.onInit();
    refreshRates();
  }

  Future<void> refreshRates() async => rates.value = await _repository.getRates();

  double get totalAssets => cash.value +
      goldGrams.value * (rates.value?.goldPerGram ?? 0) +
      silverGrams.value * (rates.value?.silverPerGram ?? 0) +
      businessAssets.value +
      owedToYou.value;

  double get netWorth => (totalAssets - debtsYouOwe.value).clamp(0, double.infinity);

  double get nisab => useGoldNisab.value
      ? 85 * (rates.value?.goldPerGram ?? 0)
      : 595 * (rates.value?.silverPerGram ?? 0);

  double get zakatDue => netWorth >= nisab ? netWorth * .025 : 0;

  void updateField(String field, String raw) {
    final value = double.tryParse(raw.replaceAll(',', '')) ?? 0;
    switch (field) {
      case 'cash':
        cash.value = value;
        break;
      case 'gold':
        goldGrams.value = value;
        break;
      case 'silver':
        silverGrams.value = value;
        break;
      case 'business':
        businessAssets.value = value;
        break;
      case 'owed':
        owedToYou.value = value;
        break;
      case 'debts':
        debtsYouOwe.value = value;
        break;
    }
  }
}
