// lib/models/hotel_model.dart

/// Modelo que representa un hotel en la aplicación y en la base de datos SQLite.
/// Mapea la tabla 'hotels'.
class HotelModel {
  final int? id; // Autoincremental en SQLite
  final String name;
  final String? description;
  final String address;
  final String city;
  final int stars;
  final String? imageUrl;
  final String? createdAt;
  final double? minPrice; // Precio mínimo obtenido desde la tabla rooms

  const HotelModel({
    this.id,
    required this.name,
    this.description,
    required this.address,
    required this.city,
    this.stars = 3,
    this.imageUrl,
    this.createdAt,
    this.minPrice,
  });

  /// Convierte el objeto HotelModel a un Map para insertarlo o actualizarlo en SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'stars': stars,
      'image_url': imageUrl,
      'created_at': createdAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Crea una instancia de HotelModel a partir de un Map devuelto por SQLite
  factory HotelModel.fromMap(Map<String, dynamic> map) {
    return HotelModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      address: map['address'] as String,
      city: map['city'] as String,
      stars: (map['stars'] as num?)?.toInt() ?? 3,
      imageUrl: map['image_url'] as String?,
      createdAt: map['created_at'] as String?,
      minPrice: (map['min_price'] as num?)?.toDouble(),
    );
  }

  /// Permite crear una copia del hotel modificando campos específicos
  HotelModel copyWith({
    int? id,
    String? name,
    String? description,
    String? address,
    String? city,
    int? stars,
    String? imageUrl,
    String? createdAt,
    double? minPrice,
  }) {
    return HotelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      stars: stars ?? this.stars,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      minPrice: minPrice ?? this.minPrice,
    );
  }
}
