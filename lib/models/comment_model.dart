part of './task_model.dart';

class CommentModel {
  final String id;
  final String comment;

  CommentModel({
    required this.id,
    required this.comment,
  });

  DateTime get createdAt => DateTime.fromMicrosecondsSinceEpoch(int.parse(id));

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
      };
}
