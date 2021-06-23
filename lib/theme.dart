import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
 * Benutzerdefinierte Name-Wert Paare zur Bestimmung weiterer visueller Eigenschaften. 
 */
class CustomizedThemeFields {
  const CustomizedThemeFields(
      {this.cardColor, this.primarySwatch, this.fontFamily, this.dateStyle, this.backgroundDecoration});

  // Farbwert fuer Card background
  final Color cardColor;
  // Text Style fuer Zeitstempel in Liste
  final TextStyle dateStyle;
  // Style fuer Hintergrund
  final BoxDecoration backgroundDecoration;
  final Color primarySwatch;
  final String fontFamily;

  factory CustomizedThemeFields.empty() {
    return CustomizedThemeFields(
        cardColor: Colors.white, backgroundDecoration: BoxDecoration());
  }
}

/**
 * Extension fuer bestehende Klasse ThemeData. Die Erweiterung fuegt benutzerdefinierte Name-Wert Paare dem ThemeData hinzu
 */
extension ThemeDataExtensions on ThemeData {
  static Map<InputDecorationTheme, CustomizedThemeFields> _own = {};

  void addOwn(CustomizedThemeFields own) {
    _own[inputDecorationTheme] = own;
  }

  static CustomizedThemeFields empty = null;
  CustomizedThemeFields own() {
    CustomizedThemeFields o = _own[inputDecorationTheme];
    if (o == null) {
      empty ??= CustomizedThemeFields.empty();
      o = empty;
    }
    return o;
  }
}

// Helper-Methode, um einfacher auf Theme zuzugreifen
CustomizedThemeFields ownTheme(BuildContext context) => Theme.of(context).own();

// Beispielhaftes Light Theme
final ThemeData lightTheme = (ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  accentColor: Colors.grey.withAlpha(128),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.amber,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.brown,
      foregroundColor: Colors.amber,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 32.0),
    headline4: TextStyle(fontSize: 24.0),
    bodyText2: TextStyle(fontSize: 14.0),
  ),
))
  // benutzerdefinierte Einstellungen setzen
  ..addOwn(CustomizedThemeFields(
      cardColor: Colors.blue.shade400.withOpacity(0.8),
      primarySwatch: Colors.blue,
      fontFamily: GoogleFonts.comfortaa().fontFamily,
      dateStyle: const TextStyle(fontSize: 12),
      // Als Hintergrund wird ein benutzerdefiniertes Bild im Asset Folder benutzt
      backgroundDecoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        ),
      )));
