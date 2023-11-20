import 'package:prova_flutter/src/common/entities/note_entity.dart';
import 'package:prova_flutter/src/common/entities/user_entity.dart';

abstract interface class DatabaseRepository {
  Future<UserEntity> login(String username, String password);
  Future<List<NoteEntity>> getNotes(int userId);
  Future<NoteEntity> updateNote(NoteEntity note);
  Future<NoteEntity> addNote(int userId, String text);
  Future<void> removeNote(NoteEntity note);
}
