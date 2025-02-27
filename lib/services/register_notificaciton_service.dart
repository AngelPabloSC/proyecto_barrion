import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'package:proyecto_barrion/models/register_notification_Model.dart';

class NotificationService {
  static const String endPoint = '/notifications/send';

  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String> sendNotification(NotificationModel notification) async {
    try {
      String? token = await _getAuthToken();
      if (token == null) {
        print("🔑 No se encontró el token de autorización.");
        return "Error: No se encontró el token de autorización.";
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode(notification.toJson());

      print("📤 Enviando notificación...");
      print("➡️ Headers: $headers");
      print("➡️ Body: $body");

      final response = await http.post(
        Uri.parse("$domain$endPoint"),
        headers: headers,
        body: body,
      );

      print("📩 Respuesta recibida (Status Code: ${response.statusCode}):");

      try {
        final responseData = jsonDecode(response.body);
        print(jsonEncode(responseData)); // Imprime la respuesta en formato JSON

        if (responseData['code'] == "OK") {
          print("✅ Notificación enviada exitosamente.");
          return responseData['message'] ?? "Notificación enviada correctamente.";
        } else {
          print("❌ Error en la respuesta: ${responseData['message']}");
          return "Error: ${responseData['message']}";
        }
      } catch (e) {
        print("⚠️ No se pudo parsear la respuesta como JSON: ${response.body}");
        return "Error desconocido al enviar la notificación.";
      }
    } catch (e) {
      print("🚨 Error al hacer la solicitud: $e");
      return "Error al hacer la solicitud: $e";
    }
  }
}