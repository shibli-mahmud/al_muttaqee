import 'package:al_muttaqee/src/core/network/dio_network_provider.dart';
import 'package:al_muttaqee/src/module/masjid_finder/models/masjid.dart';
import 'package:dio/dio.dart';

class MasjidRepository {
  MasjidRepository({Dio? client})
      : _client = client ??
            NetworkProvider.createClient(
              baseUrl: 'https://maps.googleapis.com/maps/api/',
            );

  final Dio _client;

  Future<List<Masjid>> nearby({
    required double latitude,
    required double longitude,
    required String apiKey,
    int radiusMeters = 5000,
  }) async {
    if (apiKey.isEmpty || apiKey == 'YOUR_GOOGLE_PLACES_API_KEY') return [];
    final response = await _client.get<Map<String, dynamic>>(
      'place/nearbysearch/json',
      queryParameters: {
        'location': '$latitude,$longitude',
        'radius': radiusMeters,
        'type': 'mosque',
        'key': apiKey,
      },
    );
    final results = response.data?['results'] as List<dynamic>? ?? [];
    return results.whereType<Map<String, dynamic>>().map((item) {
      final location = item['geometry']?['location'] as Map<String, dynamic>? ?? {};
      return Masjid(
        id: item['place_id'] as String? ?? item['name'] as String? ?? '',
        name: item['name'] as String? ?? '',
        address: item['vicinity'] as String? ?? '',
        latitude: (location['lat'] as num?)?.toDouble() ?? latitude,
        longitude: (location['lng'] as num?)?.toDouble() ?? longitude,
      );
    }).toList();
  }
}
