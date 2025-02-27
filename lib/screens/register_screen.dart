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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Registro",
          style: GoogleFonts.oswald(fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xfffDFDF2),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Crea tu cuenta",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value!.isEmpty ? "Ingrese su nombre" : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: "Correo Electrónico",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty ? "Ingrese un correo válido" : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) => value!.length < 6 ? "La contraseña debe tener al menos 6 caracteres" : null,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedSector,
                      decoration: InputDecoration(
                        labelText: "Sector",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.business),
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
                    if (_isLoading)
                      Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4F5A9),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Registrar",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: _inputDecoration(label, icon),
      validator: (value) => value!.isEmpty ? "Ingrese $label" : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.black12),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }
}
