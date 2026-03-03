import 'dart:async';
import 'dart:math' as math;

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';

class QiblaController extends BaseController {
  static QiblaController get to => Get.find<QiblaController>();

  final RxDouble qiblaDirection = 0.0.obs; // Bearing from north to Qibla
  final RxDouble heading = 0.0.obs; // Device heading from compass
  final RxDouble tilt = 0.0.obs; // Device tilt angle in degrees (0 = flat)

  final RxBool hasLocationPermission = false.obs;
  final RxBool isLocationServiceEnabled = false.obs;
  final RxBool isReady = false.obs;

  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  @override
  void onInit() {
    super.onInit();
    _initQibla();
  }

  Future<void> _initQibla() async {
    try {
      showLoading();

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationServiceEnabled.value = serviceEnabled;
      if (!serviceEnabled) {
        showErrorMessage('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showErrorMessage(
          'Location permission is required to calculate the Qibla direction.',
        );
        return;
      }

      hasLocationPermission.value = true;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final bearing = _calculateBearing(
        position.latitude,
        position.longitude,
      );
      qiblaDirection.value = bearing;

      _listenToCompass();
      _listenToTilt();

      isReady.value = true;
    } catch (e) {
      showErrorMessage('Failed to initialize Qibla compass.');
      logger.e('QiblaController _initQibla error: $e');
    } finally {
      hideLoading();
    }
  }

  double _calculateBearing(double latitude, double longitude) {
    final double lat1 = _degreesToRadians(latitude);
    final double lon1 = _degreesToRadians(longitude);
    final double lat2 = _degreesToRadians(_kaabaLatitude);
    final double lon2 = _degreesToRadians(_kaabaLongitude);

    final double dLon = lon2 - lon1;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final double bearingRad = math.atan2(y, x);
    final double bearingDeg = _radiansToDegrees(bearingRad);

    // Normalize to 0 - 360
    return (bearingDeg + 360) % 360;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  double _radiansToDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  void _listenToCompass() {
    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen((event) {
      final headingValue = event.heading;
      if (headingValue == null) return;
      heading.value = headingValue;
    });
  }

  void _listenToTilt() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final double g = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (g == 0) {
        tilt.value = 0;
        return;
      }

      final double cosTheta = (event.z / g).clamp(-1.0, 1.0);
      final double theta = math.acos(cosTheta);
      tilt.value = _radiansToDegrees(theta);
    });
  }

  @override
  void onClose() {
    _compassSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.onClose();
  }
}