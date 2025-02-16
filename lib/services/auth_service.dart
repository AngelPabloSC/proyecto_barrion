import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_barrion/models/user_model.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';
class AuthService {
  final String _endPointRegister = "/user/register";

  Future<void> registerUser(UserModel user) async {
    print("Datos que se envían al servidor: ${jsonEncode(user.toJson())}");
    try {
      var response = await http.post(
        Uri.parse("$domain$_endPointRegister"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );
      // Verificar si la respuesta es exitosa (código 200)
      if (response.statusCode == 200) {
        print('Registro exitoso: ${response.body}');
      } else {
        // Si la respuesta es un error, manejarlo aquí

        var responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Error desconocido';
        print('Error en el servidor: $errorMessage');
        throw Exception('Error en el servidor: $errorMessage');
      }
    } catch (e) {
      print('Error en el registro: $e');
      throw Exception('Error en el registro: $e');
    }
  }
}