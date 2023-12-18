import 'package:flutter/material.dart';
import 'package:rehearse_app/shared/shared.dart';

var theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: accent,
  textTheme: TextTheme(
    bodyLarge: heading1,
    bodyMedium: heading3,
    bodySmall: heading4,
  ),
);
