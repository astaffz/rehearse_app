import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rehearse_app/services/auth.dart';
import 'package:rehearse_app/shared/shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: forestAccentDark,
      appBar: AppBar(
        elevation: 4,
        toolbarHeight: 85,
        backgroundColor: forestAccent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.circleXmark,
              color: white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Postavke",
            style: heading1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      backgroundColor: forestAccent),
                  onPressed: () {
                    print("2");
                  },
                  icon: AuthService.user?.photoURL != null
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.black12,
                                  width: 2.5,
                                  strokeAlign: BorderSide.strokeAlignInside)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              AuthService.user!.photoURL!,
                              width: 96.0,
                              height: 96.0,
                            ),
                          ),
                        )
                      : const Icon(
                          FontAwesomeIcons.circleUser,
                          color: white,
                          size: 70,
                        ),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: !AuthService.user!.isAnonymous
                          ? [
                              // Logged-in user profile
                              Text(
                                AuthService.user!.displayName ??
                                    "UserData not loaded",
                                maxLines: 1,
                                style: pBold,
                              ),
                              Text(
                                "${AuthService.user!.email!}\n ",
                                style: p3Bold,
                              ),
                              Text(
                                "Korisnik: #${AuthService.user?.uid}...",
                                style: p3Bold,
                                maxLines: 1,
                              ),
                            ]
                          : [
                              // Guest user profile
                              Text(
                                "Rehearser #${AuthService.user?.uid.substring(0, 5)}..",
                                maxLines: 1,
                                style: pBold,
                              ),
                              Text(
                                "Profil nesinhroniziran!\n ",
                                style: p3Bold,
                              ),
                            ],
                    ),
                  )),
              const SizedBox(
                height: 17,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await AuthService.signOut();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: forestAccent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)))),
                  child: Text(
                    AuthService.user!.isAnonymous ? "Prijavi se" : "Odjavi se",
                    style: p1Bold.copyWith(color: black),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await AuthService.signOut();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: forestAccent,
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jezik aplikacije:", style: p1Bold),
                        Text(FirebaseAuth.instance.languageCode ?? "Bosanski",
                            style: p1.copyWith(color: white)),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
