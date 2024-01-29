import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rehearse_app/reader/reader_screen.dart';
import 'package:rehearse_app/screens/login_screen.dart';
import 'package:rehearse_app/notes/notebook_screen.dart';
import 'package:rehearse_app/reminders/notifications_screen.dart';
import 'package:rehearse_app/screens/splash_screen.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> welcomeMessages = [
      "Ćao doktore, nastavljaš rasturat'?",
      "Pozdrav vizionaru, kako oblikuješ budućnost danas?",
      "Gdje si pobjedniče, osvajaš li svoje bitke danas?",
      "Gdje si inspiracijo, kako širiš svoju svjetlost danas?",
      "Ej magijo, kakvo čudo danas nas očekuje?",
      "Poštovanje kapetane, kuda plovimo danas?",
      "Gdje si lavino, kakve prepreke danas rušimo?",
      "Poštovanje velikane, i danas dominiramo?",
      "Ćao lave, samo nastavi!",
      "Oho šampionu, i danas punom parom?",
      "Gdje si zvijezdo, koliko nam danas sijajiš?",
    ];
    List<String> options = ["Moji zapisi", "Moji podsjetnici", "Moj reader"];
    final random = Random();

    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        Widget screen;
        if (snapshot.connectionState == ConnectionState.waiting) {
          screen = const SplashScreen();
        } else if (!snapshot.hasData) {
          screen = const LoginScreen();
        } else {
          screen = Scaffold(
            backgroundColor: icon.withAlpha(200),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // APPBAR - "REHEARSEapp"
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RehearseAppLogo,
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Text(
                          welcomeMessages[
                              random.nextInt(welcomeMessages.length)],
                          style: heading3.copyWith(color: white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // OPTION-BOX
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: OptionWidget(options: options),
                ),
              ],
            ),
          );
        }
        return screen;
      },
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
        return const NotificationsScreen();

      case 2:
        return const ReaderScreen();
      default:
        throw Exception("No page selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'option.select',
      child: Material(
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
      ),
    );
  }
}
