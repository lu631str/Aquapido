import 'package:flutter/foundation.dart';
import '../Models/Water.dart';
import '../Persistence/Database.dart';

class WaterModel with ChangeNotifier {

  void addWater(Water water) {
    insertWater(water);
    notifyListeners();
  }

  void removeWater(Water water) {
    deleteWater(water);
    notifyListeners();
  }

  Future<List<Water>> getAllWater() async {
    final List<Water> list = await waterList();
    notifyListeners();
    return list;
  }

  Future<int> getTotalCupsToday() async {
    final int cups = await totalCupsToday();
    notifyListeners();
    return cups;
  }

Future<double> averageCupsPerDay() async {
    final double cups = await getAverageCupsPerDay();
    notifyListeners();
    return cups;
  }

  Future<double> averageLitersPerDay() async {
    final double liters = await getAverageLitersPerDay();
    notifyListeners();
    return liters;
  }

}