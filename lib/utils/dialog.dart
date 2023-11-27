import 'package:flutter/material.dart';

import 'package:rehearse_app/utils/note_model.dart';

class DialogData with ChangeNotifier {
  NoteType noteCategory = defaultType;
  Color dialogColor = defaultType.headerBackgroundColor;

  void onChanged(NoteType selectedCategory) {
    noteCategory = selectedCategory;
    dialogColor = selectedCategory.headerBackgroundColor;
    notifyListeners();
  }
}
