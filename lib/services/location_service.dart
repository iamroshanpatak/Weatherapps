import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    try {
      // Check if location services are enabled with timeout
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 5));
      
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check and request permissions with timeout
      LocationPermission permission = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 5));
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission()
            .timeout(const Duration(seconds: 10));
        
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Location request timed out. Please try again.');
      }
      throw Exception('Failed to get location: $e');
    }
  }

  Future<String> getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(const Duration(seconds: 10));
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
      }
      return 'Unknown City';
    } catch (e) {
      return 'Unknown City';
    }
  }

  Future<Map<String, double>> getCoordinatesFromCity(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName)
          .timeout(const Duration(seconds: 10));
      
      if (locations.isNotEmpty) {
        return {
          'latitude': locations.first.latitude,
          'longitude': locations.first.longitude,
        };
      }
      throw Exception('City not found');
    } catch (e) {
      throw Exception('Error getting coordinates for city: $e');
    }
  }
}
