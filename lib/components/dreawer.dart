import 'package:flutter/material.dart';
import 'package:proyecto_barrion/models/use_model.dart';
import 'package:proyecto_barrion/services/user_info_service.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_barrion/utils/RoleMenuService.dart';
import 'package:proyecto_barrion/theme/theme_provider.dart';
import 'package:proyecto_barrion/providers/auth_provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final roleMenuService = RoleMenuService();
    String userRole = authProvider.isAuthenticated
        ? (authProvider.isAdmin ? 'ADMINISTRADOR' : 'USUARIO')
        : 'PUBLICO';

    final menuData = roleMenuService.getMenuByRole(userRole);
    final menuItems = menuData['menuItems'];

    final themeProvider = Provider.of<ThemeProvider>(context);

    String initials = userInfo != null && userInfo!.name.isNotEmpty
        ? userInfo!.name.substring(0, 2).toUpperCase()
        : "?";

    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2, // Proporcional a la altura de la pantalla
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow.shade50, Colors.yellow.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: authProvider.isAuthenticated && userInfo != null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Text(
                      initials,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userInfo!.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userInfo!.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
                  : Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Aquí se agregan los elementos del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var item in menuItems)
                  ListTile(
                    leading: Icon(Icons.arrow_right, color: Colors.black),
                    title: Text(
                      item['name'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, item['route']);
                    },
                  ),
              ],
            ),
          ),

          // Separador
          Divider(color: Colors.black),

          // Agregar un espacio entre el menú y los controles de configuración
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  title: Text('Modo oscuro', style: TextStyle(fontSize: 16, color: Colors.black)),
                  leading: Icon(Icons.brightness_6, color: Colors.black45),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(context);
                    },
                  ),
                ),
                if (authProvider.isAuthenticated)
                  ListTile(
                    title: Text('Cerrar sesión', style: TextStyle(fontSize: 16, color: const Color(0xD5974A4A))),
                    leading: Icon(Icons.exit_to_app, color: const Color(0xD5974A4A)),
                    onTap: () {
                      authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
              ],
            ),
          ),

          SizedBox(height: 10), // Espacio final para separación
        ],
      ),
    );
  }
}