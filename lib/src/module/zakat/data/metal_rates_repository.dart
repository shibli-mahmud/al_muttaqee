import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:dio/dio.dart';

class MetalRates {
  const MetalRates({
    required this.goldPerGram,
    required this.silverPerGram,
    required this.updatedAt,
  });

  final double goldPerGram;
  final double silverPerGram;
  final DateTime updatedAt;
}

class MetalRatesRepository {
  static const _goldKey = 'zakat_gold_per_gram';
  static const _silverKey = 'zakat_silver_per_gram';
  static const _updatedKey = 'zakat_rates_updated';

  Future<MetalRates> getRates() async {
    final prefs = PreferenceManagerImpl.to;
    final cachedDate = await prefs.getString(_updatedKey);
    final cachedGold = await prefs.getDouble(_goldKey, defaultValue: 10500);
    final cachedSilver = await prefs.getDouble(_silverKey, defaultValue: 125);
    final updated = DateTime.tryParse(cachedDate);
    if (updated != null && DateTime.now().difference(updated).inHours < 24) {
      return MetalRates(goldPerGram: cachedGold, silverPerGram: cachedSilver, updatedAt: updated);
    }
    try {
      final data = (await Dio().get<dynamic>('https://api.metals.live/v1/spot')).data;
      final first = data is List && data.isNotEmpty ? data.first : data;
      final map = first as Map<String, dynamic>;
      // API values are USD/troy ounce; callers enter the local currency, so
      // cache a neutral USD price until a local-currency provider is configured.
      final gold = (map['gold'] as num).toDouble() / 31.1035;
      final silver = (map['silver'] as num).toDouble() / 31.1035;
      final now = DateTime.now();
      await prefs.setDouble(_goldKey, gold);
      await prefs.setDouble(_silverKey, silver);
      await prefs.setString(_updatedKey, now.toIso8601String());
      return MetalRates(goldPerGram: gold, silverPerGram: silver, updatedAt: now);
    } catch (_) {
      return MetalRates(
        goldPerGram: cachedGold,
        silverPerGram: cachedSilver,
        updatedAt: updated ?? DateTime.now(),
      );
    }
  }
}
