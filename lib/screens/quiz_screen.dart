import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/models/quiz_model.dart';
import 'package:rehearse_app/screens/create_test_dialog.dart';
import 'package:rehearse_app/shared/progress_bar.dart';
import 'package:rehearse_app/shared/styles.dart';
import 'package:rehearse_app/utils/dialog_state.dart';
import 'package:rehearse_app/utils/quiz_state.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.quizCategories});

  final List<int> quizCategories;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      builder: (context, child) {
        var state = Provider.of<QuizState>(context);
        Quiz quiz = Provider.of<QuizState>(context).quiz;
        Future<Quiz> quizFuture = Provider.of<QuizState>(context)
            .generateMultipleChoiceQuiz(quizCategories);
        return FutureBuilder(
            future: quizFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                state.quiz =
                    snapshot.data ?? const Quiz(noteList: [], questions: []);
                return Scaffold(
                  appBar: AppBar(
                    title: ProgressBar(value: state.progress),
                    leading: IconButton(
                      icon: const Icon(FontAwesomeIcons.xmark),
                      onPressed: () => _exitQuiz(state, context),
                    ),
                  ),
                  body: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: state.controller,
                    onPageChanged: (int index) {
                      index > 1
                          ? state.progress = index / (quiz.questions.length + 1)
                          : state.progress = 0;
                    },
                    itemBuilder: (BuildContext context, int idx) {
                      if (idx == 0) {
                        return StartPage(quiz: quiz);
                      } else if (idx == quiz.questions.length + 1) {
                        return CongratsPage(quiz: quiz);
                      } else {
                        return QuestionPage(question: quiz.questions[idx - 1]);
                      }
                    },
                  ),
                );
              }
            });
      },
    );
  }

  void _exitQuiz(QuizState state, BuildContext context) {
    state.controller.page == 0
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTestDialog(),
            ))
        : DialogData().BuildDialog(
            context,
            Text(
              "Sigurno?",
              style: pBold,
            ),
            Text(
              "Ako izađeš, tvoj napredak će se izgubiti.",
              style: p2,
              textAlign: TextAlign.center,
            ),
            [
              TextButton(
                  child: Text(
                    "Odustani",
                    style: p3.copyWith(color: black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.red)),
                icon: const Icon(Icons.sticky_note_2, color: white),
                label: Text(
                  "Izađi",
                  style: p3.copyWith(color: white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
  }
}

class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              question.question,
              style: heading2,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: question.options.map((option) {
              return Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith(
                        (states) => const RoundedRectangleBorder()),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) => accent),
                  ),
                  onPressed: () {
                    state.selected = option;
                    _bottomSheet(context, option, state);
                  },
                  icon: Icon(
                    state.selected == option
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circle,
                    size: 30,
                    color: black,
                  ),
                  label: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              option,
                              style: p2.copyWith(color: black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  void _bottomSheet(BuildContext context, String option, QuizState state) {
    bool correct = question.note.definition == option;

    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  correct ? "Tako je!\n" : "Netačno.",
                  textAlign: TextAlign.center,
                  style: pBold,
                ),
                Text(
                  "$option je tačan odgovor.",
                  textAlign: TextAlign.center,
                  style: p2.copyWith(color: white),
                ),
                ElevatedButton(
                    onPressed: () {
                      state.correctQuestionsIndex++;
                      state.selected = '';
                      Navigator.pop(context);
                      state.nextPage();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: correct ? Colors.green : Colors.red),
                    child: Text(
                      correct ? "IDEEEE!" : "Ma ide iduća.",
                      style: pBold,
                    )),
              ]),
        );
      },
    );
  }
}

class StartPage extends StatelessWidget {
  final Quiz quiz;
  const StartPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Sve je spremno!", style: pBold),
        Text(
          textAlign: TextAlign.center,
          "Broj pitanja: ${state.quiz.questions.length}\nTip pitanja: Višestruki izbor",
          style: p2.copyWith(color: white),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: state.nextPage,
            child: Text(
              "Sretno!",
              style: pBold,
            )),
      ],
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  const CongratsPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    final double percentage =
        (state.correctQuestionsIndex / quiz.questions.length) * 100;
    List<String> titles = [
      "Academic weapon",
      "Mašina",
      "Jedva",
      "Ništa vrati ponovo"
    ];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rezultat: ',
                textAlign: TextAlign.center,
                style: pBold,
              ),
              Text(
                "${state.correctQuestionsIndex} / ${quiz.questions.length} ili $percentage% ",
                style: p2.copyWith(color: white),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Učinak: ',
                textAlign: TextAlign.center,
                style: pBold,
              ),
              Text(
                percentage > 90
                    ? titles[0]
                    : percentage > 75
                        ? titles[1]
                        : percentage > 60
                            ? titles[2]
                            : titles[3],
                style: p2.copyWith(color: white),
              ),
            ],
          ),
          const Divider(),
          OutlinedButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black54)),
            ),
            icon: const Icon(FontAwesomeIcons.check),
            label: Text(
              'Završi kviz',
              style: pBold,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/notes',
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
