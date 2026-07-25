class Masjid {
  const Masjid({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address = '',
    this.distanceKm = 0,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final double distanceKm;

  Masjid withDistance(double value) => Masjid(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        address: address,
        distanceKm: value,
      );
}
