import 'package:flutter/material.dart';
import 'package:proyecto_barrion/models/register_notification_Model.dart';
import 'package:proyecto_barrion/services/register_notificaciton_service.dart';
import 'package:proyecto_barrion/services/sector_service.dart';
import 'package:proyecto_barrion/models/sector_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RegistroCortesScreen extends StatefulWidget {
  @override
  _RegistroCortesScreenState createState() => _RegistroCortesScreenState();
}

class _RegistroCortesScreenState extends State<RegistroCortesScreen> {
  final TextEditingController messageController = TextEditingController();
  final SectorService _sectorService = SectorService();

  String? _selectedSector;
  String? _selectedService;
  List<Sector> _sectors = [];
  final List<String> _services = ["Agua", "Luz"];

  @override
  void initState() {
    super.initState();
    _fetchSectors();
  }

  void _fetchSectors() async {
    try {
      List<Sector> sectors = await _sectorService.getAllSectors();
      setState(() {
        _sectors = sectors;
      });
    } catch (e) {
      print("Error al obtener sectores: $e");
    }
  }

  void _showMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _sendNotification() async {
    if (_selectedSector == null || _selectedService == null) {
      _showMessage("Seleccione un sector y un servicio", false);
      return;
    }

    final notification = NotificationModel(
      service: _selectedService!,
      sector: _selectedSector!,
      message: messageController.text,
    );

    String responseMessage = await NotificationService.sendNotification(notification);
    bool isSuccess = responseMessage.contains("Notificación enviada exitosamente");
    _showMessage(responseMessage, isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Cortes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Seleccione el servicio", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(),
              items: _services,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Servicio",
                  hintText: "Seleccione un servicio",
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _selectedService = value;
                });
              },
              selectedItem: _selectedService,
            ),
            SizedBox(height: 16),
            Text("Seleccione el sector", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                showSearchBox: true,
              ),
              items: _sectors.map((sector) => sector.name).toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Sector",
                  hintText: "Seleccione un sector",
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _selectedSector = value;
                });
              },
              selectedItem: _selectedSector,
            ),
            SizedBox(height: 16),
            Text("Mensaje", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mensaje",
                hintText: "Escriba el mensaje",
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendNotification,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Enviar Notificación",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}