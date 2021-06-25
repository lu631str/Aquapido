import 'dart:developer';
import 'package:flutter/foundation.dart';
import "package:collection/collection.dart";
import 'package:sqflite/sqflite.dart';
import '../main.dart';

import '../Models/DailyGoal.dart';
import '../Models/Water.dart';
import '../Persistence/Database.dart';
import '../Utils/utils.dart';

class WaterModel with ChangeNotifier {
  WaterModel() {
    _loadHistoryFromDB();
  }

  void _loadHistoryFromDB() {
    _waterList()
        .then((list) => {history = list.reversed.toList(), notifyListeners()});
  }

  List<Water> history = [];

  // Public Methods

  void addWater(int index, Water water) {
    if (history.first.isPlaceholder) {
      history.clear();
    }
    history.insert(index, water);

    _insertWater(water);

    double dailyGoal = prefs.getDouble('dailyGoal') ?? 2500.0;
    DateTime newDateTime = DateTime(water.dateTime.year,water.dateTime.month,water.dateTime.day);
    _updateDailyGoal(DailyGoal(dateTime: newDateTime, dailyGoalReached: totalWaterAmountPerDay(water.dateTime) >= dailyGoal));

    notifyListeners();
  }

  Water removeWater(int index) {
    Water water = history[index];
    history.removeAt(index);
    _deleteWater(water);
    if (history.isEmpty) {
      _loadHistoryFromDB();
    }
    double dailyGoal = prefs.getDouble('dailyGoal') ?? 2500.0;
    DateTime newDateTime = DateTime(water.dateTime.year,water.dateTime.month,water.dateTime.day);
    _updateDailyGoal(DailyGoal(dateTime: newDateTime, dailyGoalReached: totalWaterAmountPerDay(water.dateTime) >= dailyGoal));
    notifyListeners();
    return water;
  }

  Future<List<Water>> getAllWater() async {
    final List<Water> list = await _waterList();
    notifyListeners();
    return list;
  }

  Future<int> getTotalCupsToday() async {
    return _totalCupsToday();
  }

  Future<double> getAverageCupsPerDay() async {
    final double cups = await _averageCupsPerDay();
    notifyListeners();
    return cups;
  }

  Future<double> getAverageLitersPerDay() async {
    final double liters = await _averageLitersPerDay();
    notifyListeners();
    return liters;
  }

  Future<double> getAverageLitersPerWeek() async {
    final double liters = await _averageLitersPerWeek();
    notifyListeners();
    return liters;
  }

  void removeAllWater() {
    _clearWaterTable();
    _loadHistoryFromDB();
    notifyListeners();
  }

  void removeAllDailyGoal() {
    _clearDaylyGoalTable();
    notifyListeners();
  }

  int totalWaterAmountPerDay(DateTime dateTime) {
    num sum = 0;
    history.forEach((water) {
      if (isSameDay(water.dateTime, dateTime)) {
        sum += water.cupSize;
      }
    });
    return sum;
  }

  int totalWaterAmount() {
    num sum = 0;
    history.forEach((water) {
        sum += water.cupSize;
    });
    return sum;
  }

  int totalCups() {

    num sum = 0;
    history.forEach((water) {
      if(history[0].isPlaceholder == true)
        return 0;
      else
         sum++;
    });
    return sum;
  }

  int quickAddUsed() {
    num sum = 0;
    history.forEach((Water) {
   if(Water.addType == AddType.shake || Water.addType == AddType.power)
        sum++;
    });
    return sum;
  }

  Future<int> getStreakDays() async {
    List<DailyGoal> dailyGoalList = await _dailyGoalList();
    //TODO: Logik für streak days
  }

  Future<int> getGoalsReached() async {

    List<DailyGoal> dailyGoalList = await _dailyGoalList();

    num sum = 0;
    dailyGoalList.forEach((dailygoal)  {
      if(dailygoal.dailyGoalReached == true)
        sum++;
    });
    return sum;

  }

  List<Water> getWaterListForDay(DateTime dateTime) {
    return history.where((water) => isSameDay(water.dateTime, dateTime)).toList().reversed.toList();
  }

  List<double> getWaterListFor7Days(DateTime startDate) {
    List<double> waterListWeek = [];

    for (var i = 0; i < 7; i++) {
      waterListWeek.add(totalWaterAmountPerDay(startDate.add(Duration(days: i))).toDouble());
    }

    return waterListWeek;
  }

  // Private Methods

  Future<void> _insertWater(Water water) async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.

    log('WaterModel: INSERT water - cupSize: ${water.cupSize}, dateTime: ${water.dateTime}');

    await db.insert(
      DatabaseHelper.WATER_TABLE_NAME,
      water.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> _clearWaterTable() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.

    log('WaterModel: CLEAR table ${DatabaseHelper.WATER_TABLE_NAME}');

    await db.delete(
      DatabaseHelper.WATER_TABLE_NAME,
    );
  }


  Future<void> _clearDaylyGoalTable() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.

    log('WaterModel: CLEAR table ${DatabaseHelper.DAILY_GOAL_TABLE_NAME}');

