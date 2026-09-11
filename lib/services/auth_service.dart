// lib/services/auth_service.dart

import '../models/user_model.dart';
import 'database_helper.dart';

/// Servicio modular encargado EXCLUSIVAMENTE de las operaciones
/// de la tabla "users" en SQLite (Registro, Login, Validaciones).
class AuthService {
  // Referencia a nuestro DatabaseHelper para pedir la conexión
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Registra un nuevo usuario en la base de datos.
  /// Retorna el ID generado por SQLite o lanza una excepción si el correo ya existe.
  Future<int> registerUser(UserModel user) async {
    final db = await _dbHelper.database;

    // 1. Verificamos si el correo ya está registrado
    final alreadyExists = await emailExists(user.email);
    if (alreadyExists) {
      throw Exception('El correo electrónico ya se encuentra registrado.');
    }

    // 2. Guardamos el correo en minúsculas para evitar problemas de mayúsculas/minúsculas
    final userToSave = UserModel(
      name: user.name.trim(),
      email: user.email.trim().toLowerCase(),
      password: user.password,
    );

    // 3. Insertamos en SQLite usando toMap()
    return await db.insert('users', userToSave.toMap());
  }

  /// Verifica las credenciales (email y contraseña).
  /// Si coinciden, devuelve el UserModel con sus datos; si no, devuelve null.
  Future<UserModel?> loginUser(String email, String password) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1, // Solo necesitamos 1 resultado
    );

    if (result.isNotEmpty) {
      // Convertimos el mapa de la base de datos al objeto UserModel
      return UserModel.fromMap(result.first);
    }

    return null; // Credenciales incorrectas o usuario no encontrado
  }

  /// Consulta si un correo electrónico ya existe en la base de datos.
  Future<bool> emailExists(String email) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Obtiene un usuario por su ID
  Future<UserModel?> getUserById(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }
}
