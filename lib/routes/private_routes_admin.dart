import 'package:flutter/material.dart';
import '/screens/profile_screen.dart';
import '/screens/history_screen.dart';
import '/screens/cut_register_screen.dart';
import '/screens/home_screen.dart';
final Map<String, WidgetBuilder> adminRoutes = {
  '/profile': (context) => PerfilScreen(),
  '/history': (context) => HistorialScreen(),
  '/home': (context) => HomeScreen(userRole: 'ADMIN'),
  '/cut_register': (context) => RegistroCortesScreen(),
};