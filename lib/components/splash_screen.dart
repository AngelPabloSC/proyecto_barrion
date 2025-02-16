import 'package:flutter/material.dart';
import 'package:proyecto_barrion/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Función para navegar después de 3 segundos
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Splash por 3 segundos

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Si el usuario está autenticado, lo redirigimos a su Home, si no, a Login
    if (authProvider.isAuthenticated) {
      String route = authProvider.isAdmin ? '/home' : '/home';
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logo.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenidos a Mi Aplicación',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(), // Indicador de carga
          ],
        ),
      ),
    );
  }
}