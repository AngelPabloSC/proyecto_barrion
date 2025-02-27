import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/auth_service.dart';
import 'package:proyecto_barrion/models/user_model.dart';
import 'package:proyecto_barrion/services/notification_service.dart';
import 'package:proyecto_barrion/services/sector_service.dart';
import 'package:proyecto_barrion/models/sector_model.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String? _selectedSector;
  List<Sector> _sectors = [];

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

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String? deviceToken = NotificationService.token;
      UserModel user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        sector: _selectedSector ?? "",
        deviceToken: deviceToken ?? "",
      );

      try {
        var responseMessage = await AuthService.registerUser(user);

        _showDialog(
          responseMessage == "Registro exitoso" ? "Registro Exitoso" : "Fallo en el Registro",
          responseMessage == "Registro exitoso"
              ? "Usuario registrado correctamente."
              : responseMessage,
          responseMessage == "Registro exitoso" ? Colors.green : Colors.red,
        );
      } catch (e) {
        _showDialog("Error en el Registro", "Error al registrar el usuario: ${e.toString()}", Colors.red);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Ocultar teclado al tocar fuera
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Crear Cuenta", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: "Nombre", border: OutlineInputBorder()),
                          validator: (value) => value!.isEmpty ? "Ingrese su nombre" : null,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value!.isEmpty ? "Ingrese un correo válido" : null,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) => value!.length < 6 ? "La contraseña debe tener al menos 6 caracteres" : null,
                        ),
                        SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: _selectedSector,
                          decoration: InputDecoration(
                            labelText: "Sector",
                            border: OutlineInputBorder(),
                          ),
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
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Registrar", style: GoogleFonts.poppins(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}