import 'package:extumany/db/sql_helper.dart';
import 'package:extumany/utils/utils.dart';

class Exercise {
  static const tableName = 'exercises';

  Exercise({
    required this.title,
    this.id,
    this.createdAt,
    this.description,
    this.link,
  });

  int? id;
  DateTime? createdAt;
  String title;
  String? description;
  String? link;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'title': title,
      'description': description,
      'link': link,
    };
  }

  Future<int?> persistInDb() async {
    final values = {
      'title': title.capitalize(),
      'description': description,
      'link': link?.toLowerCase(),
    };

    if (id != null) {
      await SQLHelper.update(tableName, id!, values);
    } else {
      id = await SQLHelper.create(tableName, values);
    }

    return id;
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'],
      description: map['description'],
      link: map['link'],
    );
  }

  static Future<void> delete(int id) async {
    await SQLHelper.delete(tableName, id);
  }

  static Future<Exercise> getOne(int id) async {
    final List<Map<String, Object?>> result =
        await SQLHelper.get(tableName, id);

    return fromMap(result[0]);
  }

  static Future<List<Exercise>> getAll() async {
    final List<Map<String, Object?>> result =
        await SQLHelper.queryAll(tableName);
    return List.generate(result.length, (i) {
      return Exercise.fromMap(result[i]);
    });
  }

  static Future<List<Exercise>> getAllByIds(List<int> ids) async {
    final data =
        await SQLHelper.queryAll(tableName, where: 'id IN (${ids.join(',')})');
    return data.map((e) => fromMap(e)).toList();
  }

  static Future<List<Exercise>> getAllExcept(List<int> ids) async {
    final data = await SQLHelper.queryAll(tableName,
        where: 'id NOT IN (${ids.join(',')})');
    return data.map((e) => fromMap(e)).toList();
  }
}
