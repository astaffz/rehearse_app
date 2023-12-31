import 'package:rehearse_app/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String databaseName = 'rehearseapp_data.db';
  final int databaseVersion = 1;

  final String tableNotes = "notes";
  final String columnId = 'id';
  final String colTerm = 'term';
  final String colDefinition = 'definition';
  final String colCategoryId = 'category_id';

  final String tableCategories = 'categories';
  final String colTitle = 'title';

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<int> get notesRecordCount async {
    int? count = Sqflite.firstIntValue(
            await _database!.rawQuery('SELECT COUNT(*) FROM $tableNotes')) ??
        0;
    return count;
  }

  Future<Database?> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);

    return openDatabase(path,
        onCreate: _onCreate,
        onOpen: _onOpen,
        onConfigure: _onConfigure,
        version: databaseVersion);
  }

  void _onOpen(Database db) async {
    db.insert(tableCategories, {columnId: 0, colTitle: "defaultType"},
        conflictAlgorithm: ConflictAlgorithm.ignore);
    db.insert(tableCategories, {columnId: 1, colTitle: "important"},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  void _onCreate(Database db, int version) {
    db.execute("""
    CREATE TABLE notes (
    $columnId     INTEGER PRIMARY KEY ASC AUTOINCREMENT
                        NOT NULL,
    $colTerm        TEXT    NOT NULL,
    $colDefinition  TEXT    NOT NULL,
    $colCategoryId INTEGER REFERENCES $tableCategories ($columnId) 
                        DEFAULT (0) 
)
                        """);
    db.execute("""
CREATE TABLE IF NOT EXISTS $tableCategories (
    $columnId INTEGER PRIMARY KEY ASC AUTOINCREMENT,
    $colTitle       TEXT    NOT NULL DEFAULT defaultType
)
""");
  }

  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<int> insertNote(Note note) async {
    Database? db = await database;
    return await db!.insert(tableNotes, note.toMap());
  }

  Future<int> updateNote(Note note) async {
    Database? db = await database;
    return await db!.update(tableNotes, note.toMap(),
        where: '$columnId = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteNote(Note note) async {
    Database? db = await database;
    return await db!
        .delete(tableNotes, where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<int> insertCategory(NoteType category) async {
    Database? db = await database;
    return await db!.insert(tableCategories, category.toMap());
  }

  Future<void> closeDb() async {
    Database? db = await database;
    await db!.close();
  }

  Future<List<Note>> getNotesDatabase() async {
    Database? db = await database;
    final List<Map<String, dynamic>> mappedNotes =
        await db!.rawQuery("SELECT * FROM notes");

    return List.generate(mappedNotes.length, (i) {
      return Note(
        id: mappedNotes[i][columnId] as int,
        term: mappedNotes[i][colTerm] as String,
        definition: mappedNotes[i][colDefinition] as String,
        categoryID: mappedNotes[i][colCategoryId] as int,
      );
    });
  }

  Future<List<NoteType>> getCategoriesDatabase() async {
    Database? db = await database;
    final List<Map<String, dynamic>> mappedTypes =
        await db!.query(tableCategories);

    return List.generate(mappedTypes.length, (i) {
      return NoteType(
          categoryID: mappedTypes[i][columnId] as int,
          name: mappedTypes[i][colTitle] as String,
          headerBackgroundColor: defaultType
              .headerBackgroundColor // TODO: Implement colors into DB
          );
    });
  }

  Future<List<Note>> notesByCategoryQuery(int category) async {
    Database? db = await database;
    List<Note> notes = [];

    var notesFromCategory = await db!.rawQuery(
        'SELECT * FROM ${tableNotes} WHERE ${colCategoryId} = ?', [category]);
    notes.addAll(List.generate(notesFromCategory.length, (i) {
      return Note(
        id: notesFromCategory[i][columnId] as int,
        term: notesFromCategory[i][colTerm] as String,
        definition: notesFromCategory[i][colDefinition] as String,
        categoryID: notesFromCategory[i][colCategoryId] as int,
      );
    }));
    return notes;
  }
}
