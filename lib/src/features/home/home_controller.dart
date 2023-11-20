import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prova_flutter/src/common/entities/note_entity.dart';
import 'package:prova_flutter/src/common/entities/user_entity.dart';
import 'package:prova_flutter/src/common/exceptions/app_exception.dart';
import 'package:prova_flutter/src/common/repositories/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_store.dart';

class HomeController {
  final DatabaseRepository repository;
  final SharedPreferences prefs;
  final HomeStore store;

  HomeController(this.repository, this.store, this.prefs);

  void lauchPrivacyPolicy() async {
    await launchUrl(Uri.parse('https://www.google.com.br'));
  }

  Future<void> getNotes({
    void Function(String message)? onSuccess,
    Function(String exception)? onException,
  }) async {
    try {
      final connection = await Connectivity().checkConnectivity();

      if (connection == ConnectivityResult.none) {
        final notes = prefs.getStringList('notes') ?? [];

        store.setNotes(notes.map((e) => NoteEntity.fromJson(e)).toList());

        onSuccess?.call('Você não possui conexão com a internet, você está vendo as notas salvas neste dispositivo!');
      } else {
        final user = UserEntity.fromJson(prefs.getString('user')!);

        final notes = await repository.getNotes(user.id);

        notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        await prefs.setStringList('notes', notes.map((e) => e.toJson()).toList());

        store.setNotes(notes);
      }
    } on AppException catch (e) {
      return onException?.call(e.message);
    } on Exception catch (e) {
      return onException?.call(e.toString());
    }
  }

  Future<void> addNote(
    String text, {
    required void Function(String message) onSuccess,
    required void Function(String exception) onException,
  }) async {
    try {
      final user = UserEntity.fromJson(prefs.getString('user')!);

      final connection = await Connectivity().checkConnectivity();

      if (connection == ConnectivityResult.none) {
        final id = _getLocalId(store.notes);

        final note = NoteEntity(
          id: id,
          userId: user.id,
          text: text,
          createdAt: DateTime.now(),
        );

        store.addNote(note);

        await prefs.setStringList('notes', store.notes.map((e) => e.toJson()).toList());

        return onSuccess('Você não possui conexão com a internet, a nota foi salva localmente e será sincronizada quando houver nova conexão!');
      } else {
        final note = await repository.addNote(user.id, text);

        await prefs.setStringList('notes', store.notes.map((e) => e.toJson()).toList());

        store.addNote(note);

        return onSuccess('Nota adicionada com sucesso!');
      }
    } on AppException catch (e) {
      return onException(e.message);
    } on Exception {
      return onException('Ocorreu um erro inesperado, tente novamente mais tarde!');
    }
  }

  Future<void> removeNote(
    NoteEntity note, {
    required void Function(String message) onSuccess,
    required void Function(String exception) onException,
  }) async {
    try {
      final connection = await Connectivity().checkConnectivity();

      if (connection == ConnectivityResult.none) {
        store.removeNote(note);

        final removedNotes = prefs.getStringList('removedNotes')?.map(NoteEntity.fromJson) ?? [];

        await prefs.setStringList('removedNotes', [...removedNotes, note].map((e) => e.toJson()).toList());

        await prefs.setStringList('notes', store.notes.map((e) => e.toJson()).toList());

        return onSuccess('Voce não possui conexão com a internet, a nota foi excluída localmente e será sincronizada quando houver nova conexão!');
      } else {
        await repository.removeNote(note);

        await prefs.setStringList('notes', store.notes.map((e) => e.toJson()).toList());

        store.removeNote(note);

        return onSuccess('Nota excluída com sucesso!');
      }
    } on AppException catch (e) {
      return onException(e.message);
    } on Exception {
      return onException('Ocorreu um erro inesperado, tente novamente mais tarde!');
    }
  }

  Future<void> updateNote(
    NoteEntity note, {
    required void Function(String message) onSuccess,
    required void Function(String exception) onException,
  }) async {
    try {
      final connection = await Connectivity().checkConnectivity();

      if (connection == ConnectivityResult.none) {
        store.updateNote(note);

        if (!note.id.isNegative) {
          final updatedNotes = prefs.getStringList('updatedNotes')?.map(NoteEntity.fromJson).toList() ?? [];

          await prefs.setStringList('updatedNotes', [...updatedNotes, note].map((e) => e.toJson()).toList());
        }

        await prefs.setStringList('notes', store.notes.map((e) => e.toJson()).toList());

        return onSuccess('Voce não possui conexão com a internet, a nota foi atualizada localmente e será sincronizada quando houver nova conexão!');
      } else {
        final updatedNote = await repository.updateNote(note);

        store.updateNote(updatedNote);

        await prefs.setStringList('notes', store.notes.map((e) => e.toJson()).toList());

        return onSuccess('Nota atualizada com sucesso!');
      }
    } on AppException catch (e) {
      return onException(e.message);
    } on Exception {
      return onException('Ocorreu um erro inesperado, tente novamente mais tarde!');
    }
  }

  Future<void> sincronizeNotes({
    void Function(String message)? onSuccess,
    Function(String exception)? onException,
  }) async {
    final connection = await Connectivity().checkConnectivity();

    switch (connection) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
      case ConnectivityResult.vpn:
        {
          try {
            log('Sincronizando as notas');

            final user = UserEntity.fromJson(prefs.getString('user')!);

            final localNotes = prefs.getStringList('notes')?.map(NoteEntity.fromJson).where((e) => e.id.isNegative).toList() ?? [];

            for (final note in localNotes) {
              await repository.addNote(user.id, note.text);
            }

            final removedNotes = prefs.getStringList('removedNotes')?.map(NoteEntity.fromJson) ?? [];

            for (final note in removedNotes) {
              await repository.removeNote(note);
            }

            await prefs.remove('removedNotes');

            final updatedNotes = prefs.getStringList('updatedNotes')?.map(NoteEntity.fromJson).toList() ?? [];

            for (final note in updatedNotes) {
              await repository.updateNote(note);
            }

            await prefs.remove('updatedNotes');

            final remoteNotes = await repository.getNotes(user.id);

            remoteNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt));

            await prefs.setStringList('notes', remoteNotes.map((e) => e.toJson()).toList());

            store.setNotes(remoteNotes);

            onSuccess?.call('Notas sincronizadas com sucesso!');

            break;
          } on AppException catch (e) {
            return onException?.call(e.message);
          } on Exception {
            return onException?.call('Ocorreu um erro inesperado ao sincronizar, tente novamente mais tarde!');
          }
        }
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.none:
      case ConnectivityResult.other:
        {
          break;
        }
    }
  }

  int _getLocalId(List<NoteEntity> notes) {
    if (notes.isEmpty) {
      return -1;
    } else if (notes.last.id.isNegative) {
      return notes.last.id - 1;
    } else {
      return (notes.last.id + 1) * -1;
    }
  }
}
