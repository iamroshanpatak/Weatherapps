import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/firebase_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final FirebaseService _firebaseService = FirebaseService();

  WeatherModel? _currentWeather;
  bool _isLoading = false;
  String? _error;
  List<String> _favoriteCities = [];

  WeatherModel? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get favoriteCities => _favoriteCities;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> getCurrentLocationWeather() async {
    setLoading(true);
    setError(null);

    try {
      final position = await _locationService.getCurrentLocation();
      final weather = await _weatherService.getCurrentWeather(
        position.latitude,
        position.longitude,
      );

      _currentWeather = weather;

      // Save to Firebase if user is logged in (non-blocking)
      _saveWeatherToFirebase(weather);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> getWeatherByCity(String cityName) async {
    setLoading(true);
    setError(null);

    try {
      final weather = await _weatherService.getWeatherByCity(cityName);
      _currentWeather = weather;

      // Save to Firebase if user is logged in (non-blocking)
      _saveWeatherToFirebase(weather);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // Non-blocking Firebase save operation
  void _saveWeatherToFirebase(WeatherModel weather) {
    Future.microtask(() async {
      try {
        final user = _firebaseService.getCurrentUser();
        if (user != null) {
          await _firebaseService.saveWeatherHistory(user.uid, weather);
        }
      } catch (e) {
        // Firebase not available, continue without saving
        debugPrint('Firebase not available for weather history: $e');
      }
    });
  }

  Future<void> addFavoriteCity(String cityName) async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        try {
          await _firebaseService.saveFavoriteCity(user.uid, cityName);
          if (!_favoriteCities.contains(cityName)) {
            _favoriteCities.add(cityName);
            notifyListeners();
          }
        } catch (e) {
          setError('Failed to add favorite city: $e');
        }
      }
    } catch (e) {
      // Firebase not available, add to local list only
      if (!_favoriteCities.contains(cityName)) {
        _favoriteCities.add(cityName);
        notifyListeners();
      }
    }
  }

  Future<void> removeFavoriteCity(String cityName) async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        try {
          await _firebaseService.removeFavoriteCity(user.uid, cityName);
          _favoriteCities.remove(cityName);
          notifyListeners();
        } catch (e) {
          setError('Failed to remove favorite city: $e');
        }
      }
    } catch (e) {
      // Firebase not available, remove from local list only
      _favoriteCities.remove(cityName);
      notifyListeners();
    }
  }

  Future<void> loadFavoriteCities() async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        try {
          final snapshot = await _firebaseService
              .getFavoriteCities(user.uid)
              .first;
          _favoriteCities = snapshot.docs.map((doc) => doc.id).toList();
          notifyListeners();
        } catch (e) {
          setError('Failed to load favorite cities: $e');
        }
      }
    } catch (e) {
      // Firebase not available, continue with empty list
      debugPrint('Firebase not available for loading favorites: $e');
    }
  }
}
