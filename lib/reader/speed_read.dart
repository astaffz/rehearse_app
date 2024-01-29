import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/shared/shared.dart';

class SpeedReadCounter extends ChangeNotifier {
  SpeedReadCounter({
    required this.wordsPerMinute,
  });

  bool _started = false;
  int wordsPerMinute;
  String _currentWord = 'test';

  String get currentWord => _currentWord;

  void setWord(String word) {
    _currentWord = word;
    notifyListeners();
  }

  void startSpeedRead() {
    _started = true;
    notifyListeners();
  }

  void endSpeedRead() {
    _started = false;
    notifyListeners();
  }

  bool get hasStarted => _started;
  Future runSpeedRead(List<String> words, [int index = -1]) async {
    startSpeedRead();
    notifyListeners();
    if (index == -1) {
      for (String word in words) {
        setWord(word);
        await Future.delayed(
            Duration(milliseconds: ((60 / wordsPerMinute) * 1000).ceil()));
        if (!hasStarted) break;
      }
    } else {
      for (int i = index; i < words.length; i++) {
        setWord(words[i]);
        await Future.delayed(
            Duration(milliseconds: ((60 / wordsPerMinute) * 1000).ceil()));
        if (!hasStarted) break;
      }
    }
    endSpeedRead();
  }
}

class SpeedReedScreen extends StatelessWidget {
  SpeedReedScreen(
      {super.key, required this.designatedText, required this.speed});

  final String designatedText;
  final int speed;
  List<String> words = [];
  bool hasStarted = false;
  @override
  Widget build(BuildContext context) {
    words = designatedText.split(' ');
    TextStyle p2White = p2.copyWith(color: white);

    return ChangeNotifierProvider(
        create: (_) => SpeedReadCounter(wordsPerMinute: speed),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      if (!hasStarted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(FontAwesomeIcons.backward)),
                centerTitle: true,
                title: Text(
                  "Moj brzi reader",
                  style: pBold,
                )),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !Provider.of<SpeedReadCounter>(context, listen: true)
                            .hasStarted
                        ? Text(
                            "Pripremljeno je ${words.length} riječi \nPodešena brzina je: ${Provider.of<SpeedReadCounter>(context, listen: false).wordsPerMinute} riječi po minuti.",
                            style: p2.copyWith(color: white))
                        : Text(
                            Provider.of<SpeedReadCounter>(context).currentWord,
                            style: pBold.copyWith(color: white)),
                    ElevatedButton(
                      onPressed: () {
                        if (!hasStarted) {
                          Provider.of<SpeedReadCounter>(context, listen: false)
                              .startSpeedRead();
                          hasStarted = true;

                          Provider.of<SpeedReadCounter>(context, listen: false)
                              .runSpeedRead(
                                  words,
                                  words.indexOf(Provider.of<SpeedReadCounter>(
                                          context,
                                          listen: false)
                                      .currentWord));
                        } else {
                          Provider.of<SpeedReadCounter>(context, listen: false)
                              .endSpeedRead();
                          hasStarted = false;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder()),
                      child: Text(
                        !Provider.of<SpeedReadCounter>(context, listen: false)
                                .hasStarted
                            ? "Započni"
                            : "Pauziraj",
                        style: p2White,
                      ),
                    ),
                  ]),
            ),
          );
        });
  }
}
