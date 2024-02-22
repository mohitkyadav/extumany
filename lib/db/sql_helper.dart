import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> _createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE exercises(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      link TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    CREATE TABLE workouts(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    CREATE TABLE workout_exercises(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      workout_id INTEGER,
      exercise_id INTEGER,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE,
      FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
    );
    CREATE TABLE workout_exercise_sets(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      workout_id INTEGER,
      exercise_id INTEGER,
      set_number INTEGER,
      reps INTEGER,
      weight REAL,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE,
      FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
    );
    """);
  }

  static Future<void> _onCreate(sql.Database database, int version) async {
    await _createTables(database);
  }

  static Future<void> _onConfigure(sql.Database database) async {
    await database.execute('PRAGMA foreign_keys = ON');
  }

  static Future<sql.Database> db() async {
    Directory directory = await getApplicationDocumentsDirectory();

    return sql.openDatabase(
      '${directory.path}/extumany.db',
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  // Create
  static Future<int> create(String table, Map values) async {
    final db = await SQLHelper.db();

    final id = await db.insert(table, values as Map<String, Object?>,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Read
  static Future<List<Map<String, Object?>>> queryAll(String table,
      {String orderBy = 'id', String? where, List<Object?>? whereArgs}) async {
    final db = await SQLHelper.db();

    return db.query(table,
        orderBy: orderBy, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, Object?>>> get(String table, int id) async {
    final db = await SQLHelper.db();

    return db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // Update
  static Future<int> update(String table, int id, Map values) async {
    final db = await SQLHelper.db();

    final result = await db.update(table, values as Map<String, Object?>,
        where: 'id = ?', whereArgs: [id]);

    return result;
  }

  // Delete
  static Future<void> delete(String table, int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Error deleting item id: $id from $table, error: 'err'");
    }
  }

  static Future<void> deleteDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    await sql.deleteDatabase('${directory.path}/extumany.db');
  }

  static Future<void> seedDb() async {
    final db = await SQLHelper.db();

    await db.transaction((txn) async {
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Bench press', 'Lay on a bench and press the bar', 'https://www.youtube.com/watch?v=0quc7LX7Jk8');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Squat', 'Stand with a barbell on your shoulders and squat', 'https://www.youtube.com/watch?v=ultWZbUMPL8');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Deadlift', 'Lift a barbell from the ground', 'https://www.youtube.com/watch?v=op9kVnSso6Q');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Pull-up', 'Pull yourself up on a bar', 'https://www.youtube.com/watch?v=eGo4IYlbE5g');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Dumbbell curl', 'Curl a dumbbell', 'https://www.youtube.com/watch?v=1TJvJd5e8uI');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Tricep pushdown', 'Push down a cable', 'https://www.youtube.com/watch?v=6kALZikXxLc');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Leg press', 'Press a weight with your legs', 'https://www.youtube.com/watch?v=2e9bZQbJfzE');
      ''');
      await txn.rawInsert('''
      INSERT INTO exercises(title, description, link)
      VALUES('Calf raise', 'Raise your heels', 'https://www.youtube.com/watch?v=2e9bZQbJfzE');
      ''');
      await txn.rawInsert('''
      INSERT INTO workouts(title, description)
      VALUES('allstar: bk x bc', 'On wednesdays, 2nd day from climbing with proper rest for back muscles');
      ''');
      await txn.rawInsert('''
      INSERT INTO workouts(title, description)
      VALUES('cfs: sh x tc x lg', 'On thursdays after theory lessons, do for strength gain');
      ''');
      await txn.rawInsert('''
      INSERT INTO workouts(title, description)
      VALUES('cfs: sh x tc x lg x a very long long long long long long long long long name', 'On thursdays after theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons, do for strength gain');
      ''');
      await txn.rawInsert('''
      INSERT INTO workouts(title, description)
      VALUES('cfl: bk x bc x a very long long long long long long long long long name', 'On thursdays after theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons, do for strength gain');
      ''');
      await txn.rawInsert('''
      INSERT INTO workouts(title, description)
      VALUES('sfa: sh x lg x a very long long long long long long long long long name', 'On thursdays after theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons theory lessons, do for strength gain');
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(1, 1);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(1, 2);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(1, 3);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(2, 4);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(2, 5);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(2, 6);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(2, 7);
      ''');
      await txn.rawInsert('''
      INSERT INTO workout_exercises(workout_id, exercise_id)
      VALUES(2, 8);
      ''');
    });
  }
}
