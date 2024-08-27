import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task_model.dart';
import '../../utils/comment_utils.dart';
import '../../utils/task_utils.dart';
part 'state.dart';

class TaskCubit extends Cubit<TaskState> {
  late TaskModel taskModel;

  TaskCubit(this.taskModel) : super(TaskLoadSuccess(taskModel));

  void updateTask(TaskModel updatedTaskModel) {
    updatedTaskModel = updatedTaskModel;
    emit(TaskUpdate(updatedTaskModel));
  }

  Future<void> addComment(String commentString) async {
    await addCommentToTask(taskModel, commentString).then(
      (value) {
        updateTask(value);
      },
    );
  }

  Future<bool> deleteTask() async {
    return removeTask(taskModel).then(
      (value) {
        return value;
      },
    );
  }

  void deleteComment(String commentId) async {
    await deleteCommentFromTask(taskModel, commentId).then(
      (value) {
        updateTask(value);
      },
    );
  }

  Future<void> dismissReminder() async {
    await removeReminderFromTask(taskModel).then(
      (value) {
        if (value != null) {
          updateTask(value);
        }
      },
    );
  }
}