    await db.delete(
      DatabaseHelper.DAILY_GOAL_TABLE_NAME,
    );
  }




  Future<void> _deleteWater(Water water) async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    log('WaterModel: DELETE water - cupSize: ${water.cupSize}, dateTime: ${water.dateTime}');

    // Remove the Dog from the Database.
    await db.delete(
      DatabaseHelper.WATER_TABLE_NAME,
      // Use a `where` clause to delete a specific dog.
      where: 'date_time = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [water.dateTime.millisecondsSinceEpoch],
    );
  }

  Future<double> _averageCupsPerDay() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.WATER_TABLE_NAME);

    if (maps.isEmpty) {
      log('WaterModel (averageCupsPerDay): Table ${DatabaseHelper.WATER_TABLE_NAME} is EMPTY!');
      return 0;
    }

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    final List<Water> waterModelList = _waterModelListFromMap(maps);

    int totalDays = 0;
    int totalCups = 0;

    var groupByDate = groupBy<Water, dynamic>(
        waterModelList, (obj) => obj.dateTime.toString().substring(0, 10));
    groupByDate.forEach((date, list) {
      totalDays++;
      list.forEach((listItem) {
        totalCups++;
      });
    });

    log('WaterModel: Average Cups per Day: ${totalCups / totalDays}');

    return totalCups / totalDays;
  }

  Future<double> _averageLitersPerWeek() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.WATER_TABLE_NAME);

    if (maps.isEmpty) {
      log('WaterModel (averageLitersPerDay): Table ${DatabaseHelper.WATER_TABLE_NAME} is EMPTY!');
      return 0;
    }

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    final List<Water> waterModelList = _waterModelListFromMap(maps);

    int weeklyLitersIndex = 0;
    int totalDays = 0;
    int litersIntermediate = 0;
    List<int> weeklyLiters = [];

    var groupByDate = groupBy<Water, dynamic>(
        waterModelList, (obj) => obj.dateTime.toString().substring(0, 10));

    // iterate over each day
    groupByDate.forEach((date, list) {
      totalDays++;

      // iterate over each water cup
      list.forEach((listItem) {
        litersIntermediate += listItem.cupSize;
      });

      if (weeklyLitersIndex >= weeklyLiters.length) {
        weeklyLiters.add(litersIntermediate);
      } else {
        weeklyLiters[weeklyLitersIndex] =
            weeklyLiters[weeklyLitersIndex] + litersIntermediate;
      }

      litersIntermediate = 0;

      if (totalDays >= 7) {
        weeklyLitersIndex++;
        totalDays = 0;
      }
    });

    double avrgLiterPerWeek =
        weeklyLiters.reduce((a, b) => a + b) / weeklyLiters.length;

    log('WaterModel: Average Liters per Week: $avrgLiterPerWeek');

    return avrgLiterPerWeek;
  }

  Future<double> _averageLitersPerDay() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.WATER_TABLE_NAME);

    if (maps.isEmpty) {
      log('WaterModel (averageLitersPerDay): Table ${DatabaseHelper.WATER_TABLE_NAME} is EMPTY!');
      return 0;
    }

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    final List<Water> waterModelList = _waterModelListFromMap(maps);

    int totalDays = 0;
    int totalLiters = 0;

    var groupByDate = groupBy<Water, dynamic>(
        waterModelList, (obj) => obj.dateTime.toString().substring(0, 10));
    groupByDate.forEach((date, list) {
      totalDays++;
      list.forEach((listItem) {
        totalLiters += listItem.cupSize;
      });
    });

    log('WaterModel: Average Liters per Day: ${totalLiters / totalDays}');

    return totalLiters / totalDays;
  }

  Future<int> _totalCupsToday() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.WATER_TABLE_NAME);

    if (maps.isEmpty) {
      log('WaterModel (totalCups): Table ${DatabaseHelper.WATER_TABLE_NAME} is EMPTY!');
      return 0;
    }

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    final List<Water> waterModelList = _waterModelListFromMap(maps);
    return waterModelList.where((w) => isSameDay(w.dateTime, DateTime.now())).toList().length;
  }

  Future<List<Water>> _waterList() async {
    final Database db = DatabaseHelper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.WATER_TABLE_NAME);

    if (maps.isEmpty) {
      log('WaterModel: Table ${DatabaseHelper.WATER_TABLE_NAME} is EMPTY!');
      return List.generate(1, (index) => Water.placeholder(0));
    }

    return _waterModelListFromMap(maps);
  }

  List<Water> _waterModelListFromMap(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch(maps[i]['date_time']);
      return Water(
        dateTime: dateTime,
        cupSize: maps[i]['cup_size'],
        addType: AddType.values.firstWhere((element) => element.toString() == maps[i]['add_type'])
      );
    });
  }

  void _updateDailyGoal(DailyGoal dailyGoal) async {
    final Database db = DatabaseHelper.database;

    await db.insert(
      DatabaseHelper.DAILY_GOAL_TABLE_NAME,
      dailyGoal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //db.rawQuery('INSERT OR REPLACE INTO ${DatabaseHelper.DAILY_GOAL_TABLE_NAME} (date_time, goal_reached) values((SELECT date_time FROM ${DatabaseHelper.DAILY_GOAL_TABLE_NAME} WHERE date_time = "${dailyGoal.getDateString()}"), "${dailyGoal.getGoalReachedAsInteger()}");');
    log('WaterModel: UPDATE DailyGoal - dateTime: ${dailyGoal.getDateString()}, dailyGoalReached: ${dailyGoal.dailyGoalReached}');
  }

  Future<List<DailyGoal>> _dailyGoalList() async {
    final Database db = DatabaseHelper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
    await db.query(DatabaseHelper.DAILY_GOAL_TABLE_NAME);

    if (maps.isEmpty) {
      log('WaterModel: Table ${DatabaseHelper.DAILY_GOAL_TABLE_NAME} is EMPTY!');
      return List.generate(1, (index) => DailyGoal(dateTime: DateTime.now(), dailyGoalReached: false));

    }

    return List.generate(maps.length, (i) {
      print(maps);
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(maps[i]['date_time']);


      bool goalReached;
      if (maps[i]['goal_reached'] == 0) {
        goalReached = false;
      } else {
        goalReached = true;
      }
      return DailyGoal(dateTime: dateTime, dailyGoalReached: goalReached);
    });
  }
}
