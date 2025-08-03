import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config/api_config.dart';

class WeatherService {
  static const String _apiKey = ApiConfig.openWeatherMapApiKey;
  static const String _baseUrl = ApiConfig.openWeatherMapBaseUrl;

  Future<WeatherModel> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      // Fetching weather for coordinates: $latitude, $longitude
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timed out. Please check your internet connection.');
        },
      );

      // Weather API response status: ${response.statusCode}

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Weather data received: ${jsonData['name']} - ${jsonData['main']['temp']}°C
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your configuration.');
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else {
        // Weather API error: ${response.statusCode} - ${response.body}
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Weather service error: $e
      if (e.toString().contains('timeout')) {
        throw Exception('Request timed out. Please check your internet connection.');
      }
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<WeatherModel> getWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric',
    );

    try {
      // Fetching weather for city: $cityName
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timed out. Please check your internet connection.');
        },
      );

      // Weather API response status: ${response.statusCode}

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Weather data received: ${jsonData['name']} - ${jsonData['main']['temp']}°C
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your configuration.');
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the spelling.');
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else {
        // Weather API error: ${response.statusCode} - ${response.body}
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Weather service error: $e
      if (e.toString().contains('timeout')) {
        throw Exception('Request timed out. Please check your internet connection.');
      }
      throw Exception('Error fetching weather data: $e');
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return '${ApiConfig.weatherIconBaseUrl}/$iconCode@2x.png';
  }
}
