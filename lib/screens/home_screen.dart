import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/login_screen.dart';
import 'package:rehearse_app/screens/notebook_screen.dart';
import 'package:rehearse_app/screens/splash_screen.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> welcomeMessages = [
      "Ćao doktore, nastavljaš rasturat'?"
    ]; // TODO: Add more messages
    List<String> options = ["Moji zapisi", "Moji podsjetnici", "Moj reader"];
    final random = new Random();

    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (!snapshot.hasData) {
          return const LoginScreen();
        } else {
          return Scaffold(
            backgroundColor: icon.withAlpha(150),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // APPBAR - "REHEARSEapp"
                const RehearseAppBar(),
                const SizedBox(
                  height: 10,
                ),
                // WELCOME MESSAGE
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Text(
                    welcomeMessages[random.nextInt(welcomeMessages.length)],
                    style: heading3.copyWith(color: white),
                    textAlign: TextAlign.left,
                  ),
                ),
                // OPTION-BOX
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
                  child: OptionWidget(options: options),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class RehearseAppBar extends StatelessWidget {
  const RehearseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Container(
        color: white,
        width: small,
        height: small,
        child: Icon(
          Icons.edit,
          color: accent,
          size: medium,
        ),
      ),
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      color: accentLight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 15, 0, 266),
        // COLUMN WITH OPTIONS
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                trailing: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: accent,
                  size: medium,
                ),
                titleTextStyle: pBold.copyWith(color: black),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getDestinationPage(index),
                      ));
                },
              );
            },
          )
        ]),
      ),
    );
  }
}
