import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';

class NotificationHistoryService {
  static const String endPoint = '/notifications/history';

  // Obtener el token de SharedPreferences
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Enviar la solicitud POST con el token de autorización
  static Future<Map<String, dynamic>?> fetchNotificationHistory() async {
    try {
      // Obtener el token
      String? token = await _getAuthToken();

      if (token == null) {
        print("🔑 No se encontró el token de autorización.");
        return null;  // Devolver null si no se encuentra el token
      }

      // Crear los headers con el token
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse("$domain$endPoint"),
        headers: headers,
      );

      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Verificar el valor de 'code' en la respuesta
        if (responseData['code'] == 'OK') {
          print("✅ Historial de notificaciones recibido exitosamente.");
          return responseData;
        } else {
          // Caso cuando el servidor responde con error (por ejemplo, token inválido)
          print("❌ Error en la respuesta del servidor: ${responseData['message']}");
          return null;
        }
      } else {
        // En caso de error en el status de la respuesta HTTP
        print("❌ Error al obtener historial: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al hacer la solicitud: $e");
      return null;  // En caso de cualquier excepción, retornamos null
    }
  }
}