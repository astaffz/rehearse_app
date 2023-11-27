import 'package:flutter/material.dart';
import 'package:rehearse_app/utils/styles.dart';

class NoteType {
  const NoteType({
    required this.categoryID,
    required this.name,
    required this.headerBackgroundColor,
    this.headerBackgroundColorOpened,
    this.headerBorderColor,
    this.headerBorderColorOpened,
    this.leftIcon,
  });
  final int categoryID;
  final String name;
  final Color headerBackgroundColor;
  final Color? headerBackgroundColorOpened;
  final Color? headerBorderColor;
  final Color? headerBorderColorOpened;
  final Icon? leftIcon;
}

class Note with ChangeNotifier {
  Note({
    required this.term,
    required this.definition,
    required this.category,
  });

  String term;
  String definition;
  NoteType category;

  List get elements {
    final elements = [term, definition, category];
    return elements;
  }
}

const NoteType defaultType = NoteType(
    categoryID: 0,
    name: "standard",
    headerBackgroundColor: accent,
    leftIcon: Icon(Icons.library_books));
NoteType important = const NoteType(
    categoryID: 1,
    name: "important",
    headerBackgroundColor: Colors.red,
    leftIcon: Icon(Icons.label_important));

List<NoteType> categories = [defaultType, important];

void createCustomNoteType(Color hBC, String categoryName) {
  // TODO: Add other parameters, figure out how to use required and optional.
  categories.add(NoteType(
    headerBackgroundColor: hBC,
    categoryID: categories.length,
    name: categoryName,
  ));
}

class NoteData with ChangeNotifier {
  // ignore: prefer_final_fields
  static List<Note> _notes = [
    Note(
      term: "Murphyjev zakon",
      definition: "'Ako nešto može poći naopako, poći će naopako.'",
      category: defaultType,
    ),
    Note(
      term: "Marksizam",
      definition:
          "Marksizam je holistička i transdisciplinarna društvena znanost, teorija i politička djelatnost tj. praxis dobivena iz radova Karla Marxa i Friedricha Engelsa. ",
      category: important,
    ),
  ];
  void addNote(String term, String definition,
      [NoteType category = defaultType]) {
    _notes.add(Note(term: term, definition: definition, category: category));
    notifyListeners();
  }

  List<Note> get notes => _notes;
  void editNote(Note note, int elementID, var input) {
    switch (elementID) {
      case 0:
        note.term = input;
        break;
      case 1:
        note.definition = input;
        break;
      case 2:
        note.category = input;
    }
    notifyListeners();
  }

  void deleteNote(Note note) {
    notes.remove(note);
    notifyListeners();
  }
}
