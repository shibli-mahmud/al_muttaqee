enum PrayerName {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
}

extension PrayerNameX on PrayerName {
  String get storageKey => name;
}

class PrayerTimeEntry {
  final PrayerName name;
  final DateTime time;

  const PrayerTimeEntry({required this.name, required this.time});
}

class DayPrayerTimes {
  final DateTime date;
  final List<PrayerTimeEntry> prayers;
  final PrayerName? current;
  final PrayerName next;
  final DateTime nextTime;

  const DayPrayerTimes({
    required this.date,
    required this.prayers,
    required this.current,
    required this.next,
    required this.nextTime,
  });

  PrayerTimeEntry? entryFor(PrayerName name) {
    for (final p in prayers) {
      if (p.name == name) return p;
    }
    return null;
  }
}

/// Supported calculation methods (Karachi default for Bangladesh).
enum PrayerCalculationMethod {
  karachi,
  muslimWorldLeague,
  egyptian,
  ummAlQura,
  northAmerica,
  dubai,
  qatar,
  kuwait,
  singapore,
  turkiye,
}
