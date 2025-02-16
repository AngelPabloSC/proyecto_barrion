import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

import '/screens/home_screen.dart';
final Map<String, WidgetBuilder> publicRoutes = {
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/home': (context) => HomeScreen(userRole: 'PUBLICO'),
};