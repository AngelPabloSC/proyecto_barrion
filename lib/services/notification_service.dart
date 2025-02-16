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
      token = await _messaging.getToken();


      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          showDialog(
            context: context,
            builder: (_) => NotificationDialog(
              title: message.notification?.title ?? 'Sin título',
              body: message.notification?.body ?? 'Sin contenido',
            ),
          );
        }
      });
    }
  }
}
