import 'package:appflowy_board/appflowy_board.dart';

part './comment_model.dart';
part './timespan_model.dart';

class TaskModel extends AppFlowyGroupItem {
  @override
  final String id;
  final String boardId;
  final int order;
  final String title;
  final String description;
  final List<CommentModel> commentList;
  final List<TimespanModel> timespanList;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// reminder
  final DateTime? scheduleAt;

  bool get isScheduled =>
      scheduleAt != null && scheduleAt!.isAfter(DateTime.now().toUtc());

  @override
  String toString() => id;

  Duration get getExistingDuration {
    Duration totalDuration = Duration.zero;

    for (var timespan in timespanList) {
      if (timespan.endTime != null) {
        totalDuration += timespan.endTime!.difference(timespan.startTime);
      }
    }

    return totalDuration;
  }

  bool get isAnyPendingTimespan {
    return timespanList.any((element) => element.endTime == null);
  }

  List<CommentModel> get getCommentSortedList {
    commentList.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return commentList;
  }

  TaskModel({
    required this.id,
    required this.boardId,
    required this.order,
    required this.title,
    required this.description,
    required this.commentList,
    required this.timespanList,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        boardId: json["boardId"],
        order: json["order"],
        title: json["title"],
        description: json["description"],
        commentList: List<CommentModel>.from(
          json["commentList"].map(
            (x) => CommentModel.fromJson(x),
          ),
        ),
        timespanList: List<TimespanModel>.from(
          json["timespanList"].map(
            (x) => TimespanModel.fromJson(x),
          ),
        ),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? ''),
        scheduleAt: DateTime.tryParse(json["scheduleAt"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "boardId": boardId,
        "order": order,
        "title": title,
        "description": description,
        "commentList": commentList.map((e) => e.toJson()).toList(),
        "timespanList": timespanList.map((e) => e.toJson()).toList(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "scheduleAt": scheduleAt?.toIso8601String(),
      };

  factory TaskModel.fromDummyMeasum() {
    return TaskModel(
      id: '-1',
      boardId: '-1',
      order: -1,
      title: "unknown",
      description: "N/A",
      commentList: [],
      timespanList: [],
      createdAt: DateTime(1000),
      updatedAt: null,
      scheduleAt: null,
    );
  }

  TaskModel update({
    String? newBoardId,
    int? newOrder,
    String? newTitle,
    String? newDescription,
    List<CommentModel>? newCommentList,
    List<TimespanModel>? newTimeSpanList,
    DateTime? newUpdatedAt,
    DateTime? newScheduleAt,
  }) {
    return TaskModel(
      id: id,
      boardId: newBoardId ?? boardId,
      order: newOrder ?? order,
      title: newTitle ?? title,
      description: newDescription ?? description,
      commentList: newCommentList ?? commentList,
      timespanList: newTimeSpanList ?? timespanList,
      createdAt: createdAt,
      updatedAt: newUpdatedAt ?? updatedAt,
      scheduleAt: newScheduleAt ?? scheduleAt,
    );
  }

  TaskModel updateReminderTime({
    required DateTime? newScheduleAt,
  }) {
    return TaskModel(
      id: id,
      boardId: boardId,
      order: order,
      title: title,
      description: description,
      commentList: commentList,
      timespanList: timespanList,
      createdAt: createdAt,
      updatedAt: updatedAt,
      scheduleAt: newScheduleAt,
    );
  }
}
