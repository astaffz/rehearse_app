import 'package:flutter/material.dart';
import 'package:rehearse_app/shared/shared.dart';

class NoteType {
  const NoteType({
    this.categoryID,
    required this.name,
    this.headerBackgroundColor,
    this.colorHex,
    this.headerBackgroundColorOpened,
    this.headerBorderColor,
    this.headerBorderColorOpened,
    this.leftIcon,
  });
  final int? categoryID;
  final String name;
  final String? colorHex;
  final Color? headerBackgroundColor;
  final Color? headerBackgroundColorOpened;
  final Color? headerBorderColor;
  final Color? headerBorderColorOpened;
  final Icon? leftIcon;

  Map<String, dynamic> toMap() {
    return {
      'id': categoryID,
      'title': name,
      'color': colorHex,
    };
  }

  List get elements {
    final elements = [name, colorHex];
    return elements;
  }
}

class Note with ChangeNotifier {
  Note({
    required this.id,
    required this.term,
    required this.definition,
    required this.categoryID,
  });

  int? id;
  String term;
  String definition;
  int categoryID;

  List get elements {
    final elements = [term, definition, categoryID];
    return elements;
  }

  Map<String, dynamic> toMap() {
    return {
      'term': term,
      'definition': definition,
      'category_id': categoryID,
    };
  }

  Note.noId(
      {required this.term, required this.definition, required this.categoryID});
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
