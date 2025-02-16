import 'package:flutter/material.dart';
class RoleMenuService {
  final Map<String, Map<String, dynamic>> roleMenus = {
    'ADMINISTRADOR': {
      'menuItems': [
        {'id': 1, 'name': 'Perfil', 'route': '/profile', 'icon': Icons.account_circle},
        {'id': 2, 'name': 'Historial', 'route': '/history', 'icon': Icons.history},
        {'id': 3, 'name': 'Consultas', 'route': '/home', 'icon': Icons.search},
        {'id': 4, 'name': 'Registro de Cortes', 'route': '/cut_register', 'icon': Icons.note_add},
      ],
    },
    'USUARIO': {
      'menuItems': [
        {'id': 1, 'name': 'Perfil', 'route': '/profile', 'icon': Icons.account_circle},
        {'id': 2, 'name': 'Historial', 'route': '/history', 'icon': Icons.history},
        {'id': 3, 'name': 'Consultas', 'route': '/home', 'icon': Icons.search},
        {'id': 4, 'name': 'Registro de Cortes', 'route': '/cut_register', 'icon': Icons.note_add},
      ],
    },
    'PUBLICO': {
      'menuItems': [
        {'id': 1, 'name': 'Inicio', 'route': '/home','icon': Icons.account_circle},
        {'id': 2, 'name': 'registro', 'route': '/register','icon': Icons.app_registration},
        {'id': 3, 'name': 'Iniciar Seccion', 'route': '/login','icon': Icons.login},
      ],
    },
  };

  Map<String, dynamic> getMenuByRole(String role) {
    return roleMenus[role] ?? {'menuItems': []};
  }
}