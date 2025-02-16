import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/sign_in_service.dart';
class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  bool get isAuthenticated => _isAuthenticated;

  bool get isAdmin => _isAdmin;

  Future<bool> login(String email, String password) async {


    AuthService authService = AuthService();
    var userData = await authService.loginUser(email, password);

    if (userData != null) {
      _isAuthenticated = true;
      _isAdmin = userData['isAdmin'] == true;
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
