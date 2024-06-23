part of './task_model.dart';

class CommentModel {
  final String id;
  final String taskId;
  final String comment;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.taskId,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        taskId: json["taskId"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskId": taskId,
        "comment": comment,
        "createdAt": createdAt.toIso8601String(),
      };
}
