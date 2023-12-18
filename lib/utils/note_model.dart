import 'package:flutter/material.dart';
import 'package:rehearse_app/shared/shared.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryID,
      '': name,
    };
  }
}

class Note with ChangeNotifier {
  Note({
    required this.id,
    required this.term,
    required this.definition,
    required this.categoryID,
  });

  final int id;
  String term;
  String definition;
  int categoryID;

  List get elements {
    final elements = [term, definition, categoryID];
    return elements;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'term': term,
      'definition': definition,
      'category_id': categoryID,
    };
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
