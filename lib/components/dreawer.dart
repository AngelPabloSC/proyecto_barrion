import 'package:flutter/material.dart';
import 'package:proyecto_barrion/utils/RoleMenuService.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_barrion/theme/theme_provider.dart';
import 'package:proyecto_barrion/providers/auth_provider.dart';

class CustomDrawer extends StatelessWidget {
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

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Reemplazamos UserAccountsDrawerHeader con un Container personalizado
          Container(
            height: 150, // Altura del encabezado
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow.shade50, Colors.yellow.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.black12),
                  ),
                  SizedBox(height: 10), // Espacio entre la imagen y el texto
                  Text(
                    authProvider.isAuthenticated ? "Usuario" : "Invitado",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5), // Espacio entre el nombre y el correo
                  Text(
                    authProvider.isAuthenticated ? "usuario@email.com" : "No autenticado",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          for (var item in menuItems)
            ListTile(
              leading: Icon(Icons.arrow_right, color: Colors.black),
              title: Text(
                item['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamed(context, item['route']);
              },
            ),

          Divider(color: Colors.black),

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
              title: Text('Cerrar sesión', style: TextStyle(fontSize: 16, color: const Color(0xD5974A4A))),
              leading: Icon(Icons.exit_to_app, color: const Color(0xD5974A4A)),
              onTap: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}