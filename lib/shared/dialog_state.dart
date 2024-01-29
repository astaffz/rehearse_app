import 'package:flutter/material.dart';

import 'package:rehearse_app/models/note_model.dart';

import 'package:rehearse_app/shared/styles.dart';

class DialogData with ChangeNotifier {
  DialogData({required this.categories});
  final List<NoteType> categories;
  NoteType noteCategory = defaultType;
  Color? dialogColor = defaultType.headerBackgroundColor;
  bool hasNote = false;
  bool hasCategory = false;
  void setDialog(Note? note) {
    if (note != null && hasNote == false) {
      dialogColor = categories
          .firstWhere((element) => element.categoryID == note.categoryID)
          .headerBackgroundColor;
      noteCategory = categories
          .firstWhere((element) => element.categoryID == note.categoryID);
    }
  }

  void setCategoryDialog(NoteType? category) {
    if (category != null && hasCategory == false) {
      dialogColor = category.headerBackgroundColor;
    }
  }

  void updateCategory(Color color) {
    dialogColor = color;
    notifyListeners();
  }

  void onChanged(NoteType selectedCategory) {
    noteCategory = selectedCategory;
    dialogColor = selectedCategory.headerBackgroundColor;
    notifyListeners();
  }

  static BuildDialog(BuildContext context, Widget title, Widget content,
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
