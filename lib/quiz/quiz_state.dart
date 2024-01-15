import 'package:flutter/material.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:rehearse_app/models/quiz_model.dart';
import 'package:rehearse_app/services/database_helper.dart';

class QuizState with ChangeNotifier {
  double _progress = 0;
  Quiz quiz = Quiz(noteList: [], questions: []);
  double get progress => _progress;
  String _selected = '';
  String get selected => _selected;
  int correctQuestionsIndex = 0;

  PageController controller = PageController();
  TextEditingController writtenTestController = TextEditingController();
  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  set selected(String selectedOpt) {
    _selected = selectedOpt;
    notifyListeners();
  }

  Future<Quiz> generateMultipleChoiceQuiz(List<int> selectedCategories) async {
    DatabaseHelper databaseHelper = DatabaseHelper();

    List<Note> notes = [];
    final List<Question> questions;

    List<Note> notesFromCategories =
        await databaseHelper.notesByCategoryQuery(selectedCategories);
    notes.addAll(notesFromCategories);

    questions = notes.map((note) {
      return Question.createMultipleChoice(
          questionNote: note, quizNoteList: notes);
    }).toList(growable: false);
    questions.shuffle();
    return Quiz(questions: questions, noteList: notes);
  }

  void nextPage() async {
    await controller.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
