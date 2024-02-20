import 'package:extumany/db/sql_helper.dart';
import 'package:extumany/utils/utils.dart';

class Exercise {
  static const tableName = 'exercises';

  Exercise({
    this.id,
    this.createdAt,
    this.title,
    this.description,
    this.link,
  });

  int? id;
  DateTime? createdAt;
  String? title;
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

  Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'],
      description: map['description'],
      link: map['link'],
    );
  }

  Future<int?> persistInDb() async {
    final values = {
      'title': title?.capitalize(),
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

  Future<List<Exercise>> getAll() async {
    final List<Map<String, Object?>> result = await SQLHelper
        .queryAll(tableName);
    return List.generate(result.length, (i) {
      return fromMap(result[i]);
    });
  }

  Future<Exercise> get(int id) async {
    final List<Map<String, Object?>> result = await SQLHelper
        .get(tableName, id);

    return fromMap(result[0]);
  }
}
