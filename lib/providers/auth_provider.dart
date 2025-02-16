import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/sign_in_service.dart';
class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  bool get isAuthenticated => _isAuthenticated;

  bool get isAdmin => _isAdmin;

  Future<bool> login(String email, String password) async {
    print("AuthProvider: Iniciando login con $email");

    AuthService authService = AuthService();
    var userData = await authService.loginUser(email, password);

    print("AuthProvider: Respuesta de loginUser -> $userData");

    if (userData != null) {
      _isAuthenticated = true;
      _isAdmin = userData['role'] == 'admin';
      notifyListeners();
      return true;
    } else {
      print("AuthProvider: Login fallido, userData es null");
      return false;
    }
  }
  void logout() {
    print("AuthProvider: Cerrando sesión...");

    _isAuthenticated = false;
    _isAdmin = false;

    notifyListeners();
  }

}
