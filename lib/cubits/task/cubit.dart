import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task_model.dart';

class TaskCubit extends Cubit<TaskModel> {
  TaskCubit(super.initialState);

  void updateTask({
    String? title,
    String? description,
    List<CommentModel>? commentList,
    List<TimespanModel>? timespanList,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    emit(state.update(
      newTitle: title,
      newDescription: description,
      newCommentList: commentList,
      newTimeSpanList: timespanList,
      newUpdatedAt: updatedAt,
      newCompletedAt: completedAt,
    ));
  }
}
