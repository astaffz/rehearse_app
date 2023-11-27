import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehearse_app/utils/styles.dart';
import 'package:rehearse_app/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';

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
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const HomeScreen(),
          ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Material(
                color: heading,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.edit,
                    color: icon,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'RehearseApp',
                style: heading1.copyWith(color: black),
              )
            ],
          ),
          SizedBox(width: large),
          const Text(
            'Powered by Gelegenheit.',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
