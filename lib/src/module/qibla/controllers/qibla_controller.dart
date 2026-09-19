import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';

/// How well the magnetometer is behaving.
enum CompassAccuracy { unknown, low, medium, high }

/// Which way to turn to face the qibla.
enum QiblaTurn { left, right, aligned }

class QiblaController extends BaseController {
  static QiblaController get to => Get.find<QiblaController>();

  /// Bearing from the user to the Kaaba, in degrees clockwise from true north.
  final qiblaBearing = 0.0.obs;

  /// Device heading, smoothed. See [_smooth].
  final heading = 0.0.obs;

  /// Great-circle distance to Makkah, in kilometres.
  final distanceKm = 0.0.obs;

  final accuracy = CompassAccuracy.unknown.obs;
  final hasLocationPermission = false.obs;
  final isLocationServiceEnabled = false.obs;
  final isReady = false.obs;
  final errorMessageKey = ''.obs;

  StreamSubscription<CompassEvent>? _compass;

  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;
  static const double _earthRadiusKm = 6371.0088;

  /// Within this many degrees counts as facing the qibla. Five degrees is
  /// about the limit of what a phone magnetometer can honestly claim, and it
  /// is well inside the tolerance the prayer itself allows.
  static const double alignmentToleranceDegrees = 5;

  bool _wasAligned = false;

  LocationService get _location => LocationService.to;

  @override
  void onInit() {
    super.onInit();
    start();
  }

  Future<void> start() async {
    errorMessageKey.value = '';
    isReady.value = false;

    try {
      isLocationServiceEnabled.value = await _location.isServiceEnabled();
      if (!isLocationServiceEnabled.value) {
        errorMessageKey.value = 'locationService';
        return;
      }

      hasLocationPermission.value = await _location.ensurePermission();
      if (!hasLocationPermission.value) {
        errorMessageKey.value = 'locationPermission';
        return;
      }

      final position = await _location.getCurrentPosition(
        accuracy: LocationAccuracy.high,
      );

      qiblaBearing.value = _bearingTo(
        position.latitude,
        position.longitude,
      );
      distanceKm.value = _distanceTo(
        position.latitude,
        position.longitude,
      );

      _listenToCompass();
      isReady.value = true;
    } catch (e, st) {
      logger.e('QiblaController.start: $e\n$st');
      errorMessageKey.value = 'compass';
    }
  }

  /// Initial great-circle bearing from the user to the Kaaba.
  ///
  /// The great-circle bearing, not the rhumb line: the qibla is the shortest
  /// path over the sphere, which from Bangladesh runs noticeably north of the
  /// due-west a flat map would suggest.
  double _bearingTo(double latitude, double longitude) {
    final lat1 = _rad(latitude);
    final lat2 = _rad(_kaabaLatitude);
    final dLon = _rad(_kaabaLongitude - longitude);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (_deg(math.atan2(y, x)) + 360) % 360;
  }

  double _distanceTo(double latitude, double longitude) {
    final lat1 = _rad(latitude);
    final lat2 = _rad(_kaabaLatitude);
    final dLat = lat2 - lat1;
    final dLon = _rad(_kaabaLongitude - longitude);

    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    return _earthRadiusKm * 2 * math.asin(math.min(1, math.sqrt(a)));
  }

  double _rad(double degrees) => degrees * math.pi / 180;
  double _deg(double radians) => radians * 180 / math.pi;

  void _listenToCompass() {
    _compass?.cancel();
    _compass = FlutterCompass.events?.listen((event) {
      final raw = event.heading;
      if (raw != null) heading.value = _smooth(heading.value, raw);
      accuracy.value = _accuracyFrom(event.accuracy);
      _checkAlignment();
    });
  }

  /// Low-pass filter on the heading.
  ///
  /// The raw magnetometer stream jitters by several degrees even on a still
  /// phone, and a needle wired straight to it is unusable. This blends each
  /// reading into the last, which costs a little responsiveness and buys a
  /// needle that holds still when the phone does.
  ///
  /// The interpolation goes the short way round the circle, or the needle
  /// spins the long way whenever the heading crosses north.
  double _smooth(double current, double next, {double factor = 0.15}) {
    var delta = next - current;
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    return (current + delta * factor + 360) % 360;
  }

  CompassAccuracy _accuracyFrom(double? raw) {
    if (raw == null) return CompassAccuracy.unknown;
    // flutter_compass reports the Android SENSOR_STATUS scale on Android and
    // a degrees-of-error figure on iOS. Both are "smaller is better" once
    // normalised, so this treats the value as an error estimate in degrees.
    final error = raw.abs();
    if (error <= 0) return CompassAccuracy.unknown;
    if (error <= 15) return CompassAccuracy.high;
    if (error <= 30) return CompassAccuracy.medium;
    return CompassAccuracy.low;
  }

  /// Signed difference between where the phone points and the qibla, in
  /// degrees, negative to the left.
  double get offsetDegrees {
    var delta = qiblaBearing.value - heading.value;
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    return delta;
  }

  bool get isAligned => offsetDegrees.abs() <= alignmentToleranceDegrees;

  QiblaTurn get turn {
    if (isAligned) return QiblaTurn.aligned;
    return offsetDegrees > 0 ? QiblaTurn.right : QiblaTurn.left;
  }

  /// How close to aligned, 0..1. The view uses it to strengthen the needle as
  /// the user turns, so the compass rewards the movement rather than only the
  /// arrival.
  double get closeness {
    final off = offsetDegrees.abs();
    if (off >= 90) return 0;
    return 1 - (off / 90);
  }

  /// Fires a haptic the moment the user comes onto the qibla.
  ///
  /// Only on entering, never on leaving, and never repeatedly — the phone
  /// buzzing every time a hand wobbles across the boundary would be worse
  /// than no feedback at all.
  void _checkAlignment() {
    final aligned = isAligned;
    if (aligned && !_wasAligned) {
      HapticFeedback.mediumImpact();
    }
    _wasAligned = aligned;
  }

  bool get needsCalibration =>
      accuracy.value == CompassAccuracy.low ||
      accuracy.value == CompassAccuracy.unknown;

  @override
  void onClose() {
    _compass?.cancel();
    super.onClose();
  }
}
