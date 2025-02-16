import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/auth_service.dart';
import 'package:proyecto_barrion/models/user_model.dart';
import 'package:proyecto_barrion/services/notification_service.dart';
import 'package:proyecto_barrion/services/sector_service.dart';
import 'package:proyecto_barrion/models/sector_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final SectorService _sectorService = SectorService();

  bool _isLoading = false;
  String? _selectedSector; // Variable para el sector seleccionado
  List<Sector> _sectors = []; // Lista de sectores disponibles

  @override
  void initState() {
    super.initState();
    _fetchSectors();
  }

  /// Obtiene los sectores desde el servicio
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

  /// Registra al usuario con los datos ingresados
  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? deviceToken = NotificationService.token;
      UserModel user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        sector: _selectedSector ?? "", // Solo enviamos el nombre del sector
        deviceToken: deviceToken ?? "",
      );

      try {
        await _authService.registerUser(user);
        _showSuccessDialog();
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registro Exitoso"),
        content: Text("Usuario registrado correctamente."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error en el Registro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Ingrese su nombre" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo Electrónico"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Ingrese un correo válido" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? "La contraseña debe tener al menos 6 caracteres" : null,
              ),
              SizedBox(height: 20),
              // Dropdown para seleccionar sector
              DropdownButtonFormField<String>(
                value: _selectedSector,
                decoration: InputDecoration(labelText: "Sector"),
                items: _sectors.map((Sector sector) {
                  return DropdownMenuItem<String>(
                    value: sector.name,
                    child: Text(sector.name),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedSector = value;
                  });
                },
                validator: (value) => value == null ? "Seleccione un sector" : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _registerUser,
                child: Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}