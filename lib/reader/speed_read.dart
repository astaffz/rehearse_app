import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/shared/shared.dart';

class SpeedReadCounter with ChangeNotifier {
  SpeedReadCounter({
    this.wordsPerMinute = 60,
    this.canceled = false,
  });

  bool canceled;
  int wordsPerMinute;
  String? currentWord;

  void runSpeedRead(List<String> words) {
    for (String word in words) {
      currentWord = word;
      notifyListeners();
      Future.delayed(Duration(seconds: (wordsPerMinute / 60).floor()));
      if (canceled) break;
    }
  }
}

class SpeedReedScreen extends StatefulWidget {
  const SpeedReedScreen(
      {super.key, required this.designatedText, required this.speed});

  final String designatedText;
  final int speed;

  @override
  State<SpeedReedScreen> createState() => _SpeedReedScreenState();
}

class _SpeedReedScreenState extends State<SpeedReedScreen> {
  @override
  Widget build(BuildContext context) {
    final words = widget.designatedText.split(' ');

    TextStyle p2White = p2.copyWith(color: white);
    return ChangeNotifierProvider(
      create: (_) => SpeedReadCounter(),
      builder: (context, child) {
        SpeedReadCounter counter = Provider.of<SpeedReadCounter>(context);

        counter.wordsPerMinute = widget.speed;
        counter.currentWord =
            "Pripremljeno je ${words.length} riječi \nPodešena brzina je: ${counter.wordsPerMinute} riječi po minuti.";
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(FontAwesomeIcons.backward)),
              centerTitle: true,
              title: Text(
                "Speedy Reader",
                style: pBold,
              )),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dakle u zbrci si ili želiš da se istreniraš.",
                  textAlign: TextAlign.center,
                  style: p2White,
                ),
                Text(
                  Provider.of<SpeedReadCounter>(context, listen: true)
                      .currentWord!,
                  textAlign: TextAlign.center,
                  style: p2White,
                ),
                ElevatedButton(
                  onPressed: () {
                    counter.runSpeedRead(words);
                  },
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),
                  child: Text(
                    "Počni!",
                    style: p2White,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
