import 'package:flutter/material.dart';

import 'package:rehearse_app/models/note_model.dart';

import 'package:rehearse_app/shared/styles.dart';

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

  void BuildDialog(BuildContext context, Widget title, Widget content,
      List<Widget> actions) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          backgroundColor: white,
          title: Container(
            margin: EdgeInsets.zero,
            decoration: const ShapeDecoration(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 12, color: Colors.red),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            padding: EdgeInsets.zero,
            child: title,
          ),
          content: content,
          actions: actions,
        );
      },
    );
  }
}
