import 'package:hive_flutter/adapters.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;

  @HiveField(2)
  bool isUrgent;

  @HiveField(3)
  String? status;

  @HiveField(4)
  String? dueDate;

  Task({
    this.title,
    this.description,
    this.isUrgent =false,
    this.status,
    this.dueDate,
  });
}
