import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [background, icon],
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
              ),
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RehearseAppLogo,
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoginButton(
                        icon: FontAwesomeIcons.google,
                        text: "Poveži sa GRačunom",
                        method: AuthService().loginWGoogle,
                        color: Colors.blueAccent,
                      ),
                      LoginButton(
                        icon: FontAwesomeIcons.userTie,
                        text: "Kreiraj svoj profil",
                        method: AuthService()
                            .anonLogin, //TODO: Burageru napravi profile za ovaj brat, more!
                        color: heading,
                      ),
                      LoginButton(
                        icon: FontAwesomeIcons.magnifyingGlassArrowRight,
                        text: "Možda kasnije",
                        method: AuthService().anonLogin,
                        color: background,
                      ),
                    ]),
              ],
            )));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.method,
  });

  final Color color;
  final IconData icon;
  final String text;
  final Function method;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: white, size: 20),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
        label: Text(
          text,
          style: heading4.copyWith(color: white),
          maxLines: 1,
        ),
        onPressed: () => method(),
      ),
    );
  }
}
