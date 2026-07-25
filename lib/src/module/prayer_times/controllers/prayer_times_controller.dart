import 'dart:async';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/prayer_times_calculator.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';
import 'package:get/get.dart';

class PrayerTimesController extends BaseController {
  static PrayerTimesController get to => Get.find<PrayerTimesController>();

  final LocationService _locationService;
  final PreferenceManager _prefs;
  final PrayerTimesCalculator _calculator;

  PrayerTimesController({
    LocationService? locationService,
    PreferenceManager? prefs,
    PrayerTimesCalculator? calculator,
  })  : _locationService = locationService ?? LocationService.to,
        _prefs = prefs ?? PreferenceManagerImpl.to,
        _calculator = calculator ?? PrayerTimesCalculator();

  final dayTimes = Rxn<DayPrayerTimes>();
  final remaining = Duration.zero.obs;
  final hasPermission = false.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  final method = PrayerCalculationMethod.karachi.obs;
  final hanafiMadhab = true.obs;
  final offsets = <PrayerName, int>{}.obs;

  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    _loadSettings().then((_) => refreshTimes());
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _loadSettings() async {
    final methodName =
        await _prefs.getString(AppStrings.spPrayerMethod, defaultValue: 'karachi');
    method.value = PrayerCalculationMethod.values.firstWhere(
      (m) => m.name == methodName,
      orElse: () => PrayerCalculationMethod.karachi,
    );
    hanafiMadhab.value =
        await _prefs.getBool(AppStrings.spPrayerHanafi, defaultValue: true);

    for (final prayer in PrayerName.values) {
      if (prayer == PrayerName.sunrise) continue;
      final key = '${AppStrings.spPrayerOffsetPrefix}.${prayer.name}';
      offsets[prayer] = await _prefs.getInt(key, defaultValue: 0);
    }
  }

  Future<void> setMethod(PrayerCalculationMethod value) async {
    method.value = value;
    await _prefs.setString(AppStrings.spPrayerMethod, value.name);
    await refreshTimes();
  }

  Future<void> setHanafiMadhab(bool value) async {
    hanafiMadhab.value = value;
    await _prefs.setBool(AppStrings.spPrayerHanafi, value);
    await refreshTimes();
  }

  Future<void> setOffset(PrayerName prayer, int minutes) async {
    offsets[prayer] = minutes;
    offsets.refresh();
    await _prefs.setInt(
      '${AppStrings.spPrayerOffsetPrefix}.${prayer.name}',
      minutes,
    );
    await refreshTimes();
  }

  Future<void> refreshTimes() async {
    try {
      showLoading();
      final ok = await _locationService.ensurePermission();
      hasPermission.value = ok;
      if (!ok) {
        // Fallback: Dhaka for offline demo when GPS unavailable
        latitude.value = 23.8103;
        longitude.value = 90.4125;
      } else {
        final last = await _locationService.getLastKnownPosition();
        final position = last ?? await _locationService.getCurrentPosition();
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }

      dayTimes.value = _calculator.compute(
        latitude: latitude.value,
        longitude: longitude.value,
        date: DateTime.now(),
        method: method.value,
        hanafiMadhab: hanafiMadhab.value,
        offsets: Map<PrayerName, int>.from(offsets),
      );
      _tick();
    } catch (e, st) {
      logger.e('PrayerTimesController.refreshTimes: $e\n$st');
      showErrorMessage(appLocalization.prayerTimesLoadError);
    } finally {
      hideLoading();
    }
  }

  void _tick() {
    final times = dayTimes.value;
    if (times == null) return;
    final now = DateTime.now();
    var diff = times.nextTime.difference(now);
    if (diff.isNegative) diff = Duration.zero;
    remaining.value = diff;

    // Recompute when next prayer passes
    if (now.isAfter(times.nextTime)) {
      refreshTimes();
    }
  }

  String formatRemaining(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}:'
          '${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
