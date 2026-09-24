// lib/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Controlador que maneja la lógica de autenticación (Login, Registro y Sesión).
/// Extiende de ChangeNotifier para notificar a las pantallas cuando cambia el estado
/// (por ejemplo: cuando empieza a cargar o cuando ocurre un error).
class AuthController extends ChangeNotifier {
  // Servicio que interactúa directamente con SQLite
  final AuthService _authService = AuthService();

  // Estados internos
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  // Getters para que las vistas puedan leer el estado de forma segura
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Método para registrar un nuevo usuario
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    // 1. Validaciones básicas antes de consultar la base de datos
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Por favor, completa los campos obligatorios.';
      notifyListeners();
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _errorMessage = 'Por favor, ingresa un correo electrónico válido.';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
      notifyListeners();
      return false;
    }

    final cleanPhone = phone?.trim();
    if (cleanPhone != null && cleanPhone.isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9+\s\-()]{7,20}$');
      if (!phoneRegex.hasMatch(cleanPhone)) {
        _errorMessage = 'Por favor, ingresa un número de teléfono válido.';
        notifyListeners();
        return false;
      }
    }

    // 2. Activamos el estado de carga
    _setLoading(true);
    _errorMessage = null;

    try {
      final newUser = UserModel(
        name: name.trim(),
        email: email.trim(),
        password: password,
        phone: cleanPhone?.isNotEmpty == true ? cleanPhone : null,
      );

      // Guardamos en SQLite a través del servicio
      await _authService.registerUser(newUser);

      _setLoading(false);
      return true; // Registro exitoso
    } catch (e) {
      // Capturamos el error (ej: si el correo ya estaba registrado)
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Método para iniciar sesión
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // 1. Validaciones básicas
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Por favor, completa todos los campos.';
      notifyListeners();
      return false;
    }

    // 2. Activamos el estado de carga
    _setLoading(true);
    _errorMessage = null;

    try {
      // Consultamos a SQLite a través del servicio
      final user = await _authService.loginUser(email, password);

      if (user == null) {
        _errorMessage = 'Correo o contraseña incorrectos.';
        _setLoading(false);
        return false;
      }

      // Guardamos el usuario autenticado
      _currentUser = user;
      _setLoading(false);
      return true; // Inicio de sesión exitoso
    } catch (e) {
      _errorMessage = 'Ocurrió un error al intentar iniciar sesión.';
      _setLoading(false);
      return false;
    }
  }

  /// Cierra la sesión activa y limpia los datos
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpia cualquier mensaje de error pendiente
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Función auxiliar para cambiar el estado de carga y notificar a la vista
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
