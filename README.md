# Weather App

A beautiful Flutter weather application with Firebase integration, featuring real-time weather data, user authentication, and favorite cities management.

## Features

- 🌤️ **Real-time Weather Data**: Get current weather information for any city
- 📍 **Location Services**: Automatic weather detection based on GPS location
- 🔐 **User Authentication**: Secure login and registration with Firebase Auth
- ❤️ **Favorite Cities**: Save and manage your favorite cities
- 📱 **Modern UI**: Beautiful gradient design with smooth animations
- 🔄 **Offline Support**: Cached weather data for better performance
- 📊 **Weather Details**: Humidity, wind speed, and "feels like" temperature

## Screenshots

The app features a modern design with:
- Login/Registration screen with gradient background
- Main weather screen with current conditions
- Favorites management screen
- Bottom navigation for easy access

## Setup Instructions

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project

### 1. Clone the Repository

```bash
git clone <repository-url>
cd weathers_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication (Email/Password)
4. Enable Firestore Database

#### Configure Firebase for Android

1. Add your Android app to Firebase project
2. Download `google-services.json`
3. Place it in `android/app/` directory

#### Configure Firebase for iOS

1. Add your iOS app to Firebase project
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/` directory

### 4. OpenWeatherMap API Setup

1. Sign up at [OpenWeatherMap](https://openweathermap.org/api)
2. Get your API key
3. Replace `YOUR_API_KEY` in `lib/services/weather_service.dart`

```dart
static const String _apiKey = 'YOUR_ACTUAL_API_KEY';
```

### 5. Location Permissions

#### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to show weather for your current location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to show weather for your current location.</string>
```

### 6. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── models/
│   └── weather_model.dart          # Weather data model
├── providers/
│   ├── auth_provider.dart          # Authentication state management
│   └── weather_provider.dart       # Weather data state management
├── screens/
│   ├── login_screen.dart           # Login/Registration screen
│   ├── home_screen.dart            # Main home screen with navigation
│   ├── weather_screen.dart         # Weather display screen
│   └── favorites_screen.dart       # Favorites management screen
├── services/
│   ├── weather_service.dart        # OpenWeatherMap API service
│   ├── location_service.dart       # GPS and geocoding service
│   └── firebase_service.dart       # Firebase authentication and database
└── main.dart                       # App entry point
```

## Dependencies

- **http**: For API calls to OpenWeatherMap
- **firebase_core**: Firebase core functionality
- **firebase_auth**: User authentication
- **cloud_firestore**: Database for storing user data
- **provider**: State management
- **geolocator**: GPS location services
- **geocoding**: Address to coordinates conversion
- **cached_network_image**: Image caching for weather icons
- **shared_preferences**: Local data storage

## API Integration

The app uses the OpenWeatherMap API to fetch weather data:
- Current weather by coordinates
- Current weather by city name
- Weather icons and descriptions

## Firebase Features

- **Authentication**: Email/password login and registration
- **Firestore**: Store user favorites and weather history
- **Real-time Updates**: Live synchronization of user data

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the repository or contact the development team.

## Future Enhancements

- [ ] 5-day weather forecast
- [ ] Weather notifications
- [ ] Dark/Light theme toggle
- [ ] Weather widgets
- [ ] Multiple language support
- [ ] Weather maps integration
