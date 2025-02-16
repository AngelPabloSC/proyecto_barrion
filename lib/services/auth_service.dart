import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_barrion/models/user_model.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';

class AuthService {
  final String _endPointRegister = "/user/register";

  // Función para manejar las respuestas HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Verificamos si la respuesta del backend es exitosa según el campo "code"
        if (responseBody['code'] == 'OK') {
          return responseBody['data'];  // Devolver datos del usuario
        } else {
          // Si el 'code' no es OK, mostramos un mensaje de error
          String errorMessage = responseBody['message'] ?? 'Error desconocido';
          throw Exception('Error al registrar el usuario: $errorMessage');
        }
      } else {
        // Si el status code no es 200, devolvemos el mensaje de error
        String errorMessage = responseBody['message'] ?? 'Error desconocido';
        throw Exception('Error al registrar el usuario: $errorMessage');
      }
    } catch (e) {
      // Si hay un error al procesar la respuesta
      throw Exception('Error al procesar la respuesta: $e');
    }
  }

  // Función para registrar al usuario
  Future<void> registerUser(UserModel user) async {
    try {
      // Realizamos la petición POST
      var response = await http.post(
        Uri.parse("$domain$_endPointRegister"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      // Procesamos la respuesta
      var responseData = await _handleResponse(response);

      // Si la respuesta es exitosa, imprimimos el nombre del usuario registrado
      print('Registro exitoso: ${responseData['user']['name']}');
    } on http.ClientException catch (e) {
      // Manejo específico de errores de cliente HTTP (por ejemplo, problemas de red)
      print('Error de conexión: $e');
      throw Exception('No se pudo conectar al servidor. Intente nuevamente.');
    } on FormatException catch (e) {
      // Manejo de errores de formato en la respuesta
      print('Error de formato: $e');
      throw Exception('La respuesta del servidor tiene un formato incorrecto.');
    } catch (e) {
      // Capturamos cualquier otra excepción y la lanzamos con un mensaje claro
      print('Error desconocido: $e');
      throw Exception('Error en el registro: $e');
    }
  }
}