import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/Utils/Constants.dart';
import '../main.dart';

class SettingsModel with ChangeNotifier {
  int _weight = 0;
  int _interval = 0;

  SettingsModel() {
    reset();
  }

  List<int> get cupSizes => _getAllCupSizes();
  int get cupSize => prefs.getInt('size') ?? 300;
  bool get shakeSettings => prefs.getBool('shake') ?? false;
  bool get dialogSeen => prefs.getBool('dialogSeen') ?? false;
  bool get powerSettings => prefs.getBool('power') ?? false;
  int get weight => _weight;
  String get gender => prefs.getString('gender') ?? 'choose';
  String get language => prefs.getString('language') ?? 'en';
  int get interval => _interval;
  double get dailyGoal => prefs.getDouble('dailyGoal') ?? 2500.0;

  /// Resets local values to stored values (from shared preferences)
  void reset() {
    _weight = prefs.getInt('weight') ?? 70;
    _interval = prefs.getInt('interval') ?? 60;
    notifyListeners();
  }

  List<int> _getAllCupSizes() {
    List<String> cupSizesStringList = (prefs.getStringList('customCupSizes') ?? []);
    List<int> cupSizesList = cupSizesStringList.map(int.parse).toList();
    return new List.from(Constants.cupSizes)..addAll(cupSizesList);
  }

  void resetCustomCups() {
    prefs.setStringList('customCupSizes', []);
    notifyListeners();
  }

  void addCustomCupSize(int cupSize) {
    if (Constants.cupSizes.contains(cupSize)) {
      return;
    }
    List<String> cupSizesStringList = (prefs.getStringList('customCupSizes') ?? []);
    cupSizesStringList.add(cupSize.toString());
    prefs.setStringList('customCupSizes', cupSizesStringList);
    notifyListeners();
    
  }

  void deleteCustomCupSize(int cupSize) {
    List<String> cupSizesStringList = (prefs.getStringList('customCupSizes') ?? []);
    cupSizesStringList.remove(cupSize.toString());
    prefs.setStringList('customCupSizes', cupSizesStringList);
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
  void updateDialogSeen(bool newValue) {
    prefs.setBool('dialogSeen', newValue);
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
