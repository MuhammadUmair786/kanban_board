import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/extras.dart';
import '../cubits/board_task/cubit.dart';
import '../utils/board_utils.dart';
import '../utils/custom_utils.dart';
import '../utils/notification_utils.dart';
import '../utils/task_utils.dart';

const String driveBackUpParentFolderName = "kanbanDataFolder";
const String driveBackUpFileName = "kanban_backup";
const String driveBackUpFileExtension = "json";

const String updatedAtKey = "updatedAt";
const String boardKey = "board";
const String tasksKey = "tasks";

Map<String, dynamic> getLocalDataConvertedIntoBackUpStandard() {
  return <String, dynamic>{
    updatedAtKey: DateTime.now().toUtc().toIso8601String(),
    boardKey: getBoards().map((e) => e.toJson()).toList(),
    tasksKey: getTasks().map((e) => e.toJson()).toList(),
  };
}

Future<void> initilizeDataFromBackupJSON(Map<String, dynamic> json) async {
  List<Future<dynamic>> futureList = <Future<dynamic>>[];
  if (json[updatedAtKey] != null) {
    DateTime? dateTime = DateTime.tryParse(json[updatedAtKey]);
    if (dateTime != null) {
      futureList.add(setLastUpdatebackUp(dateTime));
    }
  }
  if (json[boardKey] != null) {
    futureList.add(addBoardInBulk(json[boardKey]));
  }
  if (json[tasksKey] != null) {
    futureList.add(addTasksInBulk(json[tasksKey]));
  }

  await Future.wait(futureList).then((value) async {
    generalContext.read<BoardTaskCubit>().loadBoardsAndTasks();
  });

  List<Future> notificatioFutureList = getTasks()
      .where((element) => element.isScheduled)
      .map(
        (e) => NotificationService.scheduleTaskNotification(
          id: int.parse(e.id),
          title: e.title,
          description: e.description,
          selectedDateTime: e.scheduleAt!,
        ),
      )
      .toList();

  await Future.wait(notificatioFutureList);
}
