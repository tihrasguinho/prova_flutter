import 'package:dio/dio.dart';
import 'package:prova_flutter/src/common/entities/note_entity.dart';
import 'package:prova_flutter/src/common/entities/user_entity.dart';
import 'package:prova_flutter/src/common/exceptions/app_exception.dart';

import 'database_repository.dart';

class DatabaseRemoteRepository implements DatabaseRepository {
  final Dio dio;

  DatabaseRemoteRepository(this.dio);

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final response = await dio.get('/users?username=$username');

      final data = response.data as List;

      if (data.isEmpty) {
        throw DatabaseException('Usuário não encontrado!');
      }

      final user = UserEntity.fromMap(data.first);

      if (user.password != password) {
        throw DatabaseException('Senha inválida!');
      }

      return user;
    } on AppException catch (e) {
      throw UnknownException(e.message);
    } on DioException catch (e) {
      throw UnknownException(e.toString());
    } on Exception catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<NoteEntity> addNote(int userId, String text) async {
    try {
      final response = await dio.post(
        '/users/$userId/notes',
        data: {
          'user_id': userId,
          'text': text,
          'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );

      final data = response.data as Map<String, dynamic>;

      return NoteEntity.fromMap(data);
    } on DioException catch (e) {
      throw DatabaseException(e.toString());
    } on Exception catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<NoteEntity>> getNotes(int userId) async {
    try {
      final response = await dio.get('/users/$userId/notes');

      final data = response.data as List;

      return data.map((e) => NoteEntity.fromMap(e)).toList();
    } on DioException catch (e) {
      throw DatabaseException(e.toString());
    } on Exception catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<void> removeNote(NoteEntity note) async {
    try {
      await dio.delete('/users/${note.userId}/notes/${note.id}');
    } on DioException catch (e) {
      throw DatabaseException(e.toString());
    } on Exception catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<NoteEntity> updateNote(NoteEntity note) async {
    try {
      final response = await dio.put(
        '/users/${note.userId}/notes/${note.id}',
        data: {
          'text': note.text,
        },
      );

      final data = response.data as Map<String, dynamic>;

      return NoteEntity.fromMap(data);
    } on DioException catch (e) {
      throw DatabaseException(e.toString());
    } on Exception catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
