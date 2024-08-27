import 'package:kanban_board/utils/task_utils.dart';

import '../models/task_model.dart';

Future<TaskModel> addTimeSpan(TaskModel taskModel) async {
  List<TimespanModel> latestTimeSpanList = List.from(taskModel.timespanList);
  latestTimeSpanList
      .add(TimespanModel(startTime: DateTime.now(), endTime: null));
  return updateTask(
    taskModel,
    timeSpanList: latestTimeSpanList,
  ).then(
    (value) {
      return value;
    },
  );
}

Future<TaskModel> endTimeSpan(TaskModel taskModel) {
  List<TimespanModel> latestTimeSpanList = List.from(taskModel.timespanList);

  int index =
      latestTimeSpanList.indexWhere((element) => element.endTime == null);

  if (index != -1) {
    TimespanModel pendingTimeSpan = latestTimeSpanList[index];
    latestTimeSpanList.removeAt(index);
    latestTimeSpanList.add(
      TimespanModel(
        startTime: pendingTimeSpan.startTime,
        endTime: DateTime.now(),
      ),
    );

    return updateTask(taskModel, timeSpanList: latestTimeSpanList).then(
      (value) {
        return value;
      },
    );
  } else {
    return Future.delayed(Duration.zero, () => taskModel);
  }
}
