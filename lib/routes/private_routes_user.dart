import 'package:flutter/material.dart';
import '/screens/profile_screen.dart';
import '/screens/history_screen.dart';
import '/screens/cut_register_screen.dart';
import '/screens/home_screen.dart';
final Map<String, WidgetBuilder> userRoutes = {
  '/profile': (context) => PerfilScreen(),
  '/history': (context) => HistorialScreen(),
  '/cut_register': (context) => RegistroCortesScreen(),
  '/home': (context) => HomeScreen(),
};