// lib/views/auth/register_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para leer el texto de cada campo
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancia de nuestro AuthController (la lógica)
  final AuthController _authController = AuthController();

  // Control para mostrar u ocultar la contraseña con el ojito
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Siempre liberamos los controladores de la memoria al salir de la pantalla
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  /// Función que se dispara al tocar el botón de "Crear cuenta"
  Future<void> _handleRegister() async {
    final success = await _authController.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Verificamos que la pantalla siga visible antes de mostrar mensajes
    if (!mounted) return;

    if (success) {
      // Mensaje de éxito verde
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuenta creada con éxito! Por favor, inicia sesión.'),
          backgroundColor: Color(0xFF008234), // Verde Booking
          duration: Duration(seconds: 2),
        ),
      );
      // Regresamos a la pantalla de Login
      Navigator.pop(context);
    } else {
      // Mensaje de error rojo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.errorMessage ?? 'Error al registrar.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003B95)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              const Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B95), // Azul Booking
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Ingresa tus datos para empezar a reservar',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF003B95),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Campo: Nombre
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Campo: Correo
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'ejemplo@correo.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Campo: Contraseña
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña (mínimo 6 caracteres)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botón de Crear cuenta (escucha al AuthController para mostrar carga)
              ListenableBuilder(
                listenable: _authController,
                builder: (context, child) {
                  return ElevatedButton(
                    onPressed: _authController.isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003B95),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _authController.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Crear cuenta',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Enlace para volver a Login
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(fontSize: 16, color: Color(0xFF003B95)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}