import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/utils/task_utils.dart';

import '../cubits/board_task/cubit.dart';
import '../models/task_model.dart';

Future<TaskModel> addTimeSpan(BuildContext context, TaskModel taskModel) async {
  return updateTask(
    taskModel,
    timeSpanList: [
      TimespanModel(startTime: DateTime.now(), endTime: null),
    ],
  ).then(
    (value) {
      log(jsonEncode(value.toJson()));

      context.read<BoardTaskCubit>().updateTask(value);

      return value;
    },
  );
}

Future<TaskModel> endTimeSpan(BuildContext context, TaskModel taskModel) {
  List<TimespanModel> existingList = List.from(taskModel.timespanList);

  int index = existingList.indexWhere((element) => element.endTime == null);

  if (index != -1) {
    TimespanModel pendingTimeSpan = existingList[index];
    existingList.removeAt(index);
    existingList.add(TimespanModel(
        startTime: pendingTimeSpan.startTime, endTime: DateTime.now()));
    TaskModel updatedTimeSpanModel = taskModel.updateTimeSpanList(existingList);
    log(jsonEncode(updatedTimeSpanModel.toJson()));
    return handleUpdatingOfTaskInLocalStorage(updatedTimeSpanModel).then(
      (value) {
        context.read<BoardTaskCubit>().updateTask(value);
        return value;
      },
    );
  } else {
    return Future.delayed(Duration.zero, () => taskModel);
  }
}
