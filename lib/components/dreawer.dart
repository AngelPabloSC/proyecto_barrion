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

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Bienvenido!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var item in menuItems)
                  ListTile(
                    title: Text(item['name']),
                    onTap: () {
                      Navigator.pushNamed(context, item['route']);
                    },
                  ),
              ],
            ),
          ),
          Spacer(),
          ListTile(
            title: Text('Cerrar sesión'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}