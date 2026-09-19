import 'dart:async';

import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';
import 'package:al_muttaqee/src/core/utils/utils/notification_service.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/prayer_times_calculator.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

class PrayerTimesController extends BaseController {
  static PrayerTimesController get to => Get.find<PrayerTimesController>();

  final LocationService _locationService;
  final PreferenceManager _prefs;
  final PrayerTimesCalculator _calculator;
  final JamaatTimesRepository _jamaat;

  PrayerTimesController({
    LocationService? locationService,
    PreferenceManager? prefs,
    PrayerTimesCalculator? calculator,
    JamaatTimesRepository? jamaatTimes,
  })  : _locationService = locationService ?? LocationService.to,
        _prefs = prefs ?? PreferenceManagerImpl.to,
        _calculator = calculator ?? PrayerTimesCalculator(),
        _jamaat = jamaatTimes ?? JamaatTimesRepository();

  final dayTimes = Rxn<DayPrayerTimes>();
  final remaining = Duration.zero.obs;
  final hasPermission = false.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  /// The place name shown in the home hero and the আরও settings row.
  final locationLabel = ''.obs;

  final method = PrayerCalculationMethod.karachi.obs;
  final hanafiMadhab = true.obs;
  final offsets = <PrayerName, int>{}.obs;

  /// The user's jamaat times, which cannot be calculated — they belong to a
  /// masjid, not to the sun — so they are read from storage and merged onto
  /// each prayer row.
  final jamaatTimes = <PrayerName, JamaatTime>{}.obs;

  /// The date the নামাজ screen's pager is showing. Today unless the user has
  /// paged away; the hero countdown and the home screen always use today.
  final selectedDate = DateTime.now().obs;

  /// True while the first computation is still running, so screens can show a
  /// skeleton at the final geometry instead of a spinner.
  final isPreparing = true.obs;

  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    _loadSettings().then((_) => refreshTimes());
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _loadSettings() async {
    final methodName = await _prefs.getString(
      AppStrings.spPrayerMethod,
      defaultValue: 'karachi',
    );
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

    jamaatTimes.value = await _jamaat.readAll();
    locationLabel.value = await _prefs.getString(AppStrings.spLocationLabel);
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

  Future<void> setJamaatTime(PrayerName prayer, JamaatTime? time) async {
    if (time == null) {
      jamaatTimes.remove(prayer);
    } else {
      jamaatTimes[prayer] = time;
    }
    jamaatTimes.refresh();
    await _jamaat.set(prayer, time);
  }

  /// The jamaat time for [prayer] on [date], or null if the user has not set
  /// one. Null is a real answer here — `জামাতের সময় জানা নেই` is shown rather
  /// than a guessed time, because a wrong jamaat time makes someone late.
  DateTime? jamaatTimeFor(PrayerName prayer, {DateTime? date}) =>
      jamaatTimes[prayer]?.on(date ?? DateTime.now());

  Future<void> setLocationLabel(String label) async {
    locationLabel.value = label;
    await _prefs.setString(AppStrings.spLocationLabel, label);
  }

  Future<void> refreshTimes() async {
    try {
      final ok = await _locationService.ensurePermission();
      hasPermission.value = ok;
      if (!ok) {
        // Dhaka, so the app is useful the moment it opens even when location
        // has been declined. The নামাজ screen says which location is in use.
        latitude.value = 23.8103;
        longitude.value = 90.4125;
      } else {
        final last = await _locationService.getLastKnownPosition();
        final position = last ?? await _locationService.getCurrentPosition();
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }

      dayTimes.value = _compute(DateTime.now());
      _tick();

      if (Get.isRegistered<NotificationService>()) {
        await NotificationService.to.rescheduleAll();
      }
    } catch (e, st) {
      logger.e('PrayerTimesController.refreshTimes: $e\n$st');
      showErrorMessage(appLocalization.prayerTimesLoadError);
    } finally {
      isPreparing.value = false;
    }
  }

  DayPrayerTimes _compute(DateTime date) => _calculator.compute(
        latitude: latitude.value,
        longitude: longitude.value,
        date: date,
        method: method.value,
        hanafiMadhab: hanafiMadhab.value,
        offsets: Map<PrayerName, int>.from(offsets),
      );

  /// Prayer times for any date, computed on demand.
  ///
  /// The notification service needs a week of these to fill its rolling alarm
  /// window, and the নামাজ date pager needs whichever day the user paged to.
  /// Returns null before the first successful location resolve, when there is
  /// no coordinate to compute from.
  DayPrayerTimes? timesFor(DateTime date) {
    if (latitude.value == 0 && longitude.value == 0) return null;
    return _compute(date);
  }

  void selectDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  void stepDate(int days) =>
      selectDate(selectedDate.value.add(Duration(days: days)));

  bool get isShowingToday {
    final now = DateTime.now();
    final selected = selectedDate.value;
    return selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day;
  }

  /// Times for the date the নামাজ pager is on — today's cached value when the
  /// user has not paged away, so the common case costs nothing.
  DayPrayerTimes? get selectedTimes =>
      isShowingToday ? dayTimes.value : timesFor(selectedDate.value);

  void _tick() {
    final times = dayTimes.value;
    if (times == null) return;

    final now = DateTime.now();
    var diff = times.nextTime.difference(now);
    if (diff.isNegative) diff = Duration.zero;
    remaining.value = diff;

    if (now.isAfter(times.nextTime)) {
      // The window has turned over: recompute so `current`, `next` and the
      // hero theme all move together.
      refreshTimes();
    }
  }

  /// Which time-of-day theme the heroes should wear right now.
  ///
  /// Driven by the prayer window rather than by the clock, so the app's colour
  /// and the user's day stay in step through the year instead of the gradient
  /// turning amber at a fixed hour while the sun is still up.
  DuskWindow get currentWindow {
    final times = dayTimes.value;
    if (times == null) return DuskWindow.day;

    final now = DateTime.now();
    final sunrise = times.entryFor(PrayerName.sunrise)?.time;
    final maghrib = times.entryFor(PrayerName.maghrib)?.time;
    final isha = times.entryFor(PrayerName.isha)?.time;

    if (maghrib != null && isha != null &&
        !now.isBefore(maghrib) && now.isBefore(isha)) {
      return DuskWindow.maghrib;
    }
    if (isha != null && !now.isBefore(isha)) return DuskWindow.isha;
    if (sunrise != null && now.isBefore(sunrise)) return DuskWindow.fajr;
    return DuskWindow.day;
  }

  DuskHeroTheme get heroTheme => DuskHeroTheme.forWindow(currentWindow);

  /// How many of the five windows have opened so far today. The tracker uses
  /// it to say `১৪২ / ১৫০` without counting prayers that have not come round.
  int get prayersElapsedToday {
    final times = dayTimes.value;
    if (times == null) return 0;
    final now = DateTime.now();
    var count = 0;
    for (final prayer in PrayerName.values) {
      if (prayer == PrayerName.sunrise) continue;
      final entry = times.entryFor(prayer);
      if (entry != null && !now.isBefore(entry.time)) count++;
    }
    return count;
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
