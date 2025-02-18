import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/sign_in_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    AuthService authService = AuthService();
    var userData = await authService.loginUser(email, password);

    if (userData != null && userData['user'] != null) {
      _isAuthenticated = true;
      _isAdmin = userData['user']['isAdmin'] == true;
      _token = userData['token']; // Guardar el token

      print('rolUsuario: $_isAdmin');
      print('🔑 Token guardado: $_token');

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setBool('is_admin', _isAdmin);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Cargar credenciales al iniciar la app
  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _isAdmin = prefs.getBool('is_admin') ?? false;
    _isAuthenticated = _token != null;

    print('📦 Token cargado: $_token');
    print('👤 Rol cargado: $_isAdmin');

    notifyListeners();
  }

  void logout() async {
    _isAuthenticated = false;
    _isAdmin = false;
    _token = null;

    // Eliminar datos guardados
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('is_admin');

    notifyListeners();
  }
}