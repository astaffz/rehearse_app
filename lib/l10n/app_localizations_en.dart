// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login_internetconnection =>
      'In order to sign up / log in, an internet connection is required. Useful for storing and synchronaising your data on multiple devices.';

  @override
  String get login_signin => 'Sign in';

  @override
  String get login_register => 'Create an account';

  @override
  String get login_noaccount => 'I don\'t need an account';
}
