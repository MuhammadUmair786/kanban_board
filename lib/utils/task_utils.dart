import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import '../models/task_model.dart';
import '../helpers/time_based_id.dart';

String taskContainerKey = 'TaskContainer';

Future<TaskModel> addTask(
    String boardId, String title, String description) async {
  List<TaskModel> existingTaskList = getTasks(boardId: boardId)
      .where((element) => element.isCompleted)
      .toList();
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
    completedAt: null,
  );
  // log(jsonEncode(tempTask.toJson()));
  await GetStorage(taskContainerKey).write(id, tempTask.toJson());

  return tempTask;
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

Future<void> removeTask(TaskModel task) async {
  await GetStorage(taskContainerKey).remove(task.id);
}

Future<TaskModel> updateTask(
  TaskModel task, {
  String? title,
  String? description,
  int? order,
  List<TimespanModel>? timeSpanList,
  List<CommentModel>? commentList,
}) async {
  TaskModel tempTask = task.update(
    newTitle: title,
    newDescription: description,
    newOrder: order,
    newTimeSpanList: timeSpanList,
    newCommentList: commentList,
    newUpdatedAt: DateTime.now(),
  );
  return handleUpdatingOfTaskInLocalStorage(tempTask);
}

Future<TaskModel> handleUpdatingOfTaskInLocalStorage(TaskModel task) async {
  await GetStorage(taskContainerKey).write(task.id, task.toJson());
  return task;
}

/// [taskList] -> List of task in that group
Future<void> updateTaskOrder(
    List<TaskModel> taskList, int oldIndex, int newIndex) async {
  final lowerIndex = oldIndex < newIndex ? oldIndex : newIndex;
  final upperIndex = oldIndex < newIndex ? newIndex : oldIndex;

  List<Future> futureList = [];

  // Update the order of affected tasks
  for (int i = lowerIndex; i <= upperIndex; i++) {
    TaskModel tempcategory = taskList[i];
    futureList.add(
      updateTask(
        tempcategory,
        order: i,
      ),
    );
  }
  Future.wait(futureList);
}
