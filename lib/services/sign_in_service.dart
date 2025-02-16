
import 'package:http/http.dart' as http;
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'dart:convert';
final String _endPointLogin= "/user/login";
class AuthService {
  // Función de login
  Future<bool> loginUser(String email, String password) async {
    print("Datos que se envían al servidor (login): email: $email, password: $password");
    try {
      var response = await http.post(
        Uri.parse("$domain$_endPointLogin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      // Imprimir la respuesta completa del servidor
      print("Respuesta del servidor: ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String token = responseBody['token'] ?? ''; // Asumimos que el servidor responde con un token
        print('Login exitoso, token: $token');
        return true;
      } else {
        var responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Error desconocido';
        print('Error en el servidor: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Error en el login: $e');
      throw Exception('Error en el login: $e');
    }
  }
}