import 'package:flutter/material.dart';
import 'package:proyecto_barrion/utils/RoleMenuService.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_barrion/theme/theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  final String userRole; // Rol del usuario
  final RoleMenuService roleMenuService = RoleMenuService();

  CustomDrawer({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las opciones del menú según el rol
    final menuData = roleMenuService.getMenuByRole(userRole);
    final menuItems = menuData['menuItems'];

    // Access the ThemeProvider to toggle the theme
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          // Proper DrawerHeader without misalignment
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.centerLeft, // Align to the left
              child: Text(
                'Bienvenido!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          // Renderizar las opciones del menú
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
          // Espaciador para mantener el botón al final
          Spacer(),
          // Botón para cambiar el tema
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Cambiar tema'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}