import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';
import 'package:al_muttaqee/src/module/masjid_finder/data/masjid_repository.dart';
import 'package:al_muttaqee/src/module/masjid_finder/models/masjid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MasjidFinderController extends BaseController {
  MasjidFinderController({
    MasjidRepository? repository,
    LocationService? locationService,
  })  : _repository = repository ?? MasjidRepository(),
        _locationService = locationService ?? LocationService.to;

  final MasjidRepository _repository;
  final LocationService _locationService;
  final position = const LatLngData(23.8103, 90.4125).obs;
  final masjids = <Masjid>[].obs;
  final radiusKm = 5.0.obs;
  final locationAvailable = false.obs;
  final apiKeyMissing = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshMasjids();
  }

  Future<void> refreshMasjids() async {
    showLoading();
    try {
      final permitted = await _locationService.ensurePermission();
      locationAvailable.value = permitted;
      if (permitted) {
        final Position current = await _locationService.getCurrentPosition();
        position.value = LatLngData(current.latitude, current.longitude);
      }
      final key = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';
      apiKeyMissing.value = key.isEmpty;
      final results = await _repository.nearby(
        latitude: position.value.latitude,
        longitude: position.value.longitude,
        apiKey: key,
        radiusMeters: (radiusKm.value * 1000).round(),
      );
      masjids.assignAll(
        results
            .map(
              (masjid) => masjid.withDistance(
                Geolocator.distanceBetween(
                      position.value.latitude,
                      position.value.longitude,
                      masjid.latitude,
                      masjid.longitude,
                    ) /
                    1000,
              ),
            )
            .toList()
          ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm)),
      );
    } catch (e, st) {
      logger.e('MasjidFinderController.refreshMasjids: $e\n$st');
      showErrorMessage(appLocalization.prayerTimesLoadError);
    } finally {
      hideLoading();
    }
  }

  Future<void> openDirections(Masjid masjid) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${masjid.latitude},${masjid.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showErrorMessage(appLocalization.openInMaps);
    }
  }
}

class LatLngData {
  const LatLngData(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}
