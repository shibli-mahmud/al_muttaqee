import 'dart:convert';

import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/zakat/data/metal_rates_repository.dart';

/// One line of the calculation.
class ZakatLine {
  const ZakatLine({
    required this.id,
    required this.label,
    required this.amount,
    this.subLabel = '',
    this.isDeduction = false,
    this.custom = false,
  });

  final String id;
  final String label;

  /// Always in taka. Gold and silver are entered by weight and converted at
  /// the current rate before they get here, because what the user wants to
  /// check at the end is a taka figure.
  final double amount;

  /// The detail under the label — `১২ ভরি` on the gold row.
  final String subLabel;

  final bool isDeduction;

  /// Added by the user through আরেকটি খাত যোগ করুন.
  final bool custom;

  ZakatLine copyWith({double? amount, String? subLabel, String? label}) =>
      ZakatLine(
        id: id,
        label: label ?? this.label,
        amount: amount ?? this.amount,
        subLabel: subLabel ?? this.subLabel,
        isDeduction: isDeduction,
        custom: custom,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'label': label,
        'amount': amount,
        'subLabel': subLabel,
        'isDeduction': isDeduction,
        'custom': custom,
      };

  static ZakatLine fromJson(Map<String, Object?> json) => ZakatLine(
        id: json['id']! as String,
        label: json['label']! as String,
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        subLabel: (json['subLabel'] as String?) ?? '',
        isDeduction: (json['isDeduction'] as bool?) ?? false,
        custom: (json['custom'] as bool?) ?? false,
      );
}

/// যাকাত — frame ১৭.
///
/// Gold and silver are held by weight in *bhori*, which is how they are bought
/// and talked about in Bangladesh — asking someone for grams would mean they
/// have to convert before they can answer.
class ZakatController extends BaseController {
  static ZakatController get to => Get.find<ZakatController>();

  ZakatController({
    MetalRatesRepository? repository,
    PreferenceManager? prefs,
  })  : _repository = repository ?? MetalRatesRepository(),
        _prefs = prefs ?? PreferenceManagerImpl.to;

  final MetalRatesRepository _repository;
  final PreferenceManager _prefs;

  /// One bhori, in grams. The Bangladeshi tola.
  static const double gramsPerBhori = 11.664;

  /// Nisab in grams, on the two classical measures.
  static const double goldNisabGrams = 87.48;
  static const double silverNisabGrams = 612.36;

  static const double zakatRate = 0.025;

  final rates = Rxn<MetalRates>();
  final isLoadingRates = true.obs;

  final assets = <ZakatLine>[].obs;
  final deductions = <ZakatLine>[].obs;

  /// Gold and silver, in bhori.
  final goldBhori = 0.0.obs;
  final silverBhori = 0.0.obs;

  /// Silver nisab is the default: it is the lower threshold, so it catches
  /// more people, which is the cautious reading and the one Bangladeshi
  /// scholars generally advise.
  final useGoldNisab = false.obs;

  @override
  void onInit() {
    super.onInit();
    _seed();
    _load();
    refreshRates();
  }

  void _seed() {
    final l10n = appLocalization;
    assets.assignAll([
      ZakatLine(id: 'cash', label: l10n.zakatCash, amount: 0),
      ZakatLine(id: 'gold', label: l10n.zakatGold, amount: 0),
      ZakatLine(id: 'silver', label: l10n.zakatSilver, amount: 0),
      ZakatLine(id: 'business', label: l10n.zakatBusiness, amount: 0),
      ZakatLine(id: 'investments', label: l10n.zakatInvestments, amount: 0),
    ]);
    deductions.assignAll([
      ZakatLine(id: 'debts', label: l10n.zakatDebts, amount: 0, isDeduction: true),
      ZakatLine(
        id: 'expenses',
        label: l10n.zakatExpenses,
        amount: 0,
        isDeduction: true,
      ),
    ]);
  }

