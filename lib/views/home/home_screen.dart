// lib/views/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';

/// Pantalla temporal y simple de bienvenida para verificar
/// que el inicio de sesión y el registro funcionan correctamente.
class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF003B95), // Azul oficial Booking
        automaticallyImplyLeading: false, // Quita la flecha de atrás automática
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Color(0xFF008234), // Verde de confirmación
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Sesión iniciada con éxito!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Bienvenido(a), ${user.name}',
                style: const TextStyle(fontSize: 18, color: Color(0xFF003B95)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                user.email,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Botón simple de Cerrar sesión
              ElevatedButton.icon(
                onPressed: () {
                  // Regresamos a la pantalla de Login y limpiamos el historial de navegación
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
