import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_barrion/components/dreawer.dart';
import 'package:proyecto_barrion/services/notification_service.dart';
import 'package:proyecto_barrion/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para escuchar los cambios de AuthProvider
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Verificamos si el usuario está autenticado
        String userRole = authProvider.isAuthenticated
            ? (authProvider.isAdmin ? 'ADMINISTRADOR' : 'USUARIO')
            : 'PUBLICO';

        // Inicializamos las notificaciones solo una vez
        if (!authProvider.isAuthenticated) {
          NotificationService.initializeNotifications(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bienvenido'),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
          ),
          drawer: CustomDrawer(), // Drawer sin necesidad de pasar userRole
          body: Center(
            child: Text('Rol de usuario: $userRole'),
          ),
        );
      },
    );
  }
}