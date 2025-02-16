import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:proyecto_barrion/components/NotificationDialog.dart';

class DialogExample extends StatefulWidget {
  const DialogExample({super.key});

  @override
  _DialogExampleState createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
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
    return Center(
      child: Text('Esperando notificaciones...'),
    );
  }
}