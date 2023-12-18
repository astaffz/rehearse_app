import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehearse_app/shared/shared.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RehearseAppLogo,
        SizedBox(width: large),
        const Text(
          'Powered by Gelegenheit.',
          style: TextStyle(
            color: white,
          ),
        ),
      ]),
    ));
  }
}
