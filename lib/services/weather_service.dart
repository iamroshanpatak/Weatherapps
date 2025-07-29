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
      print('Fetching weather for coordinates: $latitude, $longitude');
      final response = await http.get(url);

      print('Weather API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(
          'Weather data received: ${jsonData['name']} - ${jsonData['main']['temp']}°C',
        );
        return WeatherModel.fromJson(jsonData);
      } else {
        print('Weather API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather service error: $e');
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<WeatherModel> getWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric',
    );

    try {
      print('Fetching weather for city: $cityName');
      final response = await http.get(url);

      print('Weather API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(
          'Weather data received: ${jsonData['name']} - ${jsonData['main']['temp']}°C',
        );
        return WeatherModel.fromJson(jsonData);
      } else {
        print('Weather API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather service error: $e');
      throw Exception('Error fetching weather data: $e');
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return '${ApiConfig.weatherIconBaseUrl}/$iconCode@2x.png';
  }
}
