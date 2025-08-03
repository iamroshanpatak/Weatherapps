import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/weather_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('User creation failed: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Firestore methods for saving favorite cities
  Future<void> saveFavoriteCity(String userId, String cityName) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(cityName)
          .set({
        'cityName': cityName,
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Failed to save favorite city: $e');
    }
  }

  Future<void> removeFavoriteCity(String userId, String cityName) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(cityName)
          .delete()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Failed to remove favorite city: $e');
    }
  }

  Stream<QuerySnapshot> getFavoriteCities(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .snapshots();
    } catch (e) {
      throw Exception('Failed to get favorite cities: $e');
    }
  }

  // Save weather history
  Future<void> saveWeatherHistory(String userId, WeatherModel weather) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weather_history')
          .add({
        'cityName': weather.cityName,
        'temperature': weather.temperature,
        'description': weather.description,
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Failed to save weather history: $e');
    }
  }

  Stream<QuerySnapshot> getWeatherHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('weather_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }
}
