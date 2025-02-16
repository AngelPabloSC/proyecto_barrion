import 'package:flutter/material.dart';
import 'package:proyecto_barrion/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  bool _isDarkMode = false;

  ThemeProvider(BuildContext context) {
    _themeData = lightThemeData(context); // Inicializa con el tema claro
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(BuildContext context) {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? darkThemeData(context) : lightThemeData(context);
    notifyListeners();
  }
}