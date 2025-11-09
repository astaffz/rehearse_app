// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

  @override
  String get login_internetconnection =>
      'Internet konekcija je potrebna pri prijavljivanju ili registriranju. Korisno za skladištenje i sinhronizaciju Vaših podataka sa Vašim drugim uređajima.';

  @override
  String get login_signin => 'Prijavi se';

  @override
  String get login_register => 'Kreiraj profil';

  @override
  String get login_noaccount => 'Nije mi potreban profil';
}
