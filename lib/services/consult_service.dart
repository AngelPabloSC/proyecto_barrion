import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'package:proyecto_barrion/models/consul_model.dart'; // Asegúrate de que el modelo esté en la ruta correcta

class ConsultService {
  static const String _endPoint = '/notifications/search';

  // Método para obtener el token de autorización
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print("🔑 Token obtenido: $token");
    return token;
  }

  // Método para obtener los cortes de luz o agua para un sector
  static Future<List<Outage>?> getOutages(String sector) async {
    print("sectoresllegando${sector}");
    try {
      print("📡 Iniciando solicitud de cortes para el sector: $sector");

      String? token = await _getAuthToken();
      if (token == null) {
        print("❌ No se encontró el token de autorización. Cancelando solicitud.");
        return null;
      }

      final url = Uri.parse("$domain$_endPoint");
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };

      // Datos a enviar en el cuerpo (body)
      var body = jsonEncode({
        "sector": sector,  // Aquí pasas el sector como parte del cuerpo
      });

      print("📤 Enviando petición POST a: $url");
      print("📌 Headers: $headers");
      print("📌 Body: $body");

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print("📥 Respuesta recibida - Código de estado: ${response.statusCode}");
      print("📥 Respuesta completa: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        OutageResponse outageResponse = OutageResponse.fromJson(responseBody);

        print("✅ Datos de cortes obtenidos correctamente:");
        outageResponse.data.upcomingOutages.forEach((outage) {
          print("🛑 Servicio: ${outage.service}, Sector: ${outage.sector}, "
              "Mensaje: ${outage.message}, Fecha: ${outage.scheduledDateTime}");
        });

        return outageResponse.data.upcomingOutages;
      } else {
        print("❌ Error en la petición. Código de estado: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🚨 Error en ConsultService: $e");
      return null;
    }
  }
}