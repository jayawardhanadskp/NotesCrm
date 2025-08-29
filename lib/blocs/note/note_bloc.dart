// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_crm/models/note_model.dart';
import 'package:notes_crm/repository/note_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;

  NoteBloc(this.noteRepository) : super(NoteInitial()) {
    on<LoadAllNotes>((event, emit) async {
      emit(LoadAllNotesLoading());
      try {
        final notes = await noteRepository.getAllNotes();
        emit(LoadAllNotesSucess(notes));
      } catch (e) {
        emit(LoadAllNotesError(e.toString()));
      }
    });

    on<LoadAllNotesWithCustomerNames>((event, emit) async {
      emit(LoadNotesWithCustomerNamesLoading());
      try {
        final noteMaps = await noteRepository.getNotesWithCustomerNames();
        final notes = noteMaps
            .map((noteMap) => NoteModel.fromMap(noteMap))
            .toList();
        emit(LoadNotesWithCustomerNamesSuccess(notes));
      } catch (e) {
        emit(LoadNotesWithCustomerNamesError(e.toString()));
      }
    });

    on<LoadNotesForCustomer>((event, emit) async {
      emit(LoadNotesForCustomerLoading());
      try {
        final notes = await noteRepository.getNotesForCustomer(
          event.customerId,
        );
        emit(LoadNotesForCustomerSuccess(notes));
      } catch (e) {
        emit(LoadNotesForCustomerError(e.toString()));
      }
    });

    on<AddNote>((event, emit) async {
      emit(AddNoteLoading());
      try {
        final result = await noteRepository.addNote(event.note);
        if (result != -1) {
          emit(AddNoteSuccess());
          add(LoadAllNotesWithCustomerNames());
        } else {
          emit(AddNoteError('Failed to add note'));
        }
      } catch (e) {
        emit(AddNoteError(e.toString()));
      }
    });
  }
}
