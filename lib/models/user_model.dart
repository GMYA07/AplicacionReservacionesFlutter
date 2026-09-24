// lib/models/user_model.dart

/// Modelo que representa un usuario en SQLite.
/// Mapea la tabla 'users'.
class UserModel {
  final int? id; // El id es opcional (?) porque al registrarlo, SQLite lo autoincrementa
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? createdAt;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.createdAt,
  });

  /// Convierte el objeto UserModel a un Map (para guardarlo en SQLite con db.insert)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
    if (id != null) {
      map['id'] = id;
    }
    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
    }
    if (createdAt != null) {
      map['created_at'] = createdAt;
    }
    return map;
  }

  /// Crea un objeto UserModel a partir de un Map devuelto por SQLite (db.query)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  /// Nos permite crear una copia del usuario modificando solo algún dato si hiciera falta
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
