import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:proyecto_barrion/components/NotificationDialog.dart';
import 'package:proyecto_barrion/components/dreawer.dart';

class HomeScreen extends StatefulWidget {
  final String userRole; // Rol del usuario

  const HomeScreen({super.key, required this.userRole});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  // Configurar las notificaciones
  Future<void> setupPushNotifications() async {
    final messaging = FirebaseMessaging.instance;

    // Solicitar permisos para las notificaciones
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Manejo de notificaciones cuando la aplicación está en primer plano
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          // Mostrar el AlertDialog solo si hay notificación
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => NotificationDialog(
              title: message.notification?.title ?? 'Sin título',
              body: message.notification?.body ?? 'Sin contenido',
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(), // Ahora funciona con el contexto del Builder
            );
          },
        ),
      ),
      drawer: CustomDrawer(userRole: widget.userRole),
      body: Center(child: Text('Contenido Principal')),
    );
  }
}