import 'package:flutter/material.dart';
import 'package:rehearse_app/shared/shared.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double height;
  const ProgressBar({super.key, required this.value, this.height = 12});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(10),
          width: constraints.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: constraints.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _colorGen(value),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  Color _colorGen(double value) {
    int rbg = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rbg).withRed(255 - rbg);
  }
}

// class QuizProgress extends StatelessWidget {
//   const QuizProgress({super.key, required this.quiz});

//   final Quiz quiz;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: ProgressBar(
//               value: _calculateProgress(topic, report), height: 8),
//         ),
//       ],
//     );
//   }

//   Widget _progressCount( c) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8),
//       child: Text(
//         '${report.topics[topic.id]?.length ?? 0} / ${topic.quizzes.length}',
//         style: const TextStyle(fontSize: 10, color: Colors.grey),
//       ),
//     );
//   }

//   double _calculateProgress(Quiz quiz, Report report) {
//     try {
//       int totalQuestions = quiz.questions.length;
//       int completedQuestions;
//       return completedQuizzes / totalQuizzes;
//     } catch (err) {
//       return 0.0;
//     }
//   }
// }
// TODO: COMEBACK LATER
