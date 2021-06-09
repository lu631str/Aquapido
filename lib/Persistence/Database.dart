import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import '../Utils/utils.dart';
import '../Models/Water.dart';
import "package:collection/collection.dart";
import 'dart:developer';

final Future<Database> database = connectWithDatabase();

const String waterTableName = 'water';

Future<Database> connectWithDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'water_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE $waterTableName(date_time INTEGER PRIMARY KEY, cup_size INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> insertWater(Water water) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.

  log('Database: INSERT water - cupSize: ${water.cupSize}, dateTime: ${water.dateTime}');

  await db.insert(
    waterTableName,
    water.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> clearWaterTable() async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.

  log('Database: CLEAR table $waterTableName');

  await db.delete(
    waterTableName,
  );
}

Future<void> deleteWater(Water water) async {
  // Get a reference to the database.
  final db = await database;

  log('Database: DELETE water - cupSize: ${water.cupSize}, dateTime: ${water.dateTime}');

  // Remove the Dog from the Database.
  await db.delete(
    waterTableName,
    // Use a `where` clause to delete a specific dog.
    where: 'date_time = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [water.dateTime.millisecondsSinceEpoch],
  );
}

Future<double> getAverageCupsPerDay() async {
   // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(waterTableName);

  if (maps.isEmpty) {
    log('Database (averageCupsPerDay): Table $waterTableName is EMPTY!');
    return 0;
  }

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  final List<Water> waterModelList = _getWaterModelListFromMap(maps);

  int totalDays = 0;
  int totalCups = 0;

  var groupByDate = groupBy<Water, dynamic>(waterModelList, (obj) => obj.dateTime.toString().substring(0, 10));
  groupByDate.forEach((date, list) {
    totalDays++;
    list.forEach((listItem) {
      totalCups++;
    });
  });

  log('Database: Average Cups per Day: ${totalCups / totalDays}');

  return totalCups / totalDays;
}

Future<double> getAverageLitersPerDay() async {
   // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(waterTableName);

  if (maps.isEmpty) {
    log('Database (averageLitersPerDay): Table $waterTableName is EMPTY!');
    return 0;
  }

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  final List<Water> waterModelList = _getWaterModelListFromMap(maps);

  int totalDays = 0;
  int totalLiters = 0;

  var groupByDate = groupBy<Water, dynamic>(waterModelList, (obj) => obj.dateTime.toString().substring(0, 10));
  groupByDate.forEach((date, list) {
    totalDays++;
    list.forEach((listItem) {
      totalLiters += listItem.cupSize;
    });
  });

  log('Database: Average Liters per Day: ${totalLiters / totalDays}');

  return totalLiters / totalDays;
}

Future<int> totalCupsToday() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(waterTableName);

  if (maps.isEmpty) {
    log('Database (totalCups): Table $waterTableName is EMPTY!');
    return 0;
  }

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  final List<Water> waterModelList = _getWaterModelListFromMap(maps);
  return waterModelList.where((w) => isToday(w.dateTime)).toList().length;
}

Future<List<Water>> waterList() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(waterTableName);

  if (maps.isEmpty) {
    log('Database: Table $waterTableName is EMPTY!');
    return List.generate(1, (index) => Water.placeholder(0));
  }

  return _getWaterModelListFromMap(maps);
}

List<Water> _getWaterModelListFromMap(List<Map<String, dynamic>> maps) {
  return List.generate(maps.length, (i) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(maps[i]['date_time']);
    return Water(
      dateTime: dateTime,
      cupSize: maps[i]['cup_size'],
    );
  });
}
