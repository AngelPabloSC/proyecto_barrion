import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'package:proyecto_barrion/models/use_model.dart';
class UserInfoService {
  static const String endPoint = '/user/info';

  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<UserModel?> fetchUserInfo() async {
    try {
      String? token = await _getAuthToken();
      if (token == null) {
        print("🔑 No se encontró el token de autorización.");
        return null;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse("$domain$endPoint"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['code'] == 'OK') {
          print("✅ Información del usuario recibida exitosamente.");
          return UserModel.fromJson(responseData['data']['user']);
        } else {
          print(
              "❌ Error en la respuesta del servidor: ${responseData['message']}");
          return null;
        }
      } else {
        print("❌ Error al obtener información del usuario: ${response
            .statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al hacer la solicitud: $e");
      return null;
    }
  }
}