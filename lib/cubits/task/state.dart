part of 'cubit.dart';

abstract class TaskState {}

class TaskLoadSuccess extends TaskState {
  final TaskModel taskModel;

  TaskLoadSuccess(this.taskModel);
}

class TaskUpdate extends TaskState {
  final TaskModel taskModel;

  TaskUpdate(this.taskModel);
}

class TaskFailure extends TaskState {
  final String message;

  TaskFailure(this.message);
}
