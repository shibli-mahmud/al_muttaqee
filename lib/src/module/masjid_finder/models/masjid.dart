import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

class Masjid {
  const Masjid({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address = '',
    this.distanceKm = 0,
    this.jamaat = const {},
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final double distanceKm;

  /// Jamaat times for this masjid, as the user has recorded them.
  ///
  /// Empty is a real answer, and the card says so — `জামাতের সময় জানা নেই`
  /// rather than a guess. Getting somebody to the masjid ten minutes late is
  /// worse than admitting the app does not know.
  final Map<PrayerName, JamaatTime> jamaat;

  bool get hasJamaat => jamaat.isNotEmpty;

  /// Rough walking time. Four and a half kilometres an hour is an ordinary
  /// pace and it is only ever shown as an approximation.
  int get walkMinutes => (distanceKm / 4.5 * 60).round().clamp(1, 999);

  Masjid copyWith({
    double? distanceKm,
    Map<PrayerName, JamaatTime>? jamaat,
  }) =>
      Masjid(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        address: address,
        distanceKm: distanceKm ?? this.distanceKm,
        jamaat: jamaat ?? this.jamaat,
      );
}
