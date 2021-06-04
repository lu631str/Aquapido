import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class SettingsModel with ChangeNotifier {
  int _weight = 0;
  int _interval = 0;

  SettingsModel() {
    reset();
  }

  int get cupSize => prefs.getInt('size') ?? 300;
  bool get shakeSettings => prefs.getBool('shake') ?? false;
  bool get powerSettings => prefs.getBool('power') ?? false;
  int get weight => _weight;
  String get gender => prefs.getString('gender') ?? 'choose';
  String get language => prefs.getString('language') ?? Locale('en');
  int get interval => _interval;
  double get dailyGoal => prefs.getDouble('dailyGoal') ?? 2500.0;

  /// Resets local values to stored values (from shared preferences)
  void reset() {
    _weight = prefs.getInt('weight') ?? 70;
    _interval = prefs.getInt('interval') ?? 60;
    notifyListeners();
  }

  /// Saves [newValue] to sharedPreferences.
  void updateCupSize(int newValue) {
    prefs.setInt('size', newValue);
    notifyListeners();
  }

  /// Saves [newValue] to sharedPreferences.
  void updateShakeSettings(bool newValue) {
    prefs.setBool('shake', newValue);
    notifyListeners();
  }

  /// Saves [newValue] to sharedPreferences.
  void updatePowerSettings(bool newValue) {
    prefs.setBool('power', newValue);
    notifyListeners();
  }

  /// Sets local weight.
  void setWeight(int newValue) {
    _weight = newValue;
    notifyListeners();
  }

  /// Saves local weight to sharedPreferences.
  void saveWeight() {
    prefs.setInt('weight', _weight);
  }

  /// Saves [newValue] to sharedPreferences.
  void updateGender(String newValue) {
    prefs.setString('gender', newValue);
    notifyListeners();
  }

  /// Saves [newValue] to sharedPreferences.
  void updateLanguage(String newValue) {
    prefs.setString('language', newValue);
    notifyListeners();
  }

  /// Sets local interval.
  void setInterval(int newValue) {
    _interval = newValue;
    notifyListeners();
  }

  /// Saves local interval to sharedPreferences.
  void saveInterval() {
    prefs.setInt('interval', _interval);
  }

  /// Saves [newValue] to sharedPreferences.
  void updateDailyGoal(double newValue) {
    prefs.setDouble('dailyGoal', newValue);
    notifyListeners();
  }
}
