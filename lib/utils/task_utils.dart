import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kanban_board/constants/extras.dart';
import 'package:kanban_board/cubits/history/cubit.dart';
import 'package:kanban_board/utils/notification_utils.dart';
import 'package:localization/localization.dart';

import '../cubits/board_task/cubit.dart';
import '../localization/local_keys.dart';
import '../models/task_model.dart';
import '../helpers/time_based_id.dart';
import '../widgets/confirmation_dialog.dart';
import 'analytics.dart';

String taskContainerKey = 'TaskContainer';

Future<TaskModel> addTask(String boardId, String title, String description,
    DateTime? reminderDate) async {
  List<TaskModel> existingTaskList = getTasks(boardId: boardId).toList();
  int maxOrder = existingTaskList.isEmpty
      ? -1
      : existingTaskList
          .map((task) => task.order)
          .reduce((a, b) => a > b ? a : b);
  String id = getTimeBasedId();
  TaskModel tempTask = TaskModel(
    id: id,
    boardId: boardId,
    order: maxOrder,
    title: title,
    description: description,
    commentList: [],
    timespanList: [],
    createdAt: DateTime.now(),
    updatedAt: null,
    scheduleAt: reminderDate,
  );
  // log(jsonEncode(tempTask.toJson()));
  await GetStorage(taskContainerKey).write(id, tempTask.toJson());

  if (reminderDate != null) {
    NotificationService.scheduleTaskNotification(
      id: int.parse(id),
      title: title,
      description: description,
      selectedDateTime: reminderDate,
    );
    logAnalyticEvent(AnalyticEvent.reminder);
  }

  return tempTask;
}

Future<void> addTasksInBulk(List<dynamic> jsonList) async {
  List<Future<dynamic>> futureList = jsonList
      .map(
        (json) => GetStorage(taskContainerKey).write(json['id'], json),
      )
      .toList();
  await Future.wait(futureList);
}

TaskModel getTaskById(String id) {
  try {
    return TaskModel.fromJson(GetStorage(taskContainerKey).read(id));
  } catch (_) {
    // log(e.toString());
    // log(x.toString());
    return TaskModel.fromDummyMeasum();
  }
}

List<TaskModel> getTasks({String? boardId}) {
  try {
    Iterable<dynamic> tempList = GetStorage(taskContainerKey).getValues();
    log('getTask($boardId)-> length ${tempList.length}');

    List<TaskModel> tempTaskList =
        tempList.map((e) => TaskModel.fromJson(e)).toList();

    return boardId == null
        ? tempTaskList
        : tempTaskList.where((element) => element.boardId == boardId).toList();
  } catch (e, x) {
    log(e.toString());
    log(x.toString());
    return [];
  }
}

Future<bool> removeTask(TaskModel task) async {
  return showConfirmationDialog(
    title: task.title,
    description: confirmDeleteLK.i18n(),
    onYes: () async {
      return GetStorage(taskContainerKey).remove(task.id).then(
        (_) {
          generalContext.read<BoardTaskCubit>().deleteTask(task);
          generalContext.read<HistoryCubit>().loadTasks();
          Navigator.of(generalContext).pop(true); //close dialog
          if (task.isScheduled) {
            NotificationService.deleteReminder(int.parse(task.id));
          }
        },
      );
    },
  ).then(
    (value) {
      return value ?? false;
    },
  );
}

Future<TaskModel?> removeReminderFromTask(TaskModel task) {
  return showConfirmationDialog(
    title: dismissAlarmLK.i18n(),
    description: confirmCancelReminderLK.i18n(),
    onYes: () async {
      return handleUpdatingOfTaskInLocalStorage(
              task.updateReminderTime(newScheduleAt: null))
          .then(
        (newValue) {
          NotificationService.deleteReminder(int.parse(newValue.id));
          generalContext.read<BoardTaskCubit>().updateTask(newValue);
          Navigator.of(generalContext).pop(newValue);
        },
      );
    },
  ).then(
    (value) {
      return value;
    },
  );
}

Future<TaskModel> updateTask(
  TaskModel task, {
  String? boardId,
  String? title,
  String? description,
  int? order,
  List<TimespanModel>? timeSpanList,
  List<CommentModel>? commentList,
  DateTime? reminderDate,
}) async {
  TaskModel tempTask = task.update(
    newBoardId: boardId,
    newTitle: title,
    newDescription: description,
    newOrder: order,
    newTimeSpanList: timeSpanList,
    newCommentList: commentList,
    newUpdatedAt: DateTime.now(),
    newScheduleAt: reminderDate,
  );
  return handleUpdatingOfTaskInLocalStorage(tempTask);
}

Future<TaskModel> handleUpdatingOfTaskInLocalStorage(TaskModel task) async {
  await GetStorage(taskContainerKey).write(task.id, task.toJson());
  return task;
}

/// [taskList] -> List of task in that group
Future<void> updateTaskOrderWithinBoard(
    List<TaskModel> taskList, int oldIndex, int newIndex) async {
  final lowerIndex = oldIndex < newIndex ? oldIndex : newIndex;
  final upperIndex = oldIndex < newIndex ? newIndex : oldIndex;

  List<Future> futureList = [];

  // Update the order of affected tasks
  for (int i = lowerIndex; i <= upperIndex; i++) {
    TaskModel tempTask = taskList[i];
    futureList.add(
      updateTask(
        tempTask,
        order: i,
      ),
    );
  }
  Future.wait(futureList);
}

Future<void> updateTaskOrderToOtherBoard({
  required String newBoardId,
  required List<TaskModel> newBoardTaskList,
  required TaskModel draggedTask,
  required int newIndex,
}) async {
  final lowerIndex = newIndex + 1;
  final upperIndex = (newBoardTaskList.length - 1);

  List<Future> futureList = [];

  futureList.add(
    updateTask(
      draggedTask,
      boardId: newBoardId,
      order: newIndex,
    ),
  );

  if (lowerIndex < upperIndex) {
    // Update the order of affected tasks
    for (int i = lowerIndex; i <= upperIndex; i++) {
      TaskModel tempTask = newBoardTaskList[i];
      futureList.add(
        updateTask(
          tempTask,
          order: i,
        ),
      );
    }
  }
  Future.wait(futureList);
}
