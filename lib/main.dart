import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/splash_screen.dart';
import 'package:rehearse_app/services/app_routes.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/utils/theme.dart';
import 'package:rehearse_app/shared/shared.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

extension StringExtension on String {
  String capitalize() {
    return replaceFirst(this[0], this[0].toUpperCase());
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  void dispose() {
    DatabaseHelper databaseHelper = DatabaseHelper();
    super.dispose();
    databaseHelper.closeDb();
  }

  @override
  void initState() {
    super.initState();
    RehearseAppNotificationManager.init();
    RehearseAppNotificationManager.recievedResponses.stream.listen((event) {
      Navigator.of(context).pushNamed('/notifications');
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
