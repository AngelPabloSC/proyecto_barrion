import 'package:flutter/material.dart';
import 'package:proyecto_barrion/utils/RoleMenuService.dart';

class CustomDrawer extends StatelessWidget {
  final String userRole; // Rol del usuario
  final RoleMenuService roleMenuService = RoleMenuService();

  CustomDrawer({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las opciones del menú según el rol
    final menuData = roleMenuService.getMenuByRole(userRole);
    final menuItems = menuData['menuItems'];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Bienvenido!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Renderizar las opciones del menú
          for (var item in menuItems)
            ListTile(
              title: Text(item['name']),
              onTap: () {
                Navigator.pushNamed(context, item['route']);
              },
            ),
        ],
      ),
    );
  }
}