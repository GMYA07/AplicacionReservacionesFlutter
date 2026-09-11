// lib/services/database_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Clase encargada de abrir la conexión a SQLite y crear las tablas.
/// Utiliza el patrón Singleton para garantizar una única conexión abierta en toda la app.
class DatabaseHelper {
  // 1. Constructor privado y la instancia única
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // 2. Getter para obtener la base de datos (si no existe, la inicializa)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('booking_app.db');
    return _database!;
  }

  // 3. Abre la base de datos en la carpeta segura del celular
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Abre la BD y llama a _createDB la primera vez que se ejecute la app
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // 4. Creación de tablas iniciales
  Future<void> _createDB(Database db, int version) async {
    // Tabla de Usuarios
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // 5. Método auxiliar para cerrar la BD si se necesita
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
