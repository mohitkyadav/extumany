import 'package:extumany/db/sql_helper.dart';

class WorkoutExercise {
  static const tableName = 'workout_exercises';

  WorkoutExercise({
    required this.workoutId,
    required this.exerciseId,
    this.id,
    this.createdAt,
  });

  int? id;
  DateTime? createdAt;
  int workoutId;
  int exerciseId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'workout_id': workoutId,
      'exercise_id': exerciseId,
    };
  }

  Future<int?> persistInDb() async {
    final values = {
      'workout_id': workoutId,
      'exercise_id': exerciseId,
    };

    if (id != null) {
      await SQLHelper.update(tableName, id!, values);
    } else {
      id = await SQLHelper.create(tableName, values);
    }

    return id;
  }

  static Future<List<WorkoutExercise>> getAllForWorkout(int workoutId) async {
    final data = await SQLHelper.queryAll(tableName,
        where: 'workout_id = ?', whereArgs: [workoutId]);

    return data.map((e) => fromMap(e)).toList();
  }

  static Future<List<WorkoutExercise>> getAll() async {
    final data = await SQLHelper.queryAll(tableName);
    return data.map((e) => fromMap(e)).toList();
  }

  static WorkoutExercise fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      workoutId: map['workout_id'],
      exerciseId: map['exercise_id'],
    );
  }

  static Future<void> delete(int id) async {
    await SQLHelper.delete(tableName, id);
  }
}
