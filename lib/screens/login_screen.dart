import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RehearseAppLogo,
            Flexible(
                child: LoginButton(
              icon: FontAwesomeIcons.userNinja,
              text: "Nastavi bez Ulogovanja",
              method: AuthService().anonLogin,
              color: accent,
            ))
          ]),
    ));
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
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => color)),
        label: Text(text, style: heading4.copyWith(color: white)),
        onPressed: () => method(),
      ),
    );
  }
}
