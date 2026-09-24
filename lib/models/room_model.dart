// lib/models/room_model.dart

/// Modelo que representa una habitación de hotel en SQLite.
/// Mapea la tabla 'rooms'.
class RoomModel {
  final int? id; // Autoincremental en SQLite
  final int hotelId; // Llave foránea hacia hotels(id)
  final String roomType; // Ej: 'Habitación Simple', 'Doble Deluxe', 'Suite Familiar'
  final double pricePerNight;
  final int capacity; // Cantidad máxima de huéspedes
  final bool isAvailable; // SQLite almacena 1 (disponible) o 0 (no disponible)

  const RoomModel({
    this.id,
    required this.hotelId,
    required this.roomType,
    required this.pricePerNight,
    required this.capacity,
    this.isAvailable = true,
  });

  /// Convierte el objeto RoomModel a un Map para inserciones o actualizaciones en SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'hotel_id': hotelId,
      'room_type': roomType,
      'price_per_night': pricePerNight,
      'capacity': capacity,
      'is_available': isAvailable ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Crea una instancia de RoomModel a partir de un Map devuelto por SQLite
  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as int?,
      hotelId: map['hotel_id'] as int,
      roomType: map['room_type'] as String,
      pricePerNight: (map['price_per_night'] as num).toDouble(),
      capacity: (map['capacity'] as num).toInt(),
      isAvailable: (map['is_available'] as int? ?? 1) == 1,
    );
  }

  /// Permite crear una copia de la habitación modificando atributos específicos
  RoomModel copyWith({
    int? id,
    int? hotelId,
    String? roomType,
    double? pricePerNight,
    int? capacity,
    bool? isAvailable,
  }) {
    return RoomModel(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      roomType: roomType ?? this.roomType,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      capacity: capacity ?? this.capacity,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
