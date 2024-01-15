import 'package:rehearse_app/screens/home_screen.dart';
import 'package:rehearse_app/notes/notebook_screen.dart';
import 'package:rehearse_app/reminders/notifications_screen.dart';
import 'package:rehearse_app/screens/tips_screen.dart';
import 'package:rehearse_app/screens/login_screen.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/tips': (context) => const TipsScreen(),
  '/login': (context) => const LoginScreen(),
  '/notes': (context) => const NotebookScreen(),
  '/notifications': (context) => const NotificationsScreen(),
};
