import 'package:flutter/material.dart';

// Removed Firebase imports and service since login is not needed

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider();

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<bool> signUp(String email, String password) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}
