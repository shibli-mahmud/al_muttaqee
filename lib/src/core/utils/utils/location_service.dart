import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// Shared GPS / permission helper used by Qibla, Prayer Times, and Masjid Finder.
class LocationService extends GetxService {
  static LocationService get to => Get.find<LocationService>();

  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  /// Returns true when the user has granted usable location access.
  Future<bool> ensurePermission() async {
    final serviceEnabled = await isServiceEnabled();
    if (!serviceEnabled) return false;

    final permission = await requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: accuracy),
    );
  }

  /// Last known position if available (faster, may be stale).
  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition();
}
