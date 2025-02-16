import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_barrion/models/sector_model.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';

class SectorService {
  final String _endPointSector = "/sector/getAllSectors";

  Future<List<Sector>> getAllSectors() async {
    try {
      var response = await http.post(
        Uri.parse("$domain$_endPointSector"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({}), // Body vacío si el servidor lo requiere
      );

      print("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Acceder a la lista de sectores dentro de "data"
        List<dynamic> sectorList = jsonResponse["data"]["sectors"];

        return sectorList.map((sector) => Sector.fromJson(sector)).toList();
      } else {
        print('Error en la solicitud: Código ${response.statusCode}');
        throw Exception('Error al obtener sectores: Código ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getAllSectors: $e');
      throw Exception('Error en getAllSectors: $e');
    }
  }
}