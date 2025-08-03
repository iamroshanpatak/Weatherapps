import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'firebase_options.dart';
import 'screens/gallery_camera_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with timeout and error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        // Continue without Firebase if timeout occurs
        debugPrint('Firebase initialization timed out, continuing without Firebase');
        return Firebase.app();
      },
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    // Continue without Firebase if initialization fails
    debugPrint('Firebase initialization failed: $e');
    debugPrint('Continuing without Firebase for development...');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return MaterialApp(
                title: 'Weather App',
                theme: themeProvider.lightTheme,
                darkTheme: themeProvider.darkTheme,
                themeMode: themeProvider.themeMode,
                debugShowCheckedModeBanner: false,
                home: authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
                routes: {
                  '/login': (context) => const LoginScreen(),
                  '/signup': (context) => const SignupScreen(),
                  '/home': (context) => const HomeScreen(),
                  '/weather': (context) => const HomeScreen(),
                  '/gallery_camera': (context) => const GalleryCameraScreen(),
                  '/google_map': (context) => const GoogleMapScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240), // Example: Kathmandu
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (controller) {
          // Map controller created
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
