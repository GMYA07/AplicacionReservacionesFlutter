// lib/models/favorite_model.dart

/// Modelo que representa un hotel marcado como favorito por un usuario.
/// Mapea la tabla 'favorites' en SQLite (relación N:M entre users y hotels).
class FavoriteModel {
  final int? id; // Autoincremental en SQLite
  final int userId; // Llave foránea hacia users(id)
  final int hotelId; // Llave foránea hacia hotels(id)
  final String? createdAt;

  const FavoriteModel({
    this.id,
    required this.userId,
    required this.hotelId,
    this.createdAt,
  });

  /// Convierte el objeto FavoriteModel a un Map para insertarlo en SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'user_id': userId,
      'hotel_id': hotelId,
    };
    if (id != null) {
      map['id'] = id;
    }
    if (createdAt != null) {
      map['created_at'] = createdAt;
    }
    return map;
  }

  /// Crea una instancia de FavoriteModel a partir de un Map devuelto por SQLite
  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      hotelId: map['hotel_id'] as int,
      createdAt: map['created_at'] as String?,
    );
  }

  /// Permite crear una copia modificando campos específicos
  FavoriteModel copyWith({
    int? id,
    int? userId,
    int? hotelId,
    String? createdAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hotelId: hotelId ?? this.hotelId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
