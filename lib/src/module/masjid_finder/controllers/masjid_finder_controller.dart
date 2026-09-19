import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';
import 'package:al_muttaqee/src/module/masjid_finder/data/masjid_jamaat_store.dart';
import 'package:al_muttaqee/src/module/masjid_finder/data/masjid_repository.dart';
import 'package:al_muttaqee/src/module/masjid_finder/data/route_repository.dart';
import 'package:al_muttaqee/src/module/masjid_finder/models/masjid.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// How the list is ordered.
enum MasjidSort { distance, jamaat, jumua }

class MasjidFinderController extends BaseController {
  static MasjidFinderController get to => Get.find<MasjidFinderController>();

  MasjidFinderController({
    MasjidRepository? repository,
    RouteRepository? routes,
    MasjidJamaatStore? jamaatStore,
    LocationService? locationService,
  })  : _repository = repository ?? MasjidRepository(),
        _routes = routes ?? RouteRepository(),
        _jamaat = jamaatStore ?? MasjidJamaatStore(),
        _locationService = locationService ?? LocationService.to;

  final MasjidRepository _repository;
  final RouteRepository _routes;
  final MasjidJamaatStore _jamaat;
  final LocationService _locationService;

  /// Dhaka until the device says otherwise, so the map has somewhere to open.
  final position = const LatLng(23.8103, 90.4125).obs;

  final masjids = <Masjid>[].obs;
  final radiusKm = 2.0.obs;
  final sort = MasjidSort.distance.obs;

  final locationAvailable = false.obs;
  final apiKeyMissing = false.obs;
  final isLoading = true.obs;
  final loadError = ''.obs;

  /// The masjid whose route is drawn and whose card is expanded.
  final selected = Rxn<Masjid>();
  final route = Rxn<MasjidRoute>();
  final isRouting = false.obs;

  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    refreshMasjids();
  }

  Future<void> refreshMasjids() async {
    isLoading.value = true;
    loadError.value = '';

    try {
      locationAvailable.value = await _locationService.ensurePermission();
      if (locationAvailable.value) {
        final current = await _locationService.getCurrentPosition();
        position.value = LatLng(current.latitude, current.longitude);
      }

      final key = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';
      apiKeyMissing.value = key.isEmpty || key == 'YOUR_GOOGLE_PLACES_API_KEY';
      if (apiKeyMissing.value) {
        masjids.clear();
        return;
      }

      final found = await _repository.nearby(
        latitude: position.value.latitude,
        longitude: position.value.longitude,
        apiKey: key,
        radiusMeters: (radiusKm.value * 1000).round(),
      );

      final withDetail = <Masjid>[];
      for (final masjid in found) {
        withDetail.add(
          masjid.copyWith(
            distanceKm: Geolocator.distanceBetween(
                  position.value.latitude,
                  position.value.longitude,
                  masjid.latitude,
                  masjid.longitude,
                ) /
                1000,
            jamaat: await _jamaat.read(masjid.id),
          ),
        );
      }

      masjids.assignAll(withDetail);
      _applySort();

      if (masjids.isNotEmpty) await select(masjids.first);
    } catch (e, st) {
      logger.e('MasjidFinderController.refreshMasjids: $e\n$st');
      loadError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSort(MasjidSort value) {
    sort.value = value;
    _applySort();
  }

  void _applySort() {
    final sorted = masjids.toList();
    switch (sort.value) {
      case MasjidSort.distance:
        sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      case MasjidSort.jamaat:
        // Masjids whose jamaat times are known first — those are the ones the
        // user can actually act on — then by distance within each group.
        sorted.sort((a, b) {
          if (a.hasJamaat != b.hasJamaat) return a.hasJamaat ? -1 : 1;
          return a.distanceKm.compareTo(b.distanceKm);
        });
      case MasjidSort.jumua:
        sorted.sort((a, b) {
          final aJumua = a.jamaat.containsKey(PrayerName.dhuhr);
          final bJumua = b.jamaat.containsKey(PrayerName.dhuhr);
          if (aJumua != bJumua) return aJumua ? -1 : 1;
          return a.distanceKm.compareTo(b.distanceKm);
        });
    }
    masjids.assignAll(sorted);
  }

  Future<void> select(Masjid masjid) async {
    selected.value = masjid;
    route.value = null;
    isRouting.value = true;

    await mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFor(position.value, LatLng(masjid.latitude, masjid.longitude)),
        64,
      ),
    );

    try {
      route.value = await _routes.walkingRoute(
        from: position.value,
        to: LatLng(masjid.latitude, masjid.longitude),
      );
    } finally {
      isRouting.value = false;
    }
  }

  LatLngBounds _boundsFor(LatLng a, LatLng b) => LatLngBounds(
        southwest: LatLng(
          a.latitude < b.latitude ? a.latitude : b.latitude,
          a.longitude < b.longitude ? a.longitude : b.longitude,
        ),
        northeast: LatLng(
          a.latitude > b.latitude ? a.latitude : b.latitude,
          a.longitude > b.longitude ? a.longitude : b.longitude,
        ),
      );

  /// Hands turn-by-turn to the Google Maps app.
  ///
  /// Navigating is a solved problem the user already has installed, and the
  /// URL that launches it is free and unmetered — unlike the Directions API,
  /// which is billed per call. The in-app line is for orientation; this is for
  /// actually walking there.
  Future<void> openDirections(Masjid masjid) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${position.value.latitude},${position.value.longitude}'
      '&destination=${masjid.latitude},${masjid.longitude}'
      '&travelmode=walking',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showErrorMessage(appLocalization.openInMaps);
    }
  }

  /// Records a jamaat time the user knows for a masjid.
  Future<void> setJamaat(
    Masjid masjid,
    PrayerName prayer,
    JamaatTime? time,
  ) async {
    await _jamaat.setPrayer(masjid.id, prayer, time);
    final updated = masjid.copyWith(jamaat: await _jamaat.read(masjid.id));

    final index = masjids.indexWhere((m) => m.id == masjid.id);
    if (index >= 0) masjids[index] = updated;
    if (selected.value?.id == masjid.id) selected.value = updated;
    masjids.refresh();
  }

  /// The prayer whose jamaat is next, so its cell can be highlighted.
  PrayerName? get nextJamaatPrayer {
    if (!Get.isRegistered<PrayerTimesController>()) return null;
    final times = PrayerTimesController.to.dayTimes.value;
    if (times == null) return null;

    final now = DateTime.now();
    for (final prayer in trackedPrayers) {
      final entry = times.entryFor(prayer);
      if (entry != null && entry.time.isAfter(now)) return prayer;
    }
    return trackedPrayers.first;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
