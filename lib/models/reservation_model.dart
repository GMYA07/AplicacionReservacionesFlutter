// lib/models/reservation_model.dart

/// Modelo que representa una reserva en la aplicación y en SQLite.
/// Mapea la tabla 'reservations'.
class ReservationModel {
  final int? id; // Autoincremental en SQLite
  final int userId; // Llave foránea hacia users(id)
  final int roomId; // Llave foránea hacia rooms(id)
  final String checkIn; // Formato ISO 'YYYY-MM-DD'
  final String checkOut; // Formato ISO 'YYYY-MM-DD'
  final double totalPrice;
  final String status; // 'confirmed', 'cancelled', 'completed'
  final String? createdAt;

  const ReservationModel({
    this.id,
    required this.userId,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    this.status = 'confirmed',
    this.createdAt,
  });

  /// Convierte el objeto ReservationModel a un Map para insertarlo o actualizarlo en SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'user_id': userId,
      'room_id': roomId,
      'check_in': checkIn,
      'check_out': checkOut,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Crea una instancia de ReservationModel a partir de un Map devuelto por SQLite
  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      roomId: map['room_id'] as int,
      checkIn: map['check_in'] as String,
      checkOut: map['check_out'] as String,
      totalPrice: (map['total_price'] as num).toDouble(),
      status: map['status'] as String? ?? 'confirmed',
      createdAt: map['created_at'] as String?,
    );
  }

  /// Permite crear una copia de la reserva modificando campos específicos
  ReservationModel copyWith({
    int? id,
    int? userId,
    int? roomId,
    String? checkIn,
    String? checkOut,
    double? totalPrice,
    String? status,
    String? createdAt,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roomId: roomId ?? this.roomId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
