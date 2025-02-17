import 'package:http/http.dart' as http;
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'dart:convert';
final String _endPointLogin = "/user/login";

class AuthService {
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    print("🔍 AuthService: Intentando login con email: $email");
    var body = jsonEncode({'email': email, 'password': password});
    print("📡 Cuerpo de la solicitud: $body");
    try {
      String url = "$domain$_endPointLogin";
      print("🔗 URL de la petición: $url");

      var headers = {"Content-Type": "application/json"};
      var body = jsonEncode({'email': email, 'password': password});

      print("📡 Enviando petición...");
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print("✅ Respuesta del servidor: ${response.statusCode}");
      print("📄 Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody['data'];
      } else {
        print("⚠ Error en la petición: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error en AuthService: $e");
      return null;
    }
  }
}