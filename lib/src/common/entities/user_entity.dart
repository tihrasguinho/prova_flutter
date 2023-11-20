import 'dart:convert';

class UserEntity {
  final int id;
  final String username;
  final String password;

  UserEntity({
    required this.id,
    required this.username,
    required this.password,
  });

  UserEntity copyWith({
    int? id,
    String? username,
    String? password,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'username': username,
      'password': password,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: int.parse(map['id'] as String),
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) => UserEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserEntity(id: $id, username: $username, password: $password)';

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.username == username && other.password == password;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ password.hashCode;
}
