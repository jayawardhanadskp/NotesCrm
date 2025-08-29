part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class LoadAllNotesLoading extends NoteState {}

final class LoadAllNotesSucess extends NoteState {
  final List<NoteModel> notes;

  LoadAllNotesSucess(this.notes);
}

final class LoadAllNotesError extends NoteState {
  final String message;

  LoadAllNotesError(this.message);
}

final class LoadNotesForCustomerLoading extends NoteState {}

final class LoadNotesForCustomerSuccess extends NoteState {
  final List<NoteModel> notes;
  LoadNotesForCustomerSuccess(this.notes);
}

final class LoadNotesForCustomerError extends NoteState {
  final String message;
  LoadNotesForCustomerError(this.message);
}

final class AddNoteLoading extends NoteState {}

final class AddNoteSuccess extends NoteState {}

final class AddNoteError extends NoteState {
  final String message;
  AddNoteError(this.message);
}

final class LoadNotesWithCustomerNamesLoading extends NoteState {}

final class LoadNotesWithCustomerNamesSuccess extends NoteState {
  final List<NoteModel> notes;
  LoadNotesWithCustomerNamesSuccess(this.notes);
}

final class LoadNotesWithCustomerNamesError extends NoteState {
  final String message;
  LoadNotesWithCustomerNamesError(this.message);
}
