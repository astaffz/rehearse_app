import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/models/quiz_model.dart';
import 'package:rehearse_app/notes/create_test_dialog.dart';
import 'package:rehearse_app/shared/progress_bar.dart';
import 'package:rehearse_app/shared/styles.dart';
import 'package:rehearse_app/notes/dialog_state.dart';
import 'package:rehearse_app/quiz/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen(
      {super.key, required this.quizCategories, required this.questionType});

  final List<int> quizCategories;
  final QuestionType questionType;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz> quizFuture;
  @override
  initState() {
    super.initState();
    quizFuture = QuizState().generateMultipleChoiceQuiz(widget.quizCategories);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      builder: (context, child) {
        var state = Provider.of<QuizState>(context);
        Quiz quiz = Provider.of<QuizState>(context).quiz;

        return FutureBuilder(
            future: quizFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                quiz = snapshot.data ?? const Quiz(noteList: [], questions: []);

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
                        if (widget.questionType ==
                            QuestionType.multipleChoice) {
                          return MultipleChoiceQuestionPage(
                              question: quiz.questions[idx - 1]);
                        } else {
                          return WrittenAnswerQuestionPage(
                              question: quiz.questions[idx - 1]);
                        }
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
        : DialogData.BuildDialog(
            context,
            Text(
              "Sigurno?",
              style: pBold,
            ),
            Text(
              "Ako izađeš, tvoj napredak ovdje će biti izgubiti.",
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
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
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

void _multipleOptionBottomSheet(
  BuildContext context,
  QuizState state,
  Question question,
  String answer,
) {
  bool correct = question.note.definition == answer;
  bool scrollControlled = true;

  showModalBottomSheet(
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: scrollControlled,
    context: context,
    builder: (context) {
      if (question.note.definition.length > 250) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      correct ? "Tako je!\n" : "Netačno.\n",
                      textAlign: TextAlign.center,
                      style: pBold,
                    ),
                    Text(
                      "${question.note.definition} je tačan odgovor.",
                      textAlign: TextAlign.center,
                      style: p2.copyWith(
                        color: white,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (correct) state.correctQuestionsIndex++;
                          state.selected = '';
                          Navigator.pop(context);
                          state.nextPage();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                correct ? Colors.green : Colors.red),
                        child: Text(
                          correct ? "IDEEEE!" : "Ma ide iduća.",
                          style: pBold,
                        )),
                  ]),
            ),
          ],
        );
      } else {
        scrollControlled = false;
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  correct ? "Tako je!\n" : "Netačno.\n",
                  textAlign: TextAlign.center,
                  style: pBold,
                ),
                Text(
                  "${question.note.definition} je tačan odgovor.",
                  textAlign: TextAlign.center,
                  style: p2.copyWith(
                    color: white,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (correct) state.correctQuestionsIndex++;
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
      }
    },
  );
}

void _writtenTestBottomSheet(
  BuildContext context,
  QuizState state,
  Question question,
  String answer,
) {
  bool scrollControlled = true;

  showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: scrollControlled,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Uporedi sa svojim odgovorom",
                      textAlign: TextAlign.center,
                      style: pBold,
                    ),
                    Text(
                      "\nZa ovaj pojam definicija glasi:\n ${question.note.definition}",
                      textAlign: TextAlign.center,
                      style: p2.copyWith(
                        color: white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                FontAwesomeIcons.xmark,
                                size: 20,
                                color: black,
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder()),
                                backgroundColor:
                                    MaterialStateProperty.all(accent),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                state.nextPage();
                                state.writtenTestController.text = "";
                              },
                              label: Text(
                                textAlign: TextAlign.center,
                                "Ne valja",
                                style: p1.copyWith(color: black),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16, bottom: 30),
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                FontAwesomeIcons.circleCheck,
                                size: 20,
                                color: black,
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder()),
                                backgroundColor:
                                    MaterialStateProperty.all(accent),
                              ),
                              onPressed: () {
                                state.correctQuestionsIndex++;
                                Navigator.pop(context);
                                state.nextPage();

                                state.writtenTestController.text = "";
                              },
                              label: Text(
                                "Valja",
                                style: p2.copyWith(color: black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        );
      });
}

class WrittenAnswerQuestionPage extends StatelessWidget {
  final Question question;

  const WrittenAnswerQuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    final TextEditingController controller = state.writtenTestController;
    bool answerSubmitted = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: controller,
                    minLines: 5,
                    maxLines: 9,
                    enabled: !answerSubmitted,
                    textInputAction: TextInputAction.done,
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: "Upiši svoj odgovor",
                      border: OutlineInputBorder(
                        gapPadding: 2,
                        borderSide: BorderSide(
                          color: white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder()),
                    backgroundColor: MaterialStateProperty.all(accent),
                  ),
                  onPressed: () {
                    if (controller.text == '') {
                      DialogData.BuildDialog(
                          context,
                          Text("Nije sramota", style: pBold),
                          Text("Barem pokušaj nešto unijeti.",
                              style: p2.copyWith(color: black)),
                          [
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Ok")),
                          ]);
                    } else {
                      _writtenTestBottomSheet(
                        context,
                        state,
                        question,
                        controller.text,
                      );
                    }
                  },
                  icon: const Icon(
                    FontAwesomeIcons.circleCheck,
                    size: 30,
                    color: black,
                  ),
                  label: Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Predaj odgovor",
                                  style: p2.copyWith(color: black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        )
      ],
    );
  }
}

class MultipleChoiceQuestionPage extends StatelessWidget {
  final Question question;
  const MultipleChoiceQuestionPage({super.key, required this.question});

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
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder()),
                    backgroundColor: MaterialStateProperty.all(accent),
                  ),
                  onPressed: () {
                    state.selected = option;
                    _multipleOptionBottomSheet(
                      context,
                      state,
                      question,
                      option,
                    );
                  },
                  icon: Icon(
                    state.selected == option
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circle,
                    size: 30,
                    color: black,
                  ),
                  label: Wrap(
                    children: [
                      Container(
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
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
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
          "Broj pitanja: ${quiz.questions.length}\nTip pitanja: Višestruki izbor",
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
    FocusManager.instance.primaryFocus?.unfocus();
    final double percentage = double.parse(
        (((state.correctQuestionsIndex / quiz.questions.length) * 100)
            .toStringAsFixed(2)));
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
                        : percentage > 55
                            ? titles[2]
                            : titles[3],
                style: p2.copyWith(color: white),
              ),
            ],
          ),
          const Divider(),
          OutlinedButton.icon(
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black54)),
            ),
            icon: const Icon(FontAwesomeIcons.check),
            label: Text(
              'Završi kviz',
              style: pBold,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/notes');
            },
          )
        ],
      ),
    );
  }
}
