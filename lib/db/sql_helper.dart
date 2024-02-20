import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> _createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE exercises(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      link TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
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
  static Future<List<Map<String, Object?>>> queryAll(
      String table, {String orderBy = 'id'}) async {
    final db = await SQLHelper.db();

    return db.query(table, orderBy: orderBy);
  }

  static Future<List<Map<String, Object?>>> get(String table, int id) async {
    final db = await SQLHelper.db();

    return db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // Update
  static Future<int> update( String table, int id, Map values) async {
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
}
