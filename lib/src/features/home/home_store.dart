import 'package:mobx/mobx.dart';
import 'package:prova_flutter/src/common/entities/note_entity.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  ObservableList<NoteEntity> notes = <NoteEntity>[].asObservable();

  @action
  void setNotes(List<NoteEntity> notes) => this.notes = notes.asObservable();

  @action
  void addNote(NoteEntity note) => notes.add(note);

  @action
  void updateNote(NoteEntity note) {
    if (notes.any((e) => e.id == note.id)) {
      final index = notes.indexWhere((e) => e.id == note.id);

      notes[index] = note;

      notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      notes = notes.asObservable();
    }
  }

  @action
  void removeNote(NoteEntity note) => notes.remove(note);
}
