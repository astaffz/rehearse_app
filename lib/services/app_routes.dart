import 'package:rehearse_app/models/quiz_model.dart';
import 'package:rehearse_app/screens/home_screen.dart';
import 'package:rehearse_app/screens/quiz_screen.dart';
import 'package:rehearse_app/screens/tips_screen.dart';
import 'package:rehearse_app/screens/login_screen.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/tips': (context) => const TipsScreen(),
  '/login': (context) => const LoginScreen(),
};
