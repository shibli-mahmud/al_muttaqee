import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:al_muttaqee/src/module/masjid_finder/data/route_repository.dart';

void main() {
  group('decodePolyline', () {
    test('decodes the reference string from the Google spec', () {
      // `_p~iF~ps|U_ulLnnqC_mqNvxq`@` is the example in Google's encoded
      // polyline documentation, and decodes to three known points.
      final points = decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');

      expect(points, hasLength(3));
      expect(points[0].latitude, closeTo(38.5, 0.00001));
      expect(points[0].longitude, closeTo(-120.2, 0.00001));
      expect(points[1].latitude, closeTo(40.7, 0.00001));
      expect(points[1].longitude, closeTo(-120.95, 0.00001));
      expect(points[2].latitude, closeTo(43.252, 0.00001));
      expect(points[2].longitude, closeTo(-126.453, 0.00001));
    });

    test('an empty string decodes to no points rather than throwing', () {
      expect(decodePolyline(''), isEmpty);
    });

    test('a truncated string does not run off the end', () {
      // A response cut short by a dropped connection must degrade, not crash.
      expect(() => decodePolyline('_p~iF~ps|U_ul'), returnsNormally);
    });
  });

  group('MasjidRoute', () {
    test('rounds the walking time to whole minutes', () {
      const route = MasjidRoute(
        points: [LatLng(23.81, 90.41), LatLng(23.82, 90.42)],
        distanceMetres: 420,
        durationSeconds: 310,
        isEstimate: false,
      );
      expect(route.walkMinutes, 5);
    });

    test('an estimate is flagged so the UI can hedge the wording', () {
      const estimate = MasjidRoute(
        points: [LatLng(23.81, 90.41), LatLng(23.82, 90.42)],
        distanceMetres: 1200,
        durationSeconds: 889,
        isEstimate: true,
      );
      expect(estimate.isEstimate, isTrue);
    });
  });
}
