import 'package:flutter/material.dart';
import 'package:proyecto_barrion/models/use_model.dart';
import 'package:proyecto_barrion/services/user_info_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  UserModel? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final data = await UserInfoService.fetchUserInfo();
    setState(() {
      userInfo = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Perfil de Usuario",
          style: GoogleFonts.oswald(fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xfffDFDF2),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow.shade50, Colors.yellow.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: userInfo == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 100, color: Colors.black12),
                    SizedBox(height: 16),
                    Text(userInfo!.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(userInfo!.email, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                    Divider(height: 30, thickness: 1),
                    _buildInfoRow("Sector", userInfo!.sector),
                    _buildInfoRow("Admin", userInfo!.isAdmin ? 'Sí' : 'No'),
                    _buildInfoRow("Creado", userInfo!.createdAt),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
