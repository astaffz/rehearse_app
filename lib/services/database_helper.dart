import 'dart:async';
import 'package:rehearse_app/models/note_model.dart';
import 'package:rehearse_app/models/reminder_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String databaseName = 'rehearseapp_data.db';
  final int databaseVersion = 1;

  final String columnId = 'id';

  final String tableNotes = "notes";
  final String colTerm = 'term';
  final String colDefinition = 'definition';
  final String colCategoryId = 'category_id';

  final String tableCategories = 'categories';
  final String colTitle = 'title';

  final String tableReminders = "reminders";
  final String colContent = "content";
  final String colDateTime = "scheduled_at";
  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDatabase();
    return _database;
  }

  Future<int> getLastID(String tableName) async {
    int? id = Sqflite.firstIntValue(await _database!.rawQuery(
            "SELECT seq FROM sqlite_sequence WHERE name=?", [tableName])) ??
        0;
    return id;
  }

  Future<int> get notesRecordCount async {
    int? count = Sqflite.firstIntValue(
            await _database!.rawQuery('SELECT COUNT(*) FROM $tableNotes')) ??
        0;
    return count;
  }

  Future<int> get remindersRecordCount async {
    int? count = Sqflite.firstIntValue(await _database!
            .rawQuery('SELECT COUNT(*) FROM $tableReminders')) ??
        0;
    return count;
  }

  Future<Database?> initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);

    return openDatabase(path, onCreate: (Database db, int newVersion) async {
      for (int version = 0; version < newVersion; version++) {
        await _performDBUpgrade(db, version + 1);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (int version = oldVersion; version < newVersion; version++) {
        await _performDBUpgrade(db, version + 1);
      }
    }, onConfigure: _onConfigure, version: databaseVersion);
  }

  Future _performDBUpgrade(Database db, int upgradeToVersion) async {
    switch (upgradeToVersion) {
      //Upgrade to V1 (initial creation)
      case 1:
        await _dbUpdatesVersion_1(db);
        break;
    }
  }

  Future<void> _dbUpdatesVersion_1(Database db) async {
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
    db.execute("""
    CREATE TABLE $tableReminders (
    $columnId     INTEGER PRIMARY KEY ASC AUTOINCREMENT
                        NOT NULL,
    $colContent        TEXT    NOT NULL,
    $colDateTime  TEXT    NOT NULL)
                        """);

    db.insert(tableCategories, {columnId: 0, colTitle: "defaultType"},
        conflictAlgorithm: ConflictAlgorithm.ignore);
    db.insert(tableCategories, {columnId: 1, colTitle: "important"},
        conflictAlgorithm: ConflictAlgorithm.ignore);
    db.insert(tableNotes, {
      columnId: 0,
      colTerm: "notes",
      colDefinition: "test",
      colCategoryId: 0
    });
  }

  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

// CRUD - NOTES
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

// CRUD - CATEGORIES
  Future<int> insertCategory(NoteType category) async {
    Database? db = await database;
    return await db!.insert(tableCategories, category.toMap());
  }

  Future<int> updateCategory(NoteType category) async {
    Database? db = await database;
    return await db!.update(tableCategories, category.toMap(),
        where: '$columnId = ?',
        whereArgs: [category.categoryID],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteCategory(NoteType category) async {
    Database? db = await database;
    return await db!.delete(tableCategories,
        where: '$columnId = ?', whereArgs: [category.categoryID]);
  }

// CRUD - Reminders
  Future<int> insertReminder(Reminder reminder) async {
    Database? db = await database;
    return await db!.insert(tableReminders, reminder.toMap());
  }

  Future<int> updateReminder(Reminder reminder) async {
    Database? db = await database;
    return await db!.update(tableReminders, reminder.toMap(),
        where: '$columnId = ?',
        whereArgs: [reminder.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteReminder(Reminder reminder) async {
    Database? db = await database;
    return await db!.delete(tableReminders,
        where: '$columnId = ?', whereArgs: [reminder.id]);
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

  Future<List<Reminder>> getRemindersDatabase() async {
    Database? db = await database;
    final List<Map<String, dynamic>> mappedReminders =
        await db!.rawQuery("SELECT * FROM $tableReminders");

    return List.generate(mappedReminders.length, (i) {
      return Reminder(
        id: mappedReminders[i][columnId],
        reminderContent: mappedReminders[i][colContent],
        Iso8601scheduledTime: mappedReminders[i][colDateTime],
      );
    });
  }

  Future<List<Note>> notesByCategoryQuery(List<int> categories) async {
    Database? db = await database;
    List<Note> notes = [];

    for (int categoryID in categories) {
      var notesFromCategory = await db!.rawQuery(
          'SELECT * FROM $tableNotes WHERE $colCategoryId = ?', [categoryID]);
      notes.addAll(List.generate(notesFromCategory.length, (i) {
        return Note(
          id: notesFromCategory[i][columnId] as int,
          term: notesFromCategory[i][colTerm] as String,
          definition: notesFromCategory[i][colDefinition] as String,
          categoryID: notesFromCategory[i][colCategoryId] as int,
        );
      }));
    }
    return notes;
  }
}
