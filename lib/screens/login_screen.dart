import 'package:flutter/material.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _chosenLanguage = "bs";
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
                        if (text != null) {
                          App.setLocale(context, Locale(text));
                          _chosenLanguage = text;
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: "bs",
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
                          value: "en",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset('assets/flag-en.png'),
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
                Builder(builder: (context) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginButton(
                          text: AppLocalizations.of(context)!.login_signin,
                          method: AuthService.loginWGoogle,
                          color: icon,
                        ),
                        LoginButton(
                          text: AppLocalizations.of(context)!.login_register,
                          method: AuthService.loginWGoogle,
                          image: "assets/rhapp.png",
                          color: icon,
                        ),
                        LoginButton(
                          text: AppLocalizations.of(context)!.login_noaccount,
                          method: AuthService.anonLogin,
                          color: background,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 30.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .login_internetconnection,
                            maxLines: 5,
                            style: p3,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ]);
                }),
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
                padding: const EdgeInsets.symmetric(horizontal: 25.5),
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
