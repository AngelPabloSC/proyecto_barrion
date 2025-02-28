import 'package:flutter/material.dart';
import 'package:proyecto_barrion/models/register_notification_Model.dart';
import 'package:proyecto_barrion/services/register_notificaciton_service.dart';
import 'package:proyecto_barrion/services/sector_service.dart';
import 'package:proyecto_barrion/models/sector_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:google_fonts/google_fonts.dart';

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
    bool isSuccess = responseMessage.contains("Notificación enviada exitosamente");
    _showMessage(responseMessage, isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Registro de Cortes",
          style: GoogleFonts.oswald(fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xfffDFDF2),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDropdown("Seleccione el servicio", _services, _selectedService, (value) {
                  setState(() {
                    _selectedService = value;
                  });
                }),
                SizedBox(height: 16),
                _buildDropdown("Seleccione el sector", _sectors.map((s) => s.name).toList(), _selectedSector, (value) {
                  setState(() {
                    _selectedSector = value;
                  });
                }, showSearchBox: true),
                SizedBox(height: 16),
                _buildTextField("Mensaje", messageController),
                SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem, Function(String?) onChanged, {bool showSearchBox = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // <-- Asegura alineación central
      children: [
        Center( // <-- Envuelve el texto en Center
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // <-- Asegura que el texto esté centrado
          ),
        ),
        SizedBox(height: 8),
        DropdownSearch<String>(
          popupProps: showSearchBox ? PopupProps.dialog(showSearchBox: true) : PopupProps.menu(),
          items: items,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: label,
              hintText: "Seleccione una opción",
            ),
          ),
          onChanged: onChanged,
          selectedItem: selectedItem,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // <-- Cambia a 'center'
      children: [
        Center( // <-- Asegura que el texto esté centrado
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            labelText: label,
            hintText: "Escriba su mensaje",
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _sendNotification,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            "Enviar Notificación",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4F5A9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}