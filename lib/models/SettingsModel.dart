import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/main.dart';

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
  String get language => prefs.getString('language') ?? Locale("en");
  int get interval => _interval;
  double get dailyGoal => prefs.getDouble('dailyGoal') ?? 2500.0;

  void reset() {
    _weight = prefs.getInt('weight') ?? 70;
    _interval = prefs.getInt('interval') ?? 60;
    notifyListeners();
  }

  void updateCupSize(newValue) {
    prefs.setInt('size', newValue);
    notifyListeners();
  }

  void updateShakeSettings(newValue) {
    prefs.setBool('shake', newValue);
    notifyListeners();
  }

  void updatePowerSettings(newValue) {
    prefs.setBool('power', newValue);
    notifyListeners();
  }

  void updateWeight(newValue) {
    _weight = newValue;
    notifyListeners();
  }

  void saveWeight() {
    prefs.setInt('weight', _weight);
  }

  void updateGender(newValue) {
    prefs.setString('gender', newValue);
    notifyListeners();
  }

  void updateLanguage(newValue) {
    prefs.setString('language', newValue);
    notifyListeners();
  }

  void updateInterval(newValue) {
    _interval = newValue;
    notifyListeners();
  }

  void saveInterval() {
    prefs.setInt('interval', _interval);
  }

  void updateDailyGoal(newValue) {
    prefs.setDouble('dailyGoal', newValue);
    notifyListeners();
  }
}
