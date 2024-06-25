part of './task_model.dart';

class TimespanModel {
  final DateTime startTime;
  final DateTime? endTime;

  TimespanModel({
    required this.startTime,
    required this.endTime,
  });

  factory TimespanModel.fromJson(Map<String, dynamic> json) => TimespanModel(
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.tryParse(json["endTime"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
      };
}
