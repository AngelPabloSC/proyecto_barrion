import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:proyecto_barrion/components/NotificationDialog.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? token;

  static Future<void> initializeNotifications(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🔔 Estado del permiso: ${settings.authorizationStatus}");
      token = await _messaging.getToken();

      print('Este es mi token: $token');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Notificación recibida:");
        print("Título: ${message.notification?.title}");
        print("Cuerpo: ${message.notification?.body}");
        print("Datos extra: ${message.data}");

        // Verificar si el context está montado antes de mostrar el diálogo
        if (message.notification != null && context.mounted) {
          showDialog(
            context: context,
            builder: (_) =>
                NotificationDialog(
                  title: message.notification?.title ?? 'Sin título',
                  body: message.notification?.body ?? 'Sin contenido',
                ),
          );
        }
      });
    }
  }
}