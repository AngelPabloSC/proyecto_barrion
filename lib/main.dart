import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_barrion/routes/private_routes_admin.dart';
import 'package:proyecto_barrion/routes/private_routes_user.dart';
import 'package:proyecto_barrion/routes/public_routes.dart';
import 'package:proyecto_barrion/theme/theme_provider.dart';
import 'package:proyecto_barrion/providers/auth_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = AuthProvider();
            authProvider.loadAuthData(); // Carga datos de autenticación
            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider(context)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              String userRole = authProvider.isAuthenticated
                  ? (authProvider.isAdmin ? 'ADMINISTRADOR' : 'USUARIO')
                  : 'PUBLICO';

              return MaterialApp(
                title: 'Notificaciones Push',
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                theme: themeProvider.themeData,
                initialRoute: authProvider.isAuthenticated ? '/home' : '/home',
                routes: {
                  ...publicRoutes,
                  if (userRole == 'ADMINISTRADOR') ...adminRoutes,
                  if (userRole == 'USUARIO') ...userRoutes,
                },
              );
            },
          );
        },
      ),
    );
  }
}