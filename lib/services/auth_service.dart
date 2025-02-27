import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'package:proyecto_barrion/models/user_model.dart';

class AuthService {
  static const String _endPointRegister = "/user/register";

  // Función para registrar al usuario
  static Future<String> registerUser(UserModel user) async {
    try {
      // Cuerpo de la solicitud con los datos del usuario
      final body = jsonEncode(user.toJson());

      print("📤 Enviando solicitud de registro...");
      print("➡️ Body: $body");

      // Realizamos la petición POST
      final response = await http.post(
        Uri.parse("$domain$_endPointRegister"),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("📩 Respuesta recibida (Status Code: ${response.statusCode}):");

      // Procesamos la respuesta
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData.containsKey('code') && responseData['code'] == 'OK') {
          print("✅ Registro exitoso: ${responseData['message']}");
          return "Registro exitoso";
        } else {
          print("❌ Error en la respuesta: ${responseData['message']}");
          return "Error: ${responseData['message']}";
        }
      } else {
        print("❌ Error en la respuesta: ${responseData['message']}");
        return "Error: ${responseData['message']}";
      }
    } catch (e) {
      print("🚨 Error al hacer la solicitud: $e");
      return "Error al hacer la solicitud: $e";
    }
  }
}