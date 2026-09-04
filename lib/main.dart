import 'package:flutter/material.dart';
//Importamos la vista de login
import 'views/auth/login_screen.dart';

void main() {
  runApp(const MiAppBooking());
}

class MiAppBooking extends StatelessWidget {
  const MiAppBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Hoteles',
      debugShowCheckedModeBanner: false,
      //Tema global
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003B95)),
        useMaterial3: true, //Para el uso moderno de Andriod y IOS
      ),

      //Ruta inicial
      home: const LoginScreen(),
      
    );
  }
}
