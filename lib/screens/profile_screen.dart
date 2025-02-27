import 'package:flutter/material.dart';
import 'package:proyecto_barrion/models/use_model.dart';
import 'package:proyecto_barrion/services/user_info_service.dart';
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
      appBar: AppBar(title: Text("Perfil")),
      body: userInfo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre: ${userInfo!.name}", style: TextStyle(fontSize: 18)),
            Text("Email: ${userInfo!.email}", style: TextStyle(fontSize: 18)),
            Text("Sector: ${userInfo!.sector}", style: TextStyle(fontSize: 18)),
            Text("Admin: ${userInfo!.isAdmin ? 'Sí' : 'No'}", style: TextStyle(fontSize: 18)),
            Text("Creado: ${userInfo!.createdAt}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
