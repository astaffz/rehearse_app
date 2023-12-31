import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/models/quiz_model.dart';
import 'package:rehearse_app/shared/progress_bar.dart';
import 'package:rehearse_app/shared/styles.dart';
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
              if (snapshot.hasData && !snapshot.hasError) {
                state.quiz = snapshot.data ?? const Quiz(questions: []);
                return Scaffold(
                  appBar: AppBar(
                    title: ProgressBar(value: state.progress),
                    leading: IconButton(
                      icon: const Icon(FontAwesomeIcons.xmark),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  body: LayoutBuilder(builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        controller: state.controller,
                        onPageChanged: (int idx) {
                          state.progress = (idx / (quiz.questions.length + 1));
                        },
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return StartPage(quiz: quiz);
                          } else if (index == quiz.questions.length + 1) {
                            return Placeholder();
                          } else {
                            return QuestionPage(
                                question: quiz.questions[index - 1]);
                          }
                        },
                      ),
                    );
                  }),
                );
              } else {
                return const Text("Error");
              }
            });
      },
    );
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.question});

  final Question question;
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Column(
      children: [
        Expanded(
          child: Text(
            question.question,
            style: pBold,
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
                color: Colors.black26,
                child: ElevatedButton(
                  onPressed: () {
                    state.selected = option;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          state.selected == option
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.circle,
                          size: 30,
                          color: white,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              option,
                              style: p2.copyWith(color: white),
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
        ),
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
