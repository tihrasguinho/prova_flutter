import 'dart:convert';

class NoteEntity {
  final int id;
  final int userId;
  final String text;
  final DateTime createdAt;

  NoteEntity({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  NoteEntity copyWith({
    int? id,
    int? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toString(),
      'user_id': userId.toString(),
      'text': text,
      'created_at': createdAt.millisecondsSinceEpoch ~/ 1000,
    };
  }

  factory NoteEntity.fromMap(Map<String, dynamic> map) {
    return NoteEntity(
      id: int.parse(map['id'] as String),
      userId: int.parse(map['user_id'] as String),
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch((map['created_at'] as int) * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteEntity.fromJson(String source) => NoteEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoteEntity(id: $id, userId: $userId, text: $text, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant NoteEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.userId == userId && other.text == text && other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ text.hashCode ^ createdAt.hashCode;
  }
}
