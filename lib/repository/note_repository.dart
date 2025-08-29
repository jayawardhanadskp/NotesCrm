import 'package:notes_crm/core/db/database_helper.dart';
import 'package:notes_crm/models/note_model.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<NoteModel>> getAllNotes() async {
    return await _dbHelper.getNotes();
  }

  Future<List<NoteModel>> getNotesForCustomer(int customerId) async {
    return await _dbHelper.getNoteFromCusId(customerId);
  }

  Future<int> addNote(NoteModel note) async {
    return await _dbHelper.createNote(note);
  }

  Future<List<Map<String, dynamic>>> getNotesWithCustomerNames() async {
    return await _dbHelper.getNotesWithCustomerNames();
  }
}
