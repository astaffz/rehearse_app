import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/notebook_screen.dart';
import 'package:rehearse_app/utils/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> welcomeMessages = [
      "Ćao doktore, nastavljaš rasturat'?"
    ]; // TODO: Add more messages
    List<String> options = ["Moji zapisi", "Moji podsjetnici", "Moj reader"];
    final random = new Random();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: accent,
      ),
      home: Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // APPBAR - "REHEARSEapp"
              const RehearseAppBar(),
              const SizedBox(
                height: 80,
              ),
              // WELCOME MESSAGE
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 20.0, 20.0, 20.0),
                child: Text(
                  welcomeMessages[random.nextInt(welcomeMessages.length)],
                  style: heading2.copyWith(color: white),
                  textAlign: TextAlign.left,
                ),
              ),
              // OPTION-BOX
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 15, 20, 10),
                child: OptionWidget(options: options),
              ),

              const Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.question_mark_sharp,
                      color: icon,
                      weight: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RehearseAppBar extends StatelessWidget {
  const RehearseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: background,
      leading: const Material(color: heading),
      leadingWidth: 26,
      title: Text("RehearseApp", style: heading2),
    );
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    super.key,
    required this.options,
  });

  final List<String> options;
  Widget getDestinationPage(int index) {
    switch (index) {
      case 0:
        return const NotebookScreen();
      case 1:
        return const NotebookScreen();
      case 2:
        return const NotebookScreen();
      default:
        throw Exception("No page selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: accentLight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 15, 15, 20),
        // COLUMN WITH OPTIONS
        child: Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length * 2,
              itemBuilder: (context, index) {
                final actualIndex = index ~/ 2;
                if (!index.isEven) {
                  return const Padding(
                    padding: EdgeInsets.zero,
                    child: dividerAccent,
                  );
                } else {
                  final dataIndex = actualIndex;
                  return ListTile(
                    title: Text(options[dataIndex]),
                    titleTextStyle: pBold.copyWith(color: black),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => getDestinationPage(dataIndex),
                          ));
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}
