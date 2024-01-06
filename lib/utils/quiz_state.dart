import 'package:flutter/material.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:rehearse_app/models/quiz_model.dart';
import 'package:rehearse_app/services/database_helper.dart';

class QuizState with ChangeNotifier {
  double _progress = 0;
  Quiz quiz = Quiz(questions: [], noteList: []);
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
    List<Question> questions = [];
    for (int i in selectedCategories) {
      List<Note> notesFromCategory =
          await databaseHelper.notesByCategoryQuery(i);
      notes.addAll(notesFromCategory);
    }
    questions = List.generate(
      notes.length,
      (index) {
        questions.shuffle();
        return Question.createMultipleChoice(
            questionNote: notes[index], quizNoteList: notes);
      },
    );
    return Quiz(questions: questions, noteList: notes);
  }

  void nextPage() async {
    await controller.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
