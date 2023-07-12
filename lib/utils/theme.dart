import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

const double defaultPadding = 20;
const double bottomNavigationBarBorderRadius = 40;
const double homePageUserIconSize = 40;
const double familyIcon = 40;
const double settingsPageUserIconSize = 90;

ThemeData globalTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    scaffoldBackgroundColor: background,
    primarySwatch: primarySwatch,
    dividerColor: dividerColor,
    secondaryHeaderColor: Colors.grey[700],
    primaryColor: primaryColor,
    canvasColor: background,
    cardColor: background,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: primaryColor,
      primary: primaryColor,
    ),
    textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: textColorDark,
      displayColor: textColorLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      alignLabelWithHint: false,
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: primaryColor,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          width: 1,
          color: dividerColor.withOpacity(0.2),
        ),
      ),
    ),
  );
}
