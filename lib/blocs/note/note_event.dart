part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

class LoadNotes extends NoteEvent {}

class LoadAllNotes extends NoteEvent {}

class LoadNotesForCustomer extends NoteEvent {
  final int customerId;

  LoadNotesForCustomer(this.customerId);
}

class AddNote extends NoteEvent {
  final NoteModel note;

  AddNote(this.note);
}

class LoadAllNotesWithCustomerNames extends NoteEvent {}
