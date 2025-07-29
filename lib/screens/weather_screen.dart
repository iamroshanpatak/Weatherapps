import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/weather_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getCurrentLocationWeather();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchCity() {
    if (_searchController.text.isNotEmpty) {
      context.read<WeatherProvider>().getWeatherByCity(_searchController.text);
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
           colors: [
              Color.fromARGB(255, 87, 115, 167),
              Color.fromARGB(255, 141, 171, 223),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, weatherProvider, child) {
                    if (weatherProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (weatherProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              weatherProvider.error!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                weatherProvider.getCurrentLocationWeather();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final weather = weatherProvider.currentWeather;
                    if (weather == null) {
                      return const Center(
                        child: Text(
                          'No weather data available',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    }

                    return _buildWeatherContent(weather, weatherProvider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Weather App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Row(
                children: [
                  Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.white,
                  ),
                  Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  ),
                ],
              );
            },
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'logout') {
                    authProvider.signOut();
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              onSubmitted: (_) => _searchCity(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              context.read<WeatherProvider>().getCurrentLocationWeather();
            },
            icon: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(weather, WeatherProvider weatherProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCurrentWeather(weather),
          const SizedBox(height: 24),
          _buildWeatherDetails(weather),
          const SizedBox(height: 24),
          _buildFavoriteButton(weather.cityName, weatherProvider),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather(weather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.asset(
              _getWeatherAsset(weather.icon),
              height: 100,
              width: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Feels like ${weather.feelsLike.round()}°C',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(weather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Weather Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Humidity',
              '${weather.humidity.round()}%',
              Icons.water_drop,
            ),
            const Divider(),
            _buildDetailRow(
              'Wind Speed',
              '${weather.windSpeed} m/s',
              Icons.air,
            ),
            const Divider(),
            _buildDetailRow(
              'Updated',
              _formatDateTime(weather.dateTime),
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(
    String cityName,
    WeatherProvider weatherProvider,
  ) {
    final isFavorite = weatherProvider.favoriteCities.contains(cityName);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (isFavorite) {
            weatherProvider.removeFavoriteCity(cityName);
          } else {
            weatherProvider.addFavoriteCity(cityName);
          }
        },
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        label: Text(isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFavorite ? Colors.red : Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getWeatherAsset(String icon) {
    // Map your weather icon codes to asset filenames based on available icons
    switch (icon) {
      case '01d':
      case '01n':
        return 'assets/icons/sun.png';
      case '02d':
      case '02n':
        return 'assets/icons/cloudy.png';
      case '03d':
      case '03n':
        return 'assets/icons/cloudy (1).png';
      case '04d':
      case '04n':
        return 'assets/icons/cloudy (2).png';
      case '09d':
      case '09n':
        return 'assets/icons/rain.png';
      case '10d':
      case '10n':
        return 'assets/icons/rain.png';
      case '11d':
      case '11n':
        return 'assets/icons/weather.png'; // fallback for thunderstorm
      case '13d':
      case '13n':
        return 'assets/icons/weather.png'; // fallback for snow
      case '50d':
      case '50n':
        return 'assets/icons/weather.png'; // fallback for mist
      default:
        return 'assets/icons/weather.png'; // fallback for unknown
    }
  }
}