  Future<void> _load() async {
    try {
      final raw = await _prefs.getString(AppStrings.spZakatDraft);
      if (raw.isEmpty) return;

      final json = jsonDecode(raw) as Map<String, dynamic>;
      goldBhori.value = (json['goldBhori'] as num?)?.toDouble() ?? 0;
      silverBhori.value = (json['silverBhori'] as num?)?.toDouble() ?? 0;
      useGoldNisab.value = (json['useGoldNisab'] as bool?) ?? false;

      final savedAssets = (json['assets'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => ZakatLine.fromJson(Map<String, Object?>.from(e)))
          .toList();
      final savedDeductions = (json['deductions'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => ZakatLine.fromJson(Map<String, Object?>.from(e)))
          .toList();

      if (savedAssets.isNotEmpty) assets.assignAll(savedAssets);
      if (savedDeductions.isNotEmpty) deductions.assignAll(savedDeductions);
    } catch (e, st) {
      logger.e('ZakatController._load: $e\n$st');
    }
  }

  Future<void> _save() async {
    await _prefs.setString(
      AppStrings.spZakatDraft,
      jsonEncode({
        'goldBhori': goldBhori.value,
        'silverBhori': silverBhori.value,
        'useGoldNisab': useGoldNisab.value,
        'assets': assets.map((l) => l.toJson()).toList(),
        'deductions': deductions.map((l) => l.toJson()).toList(),
      }),
    );
  }

  Future<void> refreshRates() async {
    isLoadingRates.value = true;
    try {
      rates.value = await _repository.getRates();
      _revalueMetals();
    } catch (e, st) {
      logger.e('ZakatController.refreshRates: $e\n$st');
    } finally {
      isLoadingRates.value = false;
    }
  }

  double get goldPerGram => rates.value?.goldPerGram ?? 0;
  double get silverPerGram => rates.value?.silverPerGram ?? 0;

  double get goldPerBhori => goldPerGram * gramsPerBhori;
  double get silverPerBhori => silverPerGram * gramsPerBhori;

  /// Recomputes the gold and silver rows after a rate change, so a stale
  /// valuation never lingers behind a fresh rate.
  void _revalueMetals() {
    setMetal(gold: true, bhori: goldBhori.value);
    setMetal(gold: false, bhori: silverBhori.value);
  }

  Future<void> setMetal({required bool gold, required double bhori}) async {
    final l10n = appLocalization;
    if (gold) {
      goldBhori.value = bhori;
    } else {
      silverBhori.value = bhori;
    }

    final id = gold ? 'gold' : 'silver';
    final value = bhori * (gold ? goldPerBhori : silverPerBhori);
    final index = assets.indexWhere((l) => l.id == id);
    if (index >= 0) {
      assets[index] = assets[index].copyWith(
        amount: value,
        subLabel: bhori <= 0 ? '' : l10n.zakatBhori(_trim(bhori)),
      );
      assets.refresh();
    }
    await _save();
  }

  String _trim(double value) =>
      value == value.roundToDouble() ? value.round().toString() : '$value';

  Future<void> setAmount(String id, double amount) async {
    var index = assets.indexWhere((l) => l.id == id);
    if (index >= 0) {
      assets[index] = assets[index].copyWith(amount: amount);
      assets.refresh();
    } else {
      index = deductions.indexWhere((l) => l.id == id);
      if (index >= 0) {
        deductions[index] = deductions[index].copyWith(amount: amount);
        deductions.refresh();
      }
    }
    await _save();
  }

  Future<void> addCustomLine(String label, double amount) async {
    assets.add(
      ZakatLine(
        id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
        label: label,
        amount: amount,
        custom: true,
      ),
    );
    await _save();
  }

  Future<void> removeLine(String id) async {
    assets.removeWhere((l) => l.id == id && l.custom);
    await _save();
  }

  Future<void> setNisabBasis(bool gold) async {
    useGoldNisab.value = gold;
    await _save();
  }

  // ── The arithmetic ────────────────────────────────────────────────────────

  double get totalAssets =>
      assets.fold<double>(0, (sum, line) => sum + line.amount);

  double get totalDeductions =>
      deductions.fold<double>(0, (sum, line) => sum + line.amount);

  /// Zakatable wealth: assets less what is owed, floored at zero.
  double get zakatableWealth =>
      (totalAssets - totalDeductions).clamp(0, double.infinity);

  double get nisab => useGoldNisab.value
      ? goldNisabGrams * goldPerGram
      : silverNisabGrams * silverPerGram;

  bool get meetsNisab => nisab > 0 && zakatableWealth >= nisab;

  double get payable => meetsNisab ? zakatableWealth * zakatRate : 0;

  bool get ratesUnavailable => goldPerGram <= 0 && silverPerGram <= 0;
}
