import 'package:http/http.dart' as http;
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'dart:convert';
import 'package:proyecto_barrion/providers/auth_provider.dart';
final String _endPointLogin = "/user/login";

class AuthService {
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
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

      print("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody['data']; // Devolvemos solo los datos de usuario
      } else {
        return null;
      }
    } catch (e) {
      print('Error en el login: $e');
      return null;
    }
  }
}