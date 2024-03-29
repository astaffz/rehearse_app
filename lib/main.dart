import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/splash_screen.dart';
import 'package:rehearse_app/services/app_routes.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/utils/theme.dart';
import 'package:rehearse_app/shared/shared.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  DatabaseHelper databaseHelper = DatabaseHelper();
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  databaseHelper.database;
  runApp(const App());
}

extension StringExtension on String {
  String capitalized() {
    return replaceFirst(this[0], this[0].toUpperCase());
  }
}

extension HexColor on Color {
  String _generateAlpha({required int alpha, required bool withAlpha}) {
    if (withAlpha) {
      return alpha.toRadixString(16).padLeft(2, '0');
    } else {
      return '';
    }
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void dispose() {
    super.dispose();
    databaseHelper.closeDb();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        RehearseAppNotificationManager.init();
        RehearseAppNotificationManager.recievedResponses.stream.listen((event) {
          Navigator.of(context).pushNamed('/notifications');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text('error');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Directionality(
              textDirection: TextDirection.ltr, child: SplashScreen());
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: appRoutes,
          theme: theme,
        );
      },
    );
  }
}
