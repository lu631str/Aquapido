import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:water_tracker/models/WaterModel.dart';
import 'dart:developer';

final Future<Database> database = connectWithDatabase();

final String waterTableName = "water";

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
        "CREATE TABLE $waterTableName(date_time INTEGER PRIMARY KEY, cup_size INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> insertWater(WaterModel water) async {
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

Future<void> deleteWater(WaterModel water) async {
  // Get a reference to the database.
  final db = await database;

  log('Database: DELETE water - cupSize: ${water.cupSize}, dateTime: ${water.dateTime}');

  // Remove the Dog from the Database.
  await db.delete(
    waterTableName,
    // Use a `where` clause to delete a specific dog.
    where: "dateTime = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [water.dateTime.millisecondsSinceEpoch],
  );
}

Future<List<WaterModel>> water() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query(waterTableName);

  if (maps.isEmpty) {
    log('Database: Table $waterTableName is EMPTY!');
    return [];
  }

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(maps[i]['date_time']);
    return WaterModel(
      dateTime: dateTime,
      cupSize: maps[i]['cup_size'],
    );
  });
}
