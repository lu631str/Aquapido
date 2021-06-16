import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/Utils/Constants.dart';
import '../main.dart';

class SettingsModel with ChangeNotifier {
  int _weight = 0;
  int _interval = 0;
  bool _reminderSound = false;
  bool _reminderVibration = true;

  SettingsModel() {
    reset();
  }

  List<int> get cupSizes => _getAllCupSizes();
  TimeOfDay get startSleepTime => _getStartSleepTime();
  TimeOfDay get endSleepTime => _getEndSleepTime();
  int get cupSize => prefs.getInt('size') ?? 300;
  bool get shakeSettings => prefs.getBool('shake') ?? false;
  bool get powerSettings => prefs.getBool('power') ?? false;
  bool get reminder => prefs.getBool('reminder') ?? false;
  bool get reminderVibration => _reminderVibration;
  bool get reminderSound => _reminderSound;
  int get weight => _weight;
  String get gender => prefs.getString('gender') ?? 'choose';
  String get language => prefs.getString('language') ?? 'en';
  int get interval => _interval;
  double get dailyGoal => prefs.getDouble('dailyGoal') ?? 2500.0;

  List<int> _getAllCupSizes() {
    List<String> cupSizesStringList = (prefs.getStringList('customCupSizes') ?? []);
    List<int> cupSizesList = cupSizesStringList.map(int.parse).toList();
    return new List.from(Constants.cupSizes)..addAll(cupSizesList);
  }

  TimeOfDay _getStartSleepTime() {
    int startTimeHours = prefs.getInt('startTimeHours') ?? 20;
    int startTimeMinutes = prefs.getInt('startTimeMinutes') ?? 0;
    return TimeOfDay(hour: startTimeHours, minute: startTimeMinutes);
  }

 TimeOfDay _getEndSleepTime() {
    int endTimeHours = prefs.getInt('endTimeHours') ?? 8;
    int endTimeMinutes = prefs.getInt('endTimeMinutes') ?? 0;
    return TimeOfDay(hour: endTimeHours, minute: endTimeMinutes);
  }
  
  /// Resets local values to stored values (from shared preferences)
  void reset() {
    _weight = prefs.getInt('weight') ?? 70;
    _interval = prefs.getInt('interval') ?? 60;
    _reminderSound = prefs.getBool('reminderSound') ?? false;
    _reminderVibration = prefs.getBool('reminderVibration') ?? true;
    notifyListeners();
  }

   /// Sets local startSleepTime.
  void setEndSleepTime(TimeOfDay newValue) {
    prefs.setInt('endTimeHours', newValue.hour);
    prefs.setInt('endTimeMinutes', newValue.minute);
    notifyListeners();
  }

  /// Sets local startSleepTime.
  void setStartSleepTime(TimeOfDay newValue) {
    prefs.setInt('startTimeHours', newValue.hour);
    prefs.setInt('startTimeMinutes', newValue.minute);
    notifyListeners();
  }



  void resetCustomCups() {
    prefs.setStringList('customCupSizes', []);
    notifyListeners();
  }

  /// Saves custom [cupSize] to sharedPreferences within a string array.
  void addCustomCupSize(int cupSize) {
    if (Constants.cupSizes.contains(cupSize)) {
      return;
    }
    List<String> cupSizesStringList = (prefs.getStringList('customCupSizes') ?? []);
    cupSizesStringList.add(cupSize.toString());
    prefs.setStringList('customCupSizes', cupSizesStringList);
    notifyListeners();
  }

  /// Deletes custom [cupSize] to sharedPreferences from the string array.
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
  void updateReminder(bool newValue) {
    prefs.setBool('reminder', newValue);
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
  }

  /// Sets local ReminderSound.
  void setReminderSound(bool newValue) {
    _reminderSound = newValue;
    notifyListeners();
  }

  /// Saves local ReminderSound to sharedPreferences.
  void saveReminderSound() {
    prefs.setBool('reminderSound', _reminderSound);
  }

  /// Sets local Reminder Vibration.
  void setReminderVibration(bool newValue) {
    _reminderVibration = newValue;
    notifyListeners();
  }

  /// Saves local ReminderVibration to sharedPreferences.
  void saveReminderVibration() {
    prefs.setBool('reminderVibration', _reminderVibration);
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
