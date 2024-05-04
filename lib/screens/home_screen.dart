import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/login_screen.dart';
import 'package:rehearse_app/notes/notebook_screen.dart';
import 'package:rehearse_app/reminders/notifications_screen.dart';
import 'package:rehearse_app/screens/settings_screen.dart';
import 'package:rehearse_app/screens/splash_screen.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  List<IconData> options = [Icons.notes, Icons.calendar_month];
  final random = Random();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.userStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        Widget screen;
        if (snapshot.connectionState == ConnectionState.waiting) {
          screen = const SplashScreen();
        } else if (!snapshot.hasData) {
          screen = const LoginScreen();
        } else {
          screen = Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              elevation: 4,
              backgroundColor: forestGreen,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: options
                  .map((e) => BottomNavigationBarItem(
                      label: e.toString(),
                      icon: Icon(
                        e,
                        color: white,
                      )))
                  .toList(),
              currentIndex: pageIndex,
            ),
            backgroundColor: forestAccent,
            appBar: AppBar(
              elevation: 4,
              toolbarHeight: 75,
              backgroundColor: forestAccent,
              title: Text("RehearseApp", style: heading1),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                  color: white,
                  iconSize: 35,
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: forestGreen,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 20),
                  child: Text(
                    welcomeMessages[random.nextInt(welcomeMessages.length)],
                    style: heading3.copyWith(color: white),
                    textAlign: TextAlign.left,
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      color: forestBackground,
                      height: 190,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Nadolazeći planovi",
                                  style: pBold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: forestAccent,
                                      shape: const RoundedRectangleBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/notifications');
                                  },
                                  child: Text("Pogledaj sve", style: p1Bold))
                            ]),
                      ),
                    ),
                    Container(
                      height: 130,
                      color: background,
                      //TODO: FILL IN CONTAINER
                    )
                  ],
                )
                // OPTION-BOX
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
        return const SettingsScreen();
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
