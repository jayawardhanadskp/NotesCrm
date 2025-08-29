import 'package:notes_crm/models/customer_model.dart';
import 'package:notes_crm/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _database;

  DatabaseHelper._instance();

  String customersTable = 'customers';
  String colCustomerId = 'id';
  String colCustomerName = 'name';
  String colCustomerPhone = 'phone';
  String colCustomerEmail = 'email';
  String colCustomerCompany = 'company';
  String colCustomerDate = 'createdAt';

  String notesTable = 'notes';
  String colNoteId = 'id';
  String colNoteCustomerId = 'customer_id';
  String colNoteTitle = 'title';
  String colNoteDescription = 'description';
  String colNoteDate = 'createdAt';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'crm.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $customersTable (
        $colCustomerId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCustomerName TEXT NOT NULL,
        $colCustomerPhone TEXT,
        $colCustomerEmail TEXT,
        $colCustomerCompany TEXT,
        $colCustomerDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $notesTable (
        $colNoteId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colNoteCustomerId INTEGER,
        $colNoteTitle TEXT NOT NULL,
        $colNoteDescription TEXT,
        $colNoteDate TEXT NOT NULL,
        FOREIGN KEY($colNoteCustomerId) REFERENCES $customersTable($colCustomerId) ON DELETE CASCADE
      )
    ''');
  }

  /// CUSTOMER
  Future<int> insertCustomer(CustomerModel customer) async {
    try {
      Database db = await database;
      return await db.insert(customersTable, customer.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<List<CustomerModel>> getCustomers() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      customersTable,
      orderBy: '$colCustomerDate DESC',
    );
    return List.generate(maps.length, (i) => CustomerModel.fromMap(maps[i]));
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    try {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        customersTable,
        where: '$colCustomerId = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return CustomerModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<int> updateCoustomer(CustomerModel customer) async {
    try {
      Database db = await database;
      return await db.update(
        customersTable,
        customer.toMap(),
        where: '$colCustomerId = ?',
        whereArgs: [customer.id],
      );
    } catch (e) {
      return -1;
    }
  }

  Future<int> deleteCustomer(int id) async {
    try {
      Database db = await database;
      return await db.delete(
        customersTable,
        where: '$colCustomerId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  ///NOTES

  Future<int> createNote(NoteModel note) async {
    try {
      Database db = await database;
      return await db.insert(notesTable, note.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<List<NoteModel>> getNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> noteMaps = await db.query(
      notesTable,
      orderBy: '$colNoteDate DESC',
    );
    return List.generate(
      noteMaps.length,
      (i) => NoteModel.fromMap(noteMaps[i]),
    );
  }

  Future<List<Map<String, dynamic>>> getNotesWithCustomerNames() async {
    try {
      Database db = await database;
      return await db.rawQuery('''
        SELECT 
          $notesTable.$colNoteId,
          $notesTable.$colNoteCustomerId,
          $notesTable.$colNoteTitle,
          $notesTable.$colNoteDescription,
          $notesTable.$colNoteDate,
          $customersTable.$colCustomerName AS customerName
        FROM $notesTable
        LEFT JOIN $customersTable 
          ON $notesTable.$colNoteCustomerId = $customersTable.$colCustomerId
        ORDER BY $notesTable.$colNoteDate DESC
      ''');
    } catch (e) {
      return [];
    }
  }

  Future<List<NoteModel>> getNoteFromCusId(int customerId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      notesTable,
      where: '$colNoteCustomerId = ?',
      whereArgs: [customerId],
      orderBy: '$colNoteDate DESC',
    );
    return List.generate(maps.length, (i) => NoteModel.fromMap(maps[i]));
  }
}
