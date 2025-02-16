import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;

  Future<bool> login(String email, String password) async {
    // Simulación de login
    if (email == 'admin@admin.com' && password == 'admin123') {
      _isAuthenticated = true;
      _isAdmin = true;
      notifyListeners();
      return true;
    } else if (email == 'user@user.com' && password == 'user123') {
      _isAuthenticated = true;
      _isAdmin = false;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;
    notifyListeners();
  }
}