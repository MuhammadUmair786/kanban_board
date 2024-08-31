import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/extras.dart';
import '../cubits/board_task/cubit.dart';
import '../helpers/time_based_id.dart';
import '../models/task_model.dart';
import 'task_utils.dart';

Future<TaskModel> addCommentToTask(TaskModel taskModel, String comment) async {
  List<CommentModel> latestCommentList = List.from(taskModel.commentList);
  latestCommentList.add(
    CommentModel(
      id: getTimeBasedId(),
      comment: comment,
      createdAt: DateTime.now(),
    ),
  );
  return updateTask(
    taskModel,
    commentList: latestCommentList,
  ).then(
    (value) {
      log(jsonEncode(value.toJson()));
      generalContext.read<BoardTaskCubit>().updateTask(value);

      return value;
    },
  );
}

// Future<TaskModel> editComment(BuildContext context, TaskModel taskModel,
//     String commentId, String updatedComment) {
//   List<CommentModel> latestCommentList = List.from(taskModel.commentList);

//   int index =
//       latestCommentList.indexWhere((element) => element.id == commentId);

//   if (index != -1) {
//     latestCommentList.removeAt(index);
//     latestCommentList.add(CommentModel(id: commentId, comment: updatedComment));

//     return updateTask(taskModel, commentList: latestCommentList).then(
//       (value) {
//         context.read<BoardTaskCubit>().updateTask(value);
//         return value;
//       },
//     );
//   } else {
//     return Future.delayed(Duration.zero, () => taskModel);
//   }
// }

Future<TaskModel> deleteCommentFromTask(TaskModel taskModel, String commentId) {
  List<CommentModel> latestCommentList = List.from(taskModel.commentList);

  int index =
      latestCommentList.indexWhere((element) => element.id == commentId);

  if (index != -1) {
    latestCommentList.removeAt(index);

    return updateTask(taskModel, commentList: latestCommentList).then(
      (value) {
        generalContext.read<BoardTaskCubit>().updateTask(value);

        return value;
      },
    );
  } else {
    return Future.delayed(Duration.zero, () => taskModel);
  }
}
