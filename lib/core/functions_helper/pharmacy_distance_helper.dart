import 'package:geolocator/geolocator.dart';

const double nearbyPharmacyRadiusKm = 5.0;

bool hasValidCoordinates(double? lat, double? lng) {
  return lat != null && lng != null && (lat != 0.0 || lng != 0.0);
}

double calculateDistanceInKm({
  required double fromLat,
  required double fromLng,
  required double toLat,
  required double toLng,
}) {
  return Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng) / 1000;
}
