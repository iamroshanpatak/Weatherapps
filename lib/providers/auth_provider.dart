import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    try {
      _auth.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Auth initialization failed: $e');
      // Continue without authentication
    }
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    setError(null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      setError('Sign in failed: $e');
      throw Exception('Sign in failed: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    setLoading(true);
    setError(null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      setError('Sign in failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    setError(null);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      setError('Sign up failed: $e');
      throw Exception('Sign up failed: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password) async {
    setLoading(true);
    setError(null);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      setError('Sign up failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
