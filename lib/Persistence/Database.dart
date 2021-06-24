import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database database;

  static const String WATER_TABLE_NAME = 'water';
  static const String DAILY_GOAL_TABLE_NAME = 'dailyGoal';

  Future<Database> initDatabaseConnection() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'aquapido_water.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE $WATER_TABLE_NAME(date_time INTEGER PRIMARY KEY, cup_size INTEGER, add_type TEXT)',
        );

        return db.execute(
          'CREATE TABLE $DAILY_GOAL_TABLE_NAME(date_time INTEGER PRIMARY KEY, daily_goal INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
