import 'package:adhan_dart/adhan_dart.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

class PrayerTimesCalculator {
  CalculationParameters parametersFor(
    PrayerCalculationMethod method, {
    required bool hanafiMadhab,
    Map<PrayerName, int> offsets = const {},
  }) {
    final params = switch (method) {
      PrayerCalculationMethod.karachi => CalculationMethodParameters.karachi(),
      PrayerCalculationMethod.muslimWorldLeague =>
        CalculationMethodParameters.muslimWorldLeague(),
      PrayerCalculationMethod.egyptian => CalculationMethodParameters.egyptian(),
      PrayerCalculationMethod.ummAlQura =>
        CalculationMethodParameters.ummAlQura(),
      PrayerCalculationMethod.northAmerica =>
        CalculationMethodParameters.northAmerica(),
      PrayerCalculationMethod.dubai => CalculationMethodParameters.dubai(),
      PrayerCalculationMethod.qatar => CalculationMethodParameters.qatar(),
      PrayerCalculationMethod.kuwait => CalculationMethodParameters.kuwait(),
      PrayerCalculationMethod.singapore =>
        CalculationMethodParameters.singapore(),
      PrayerCalculationMethod.turkiye => CalculationMethodParameters.turkiye(),
    };

    params.madhab = hanafiMadhab ? Madhab.hanafi : Madhab.shafi;

    if (offsets.isNotEmpty) {
      params.adjustments[Prayer.fajr] = offsets[PrayerName.fajr] ?? 0;
      params.adjustments[Prayer.sunrise] = offsets[PrayerName.sunrise] ?? 0;
      params.adjustments[Prayer.dhuhr] = offsets[PrayerName.dhuhr] ?? 0;
      params.adjustments[Prayer.asr] = offsets[PrayerName.asr] ?? 0;
      params.adjustments[Prayer.maghrib] = offsets[PrayerName.maghrib] ?? 0;
      params.adjustments[Prayer.isha] = offsets[PrayerName.isha] ?? 0;
    }

    return params;
  }

  DayPrayerTimes compute({
    required double latitude,
    required double longitude,
    required DateTime date,
    required PrayerCalculationMethod method,
    required bool hanafiMadhab,
    Map<PrayerName, int> offsets = const {},
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = parametersFor(
      method,
      hanafiMadhab: hanafiMadhab,
      offsets: offsets,
    );

    final times = PrayerTimes(
      coordinates: coords,
      date: date,
      calculationParameters: params,
    );

    final entries = <PrayerTimeEntry>[
      PrayerTimeEntry(name: PrayerName.fajr, time: times.fajr.toLocal()),
      PrayerTimeEntry(name: PrayerName.sunrise, time: times.sunrise.toLocal()),
      PrayerTimeEntry(name: PrayerName.dhuhr, time: times.dhuhr.toLocal()),
      PrayerTimeEntry(name: PrayerName.asr, time: times.asr.toLocal()),
      PrayerTimeEntry(name: PrayerName.maghrib, time: times.maghrib.toLocal()),
      PrayerTimeEntry(name: PrayerName.isha, time: times.isha.toLocal()),
    ];

    final now = DateTime.now();
    PrayerName? current;
    late PrayerName next;
    late DateTime nextTime;

    final salatOnly = entries
        .where((e) => e.name != PrayerName.sunrise)
        .toList(growable: false);

    if (now.isBefore(salatOnly.first.time)) {
      current = null;
      next = salatOnly.first.name;
      nextTime = salatOnly.first.time;
    } else if (!now.isBefore(salatOnly.last.time)) {
      // After Isha — next is tomorrow's Fajr
      current = PrayerName.isha;
      final tomorrow = date.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(
        coordinates: coords,
        date: tomorrow,
        calculationParameters: params,
      );
      next = PrayerName.fajr;
      nextTime = tomorrowTimes.fajr.toLocal();
    } else {
      for (var i = 0; i < salatOnly.length; i++) {
        final entry = salatOnly[i];
        final isLast = i == salatOnly.length - 1;
        final end = isLast
            ? entry.time.add(const Duration(hours: 24))
            : salatOnly[i + 1].time;
        if (!now.isBefore(entry.time) && now.isBefore(end)) {
          current = entry.name;
          if (!isLast) {
            next = salatOnly[i + 1].name;
            nextTime = salatOnly[i + 1].time;
          } else {
            next = PrayerName.fajr;
            nextTime = entry.time.add(const Duration(hours: 24));
          }
          break;
        }
      }
    }

    return DayPrayerTimes(
      date: date,
      prayers: entries,
      current: current,
      next: next,
      nextTime: nextTime,
    );
  }
}
