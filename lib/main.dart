import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:proyecto_barrion/routes/private_routes_admin.dart';
import 'package:proyecto_barrion/routes/private_routes_user.dart';
import 'package:proyecto_barrion/routes/public_routes.dart';
import 'package:proyecto_barrion/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

// Manejo de notificaciones en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Notificación en segundo plano: ${message.notification?.title}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String userRole = 'PUBLICO'; //

    return MaterialApp(
      title: 'Notificaciones Push',
      navigatorKey: navigatorKey, // Usamos la clave global aquí
      initialRoute: '/',
      routes: {
        ...publicRoutes,
        if (userRole == 'ADMIN') ...adminRoutes,
        if (userRole == 'USER') ...userRoutes,
      },
      home: HomeScreen(userRole: userRole),

    );
  }
}