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
    List<Water> list = await waterList();
    notifyListeners();
    return list;
  }

  Future<int> getTotalCupsToday() async {
    int cups = await totalCupsToday();
    notifyListeners();
    return cups;
  }


}