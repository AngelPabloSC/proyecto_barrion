import 'package:http/http.dart' as http;
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'dart:convert';
final String _endPointLogin = "/user/login";

class AuthService {
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    var body = jsonEncode({'email': email, 'password': password});

    try {
      String url = "$domain$_endPointLogin";


      var headers = {"Content-Type": "application/json"};
      var body = jsonEncode({'email': email, 'password': password});

      print("📡 Enviando petición...");
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );



      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody['data'];
      } else {
        print("⚠ Error en la petición: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {

      return null;
    }
  }
}