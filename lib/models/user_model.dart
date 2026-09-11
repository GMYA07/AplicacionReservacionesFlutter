class UserModel {
  final int? id; // El id es opcional (?) porque al registrarlo, SQLite lo autoincrementa
  final String name;
  final String email;
  final String password;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
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
    return map;
  }

  /// Crea un objeto UserModel a partir de un Map devuelto por SQLite (db.query)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  /// Nos permite crear una copia del usuario modificando solo algún dato si hiciera falta
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
