// lib/services/hotel_service.dart

import '../models/hotel_model.dart';
import '../models/room_model.dart';
import 'database_helper.dart';

/// Servicio encargado de consultar información de hoteles y habitaciones
/// directamente en la base de datos local SQLite.
class HotelService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Obtiene los hoteles desde SQLite que cuenten con habitaciones disponibles (`is_available = 1`).
  /// Si se proporciona [cityQuery], filtra por coincidencia en ciudad o nombre del hotel.
  Future<List<HotelModel>> getAvailableHotels({String? cityQuery}) async {
    final db = await _dbHelper.database;

    String sql = '''
      SELECT 
        h.id, 
        h.name, 
        h.description, 
        h.address, 
        h.city, 
        h.stars, 
        h.image_url, 
        h.created_at,
        MIN(r.price_per_night) AS min_price,
        COUNT(r.id) AS total_rooms,
        SUM(CASE WHEN r.is_available = 1 THEN 1 ELSE 0 END) AS available_rooms
      FROM hotels h
      LEFT JOIN rooms r ON h.id = r.hotel_id
    ''';

    List<dynamic> arguments = [];

    if (cityQuery != null && cityQuery.trim().isNotEmpty) {
      final queryParam = '%${cityQuery.trim().toLowerCase()}%';
      sql += '''
        WHERE LOWER(h.city) LIKE ? OR LOWER(h.name) LIKE ?
      ''';
      arguments = [queryParam, queryParam];
    }

    sql += '''
      GROUP BY h.id
      HAVING available_rooms > 0
      ORDER BY h.stars DESC, min_price ASC
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(sql, arguments);

    return results.map((map) => HotelModel.fromMap(map)).toList();
  }

  /// Obtiene un hotel específico por su ID junto con su precio mínimo
  Future<HotelModel?> getHotelById(int id) async {
    final db = await _dbHelper.database;

    const sql = '''
      SELECT 
        h.id, 
        h.name, 
        h.description, 
        h.address, 
        h.city, 
        h.stars, 
        h.image_url, 
        h.created_at,
        MIN(r.price_per_night) AS min_price
      FROM hotels h
      LEFT JOIN rooms r ON h.id = r.hotel_id AND r.is_available = 1
      WHERE h.id = ?
      GROUP BY h.id
      LIMIT 1
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(sql, [id]);

    if (results.isNotEmpty) {
      return HotelModel.fromMap(results.first);
    }
    return null;
  }

  /// Obtiene las habitaciones disponibles de un hotel
  Future<List<RoomModel>> getRoomsByHotelId(int hotelId) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> results = await db.query(
      'rooms',
      where: 'hotel_id = ? AND is_available = 1',
      whereArgs: [hotelId],
      orderBy: 'price_per_night ASC',
    );

    return results.map((map) => RoomModel.fromMap(map)).toList();
  }
}
