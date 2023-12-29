import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/splash_screen.dart';
import 'package:rehearse_app/services/app_routes.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/theme.dart';

void main() {
  runApp(const App());

  WidgetsFlutterBinding.ensureInitialized();
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
