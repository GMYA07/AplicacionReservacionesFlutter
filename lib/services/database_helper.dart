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
      onConfigure: (db) async {
        // Habilita el soporte para claves foráneas y borrado en cascada
        await db.execute('PRAGMA foreign_keys = ON');
      },
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
    password TEXT NOT NULL,
    phone TEXT,
    created_at TEXT DEFAULT (datetime('now'))
  );
''');

    // 2. Tabla de Hoteles
    await db.execute('''
  CREATE TABLE hotels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    stars INTEGER DEFAULT 3,
    image_url TEXT,
    created_at TEXT DEFAULT (datetime('now'))
  );
''');

    // 3. Tabla de Habitaciones (Rooms)
    await db.execute('''
  CREATE TABLE rooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hotel_id INTEGER NOT NULL,
    room_type TEXT NOT NULL, -- Ej: 'Simple', 'Doble', 'Suite Deluxe'
    price_per_night REAL NOT NULL,
    capacity INTEGER NOT NULL, -- Cantidad de personas (ej: 2)
    is_available INTEGER DEFAULT 1, -- 1 = disponible, 0 = no disponible
    FOREIGN KEY (hotel_id) REFERENCES hotels (id) ON DELETE CASCADE
  );
''');

    // 4. Tabla de Reservas (Reservations)
    await db.execute('''
  CREATE TABLE reservations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    check_in TEXT NOT NULL,  -- Guardado en formato ISO 'YYYY-MM-DD'
    check_out TEXT NOT NULL, -- Guardado en formato ISO 'YYYY-MM-DD'
    total_price REAL NOT NULL,
    status TEXT DEFAULT 'confirmed', -- 'confirmed', 'cancelled', 'completed'
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE
  );
''');

    // 5. Tabla de Favoritos (Favorites - Relación N:M entre users y hotels)
    await db.execute('''
  CREATE TABLE favorites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    hotel_id INTEGER NOT NULL,
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels (id) ON DELETE CASCADE,
    UNIQUE (user_id, hotel_id)
  );
''');
  }

  // 5. Método auxiliar para cerrar la BD si se necesita
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
