import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A walking route from the user to a masjid.
class MasjidRoute {
  const MasjidRoute({
    required this.points,
    required this.distanceMetres,
    required this.durationSeconds,
    required this.isEstimate,
  });

  /// The line to draw on the map.
  final List<LatLng> points;

  final double distanceMetres;
  final int durationSeconds;

  /// True when this is the straight-line fallback rather than a real route,
  /// so the UI can avoid claiming a walking time it does not have.
  final bool isEstimate;

  int get walkMinutes => (durationSeconds / 60).round();
}

/// Fetches walking routes.
///
/// Google's Directions API is billed per request and needs a key with billing
/// attached, which is not worth it to draw one line to a masjid four hundred
/// metres away. OSRM is open, keyless and free, and its walking profile is
/// perfectly good over the distances involved here.
///
/// Turn-by-turn navigation is a different job and is not attempted in-app:
/// [MasjidFinderController.openDirections] hands that to the Google Maps app,
/// which the user already has, already trusts, and which costs nothing to
/// launch through a URL.
///
/// The public OSRM demo server has no uptime guarantee and asks that heavy
/// users self-host. For a released build, point [_baseUrl] at your own OSRM
/// instance or an OpenRouteService key; until then every failure falls back to
/// the straight line, which is still useful — it shows the direction and the
/// distance, and only declines to guess a walking time.
class RouteRepository {
  RouteRepository({Dio? client})
      : _client = client ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
              ),
            );

  final Dio _client;

  static const String _baseUrl = 'https://router.project-osrm.org';

  /// Average walking speed, metres per second, used only by the fallback.
  static const double _walkingSpeed = 1.35;

  Future<MasjidRoute> walkingRoute({
    required LatLng from,
    required LatLng to,
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '$_baseUrl/route/v1/foot/'
        '${from.longitude},${from.latitude};'
        '${to.longitude},${to.latitude}',
        queryParameters: const {
          'overview': 'full',
          'geometries': 'polyline',
        },
      );

      final routes = response.data?['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty) return _straightLine(from, to);

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as String?;
      if (geometry == null || geometry.isEmpty) {
        return _straightLine(from, to);
      }

      return MasjidRoute(
        points: decodePolyline(geometry),
        distanceMetres: (route['distance'] as num?)?.toDouble() ?? 0,
        durationSeconds: ((route['duration'] as num?) ?? 0).round(),
        isEstimate: false,
      );
    } catch (error) {
      debugPrint('RouteRepository.walkingRoute: $error');
      return _straightLine(from, to);
    }
  }

  /// What to draw when routing is unavailable.
  ///
  /// Marked [MasjidRoute.isEstimate] so the card can say "as the crow flies"
  /// rather than quoting a walking time that ignores every river and wall in
  /// between.
  MasjidRoute _straightLine(LatLng from, LatLng to) {
    final metres = _haversine(from, to);
    return MasjidRoute(
      points: [from, to],
      distanceMetres: metres,
      durationSeconds: (metres / _walkingSpeed).round(),
      isEstimate: true,
    );
  }

  static double _haversine(LatLng a, LatLng b) {
    const radius = 6371008.8;
    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;
    final dLat = lat2 - lat1;
    final dLon = (b.longitude - a.longitude) * math.pi / 180;

    final h = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    return radius * 2 * math.asin(math.min(1, math.sqrt(h)));
  }
}

/// Decodes Google's encoded-polyline format, which OSRM also returns.
///
/// Implemented here rather than pulled in as a package: it is twenty lines,
/// and it is the only thing the app would use that package for.
@visibleForTesting
List<LatLng> decodePolyline(String encoded, {int precision = 5}) {
  final points = <LatLng>[];
  final factor = math.pow(10, precision);

  var index = 0;
  var lat = 0;
  var lng = 0;

  /// Reads one varint, or returns null when the string runs out mid-value.
  ///
  /// A response truncated by a dropped connection must give back the points it
  /// did manage to decode rather than throwing — the map can draw a partial
  /// line, and the alternative is a crash on a flaky network.
  int? readValue() {
    var shift = 0;
    var result = 0;
    int byte;
    do {
      if (index >= encoded.length) return null;
      byte = encoded.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);
    return (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  }

  while (index < encoded.length) {
    final dLat = readValue();
    if (dLat == null) break;
    final dLng = readValue();
    if (dLng == null) break;

    lat += dLat;
    lng += dLng;
    points.add(LatLng(lat / factor, lng / factor));
  }

  return points;
}
