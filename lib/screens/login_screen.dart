import 'package:flutter/material.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _chosenLanguage = "bosnian";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 130,
                  height: 54,
                  alignment: Alignment.topCenter,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      side: BorderSide(color: black),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: DropdownButton<String>(
                      icon: const Icon(
                        null,
                        size: 0,
                      ),
                      isExpanded: true,
                      underline: SizedBox(),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      value: _chosenLanguage,
                      onChanged: (text) {
                        setState(() {
                          _chosenLanguage = text ?? "bosnian";
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: "bosnian",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset('assets/flag-ba.png'),
                              Text(
                                'BA',
                                style: heading4.copyWith(color: black),
                              )
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "english",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset('assets/flag-ba.png'),
                              Text(
                                'EN',
                                style: heading4.copyWith(color: black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RehearseAppLogo,
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginButton(
                        text: "Prijavi se",
                        method: AuthService.loginWGoogle,
                        color: icon,
                      ),
                      const LoginButton(
                        text: "Kreiraj profil",
                        method: AuthService.loginWGoogle,
                        image: "assets/rhapp.png",
                        color: icon,
                      ),
                      const LoginButton(
                        text: "Nije mi potreban profil",
                        method: AuthService.anonLogin,
                        color: background,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 30.0),
                        child: Text(
                          "Internet konekcija je potrebna pri prijavljivanju ili registriranju. Korisno za skladištenje i sinhronizaciju Vaših podataka sa Vašim drugim uređajima.",
                          style: p3,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]),
              ],
            )));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.color,
    this.icon,
    this.image,
    required this.text,
    required this.method,
  });

  final Color color;
  final IconData? icon;
  final String text;
  final String? image;
  final Function method;
  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              elevation: 4,
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.5),
                child: Image.asset(
                  image!,
                  width: 30,
                  height: 30,
                ),
              ),
              Text(
                text,
                style: p1Bold.copyWith(color: white),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          onPressed: () => method(),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              elevation: 4,
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3))),
          child: Text(
            text,
            style: p1Bold.copyWith(color: white),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          onPressed: () => method(),
        ),
      );
    }
  }
}
