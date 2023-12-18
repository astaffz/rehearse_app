import 'package:flutter/material.dart';

import 'package:rehearse_app/utils/note_model.dart';

class DialogData with ChangeNotifier {
  NoteType noteCategory = defaultType;
  Color dialogColor = defaultType.headerBackgroundColor;
  bool hasNote = false;

  void setDialog(Note? note) {
    if (note != null && hasNote == false) {
      dialogColor = categories[note.categoryID].headerBackgroundColor;
      noteCategory = categories[note.categoryID];
    }
  }

  void onChanged(NoteType selectedCategory) {
    noteCategory = selectedCategory;
    dialogColor = selectedCategory.headerBackgroundColor;
    notifyListeners();
  }
}
