import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../src/DailyGoal.dart';
import '../../src/Water.dart';
import '../Persistence/Database.dart';

class DailyGoalModel with ChangeNotifier {
  // Public Methods

  void addDailyGoal(DailyGoal dailyGoal) {
    updateDailyGoal(dailyGoal);
    notifyListeners();
  }

  void removeDailyGoal(Water water, dailyGoalReached) {
    DateTime newDateTime =
        DateTime(water.dateTime.year, water.dateTime.month, water.dateTime.day);
    updateDailyGoal(
        DailyGoal(dateTime: newDateTime, dailyGoalReached: dailyGoalReached));

    notifyListeners();
  }

  void removeAllDailyGoal() {
    _clearDaylyGoalTable();
    notifyListeners();
  }

  Future<List<DateTime>> getGoalsReachedDaysList() async {
    List<DailyGoal> dailyGoalList = await _dailyGoalList();
    List<DateTime> dateTimeList = [];
    if (dailyGoalList.isEmpty) {
      return dateTimeList;
    } else {
      dailyGoalList.forEach((dailygoal) {
        if (dailygoal.dailyGoalReached) {
          dateTimeList.add(dailygoal.dateTime);
        }
      });
    }

    return dateTimeList;
  }

  Future<int> getStreakDays() async {
    List<DailyGoal> dailyGoalList = await _dailyGoalList();

    int count = 1;
    int max = 0;

    for (int i = 1; i < dailyGoalList.length; i++) {
      if (dailyGoalList.isEmpty)
        max = 0;
      else if (dailyGoalList[i]
                  .dateTime
                  .difference(dailyGoalList[i - 1].dateTime)
                  .inDays ==
              1 &&
          (dailyGoalList[i].dailyGoalReached == true &&
              dailyGoalList[i - 1].dailyGoalReached == true)) {
        count++;
      } else {
        count = 1;
      }
      if (count > max) {
        max = count;
      }
    }
    return max;
  }

  Future<int> getGoalsReached() async {
    List<DailyGoal> dailyGoalList = await _dailyGoalList();

    num sum = 0;
    dailyGoalList.forEach((dailygoal) {
      if (dailygoal.dailyGoalReached == true) sum++;
    });
    return sum;
  }

  // Private Methods

  Future<void> _clearDaylyGoalTable() async {
    // Get a reference to the database.
    final Database db = DatabaseHelper.database;

    log('WaterModel: CLEAR table ${DatabaseHelper.DAILY_GOAL_TABLE_NAME}');

    await db.delete(
      DatabaseHelper.DAILY_GOAL_TABLE_NAME,
    );
  }

  void updateDailyGoal(DailyGoal dailyGoal) async {
    final Database db = DatabaseHelper.database;

    await db.insert(
      DatabaseHelper.DAILY_GOAL_TABLE_NAME,
      dailyGoal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log('WaterModel: UPDATE DailyGoal - dateTime: ${dailyGoal.getDateString()}, dailyGoalReached: ${dailyGoal.dailyGoalReached}');
  }

  Future<List<DailyGoal>> _dailyGoalList() async {
    final Database db = DatabaseHelper.database;

    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.DAILY_GOAL_TABLE_NAME);
    if (maps.isEmpty) {
      log('WaterModel: Table ${DatabaseHelper.DAILY_GOAL_TABLE_NAME} is EMPTY!');
      return List.generate(
          1,
          (index) =>
              DailyGoal(dateTime: DateTime.now(), dailyGoalReached: false));
    }

    return List.generate(maps.length, (i) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(maps[i]['date_time']);

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
