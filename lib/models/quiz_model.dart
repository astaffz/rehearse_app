import 'dart:math';

import 'package:rehearse_app/models/note_model.dart';

class Quiz {
  final List<Question> questions;
  final List<Note> noteList;

  const Quiz({
    required this.questions,
    required this.noteList,
  });
}

class Question {
  final List<String> options;
  final String question;
  final Note note;
  Question.multpleChoice({
    required this.question,
    required this.options,
    required this.note,
  });
  Question(
    this.options, {
    required this.question,
    required this.note,
  });
  factory Question.createMultipleChoice(
      {required Note questionNote, required List<Note> quizNoteList}) {
    List<String> options = [questionNote.definition];

    if (quizNoteList.length < 4) {
      List<String> definitions = List.generate(
          quizNoteList.length, (index) => quizNoteList[index].definition);
      options = definitions;
    } else {
      var random = Random();
      while (options.length < 4) {
        int randomOption = random.nextInt(quizNoteList.length);
        if (!options.contains(quizNoteList[randomOption].definition)) {
          options.add(quizNoteList[randomOption].definition);
        }
      }
    }
    options.shuffle();
    return Question.multpleChoice(
        question: questionNote.term, options: options, note: questionNote);
  }
}
