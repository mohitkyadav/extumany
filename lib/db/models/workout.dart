import 'package:extumany/db/sql_helper.dart';
import 'package:extumany/utils/utils.dart';

class Workout {
  static const tableName = 'workouts';

  Workout({
    required this.title,
    this.id,
    this.createdAt,
    this.description,
  });

  int? id;
  DateTime? createdAt;
  String title;
  String? description;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'title': title,
      'description': description,
    };
  }

  Future<int?> persistInDb() async {
    final values = {
      'title': title.capitalize(),
      'description': description,
    };

    if (id != null) {
      await SQLHelper.update(tableName, id!, values);
    } else {
      id = await SQLHelper.create(tableName, values);
    }

    return id;
  }

  static Workout fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'],
      description: map['description'],
    );
  }

  static Future<void> delete(int id) async {
    await SQLHelper.delete(tableName, id);
  }

  static Future<Workout> getOne(int id) async {
    final List<Map<String, Object?>> result = await SQLHelper
        .get(tableName, id);

    return fromMap(result[0]);
  }

  static Future<List<Workout>> getAll() async {
    final List<Map<String, Object?>> result = await SQLHelper
        .queryAll(tableName);
    return List.generate(result.length, (i) {
      return Workout.fromMap(result[i]);
    });
  }
}
