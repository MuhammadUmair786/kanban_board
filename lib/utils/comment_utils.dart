import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/helpers/time_based_id.dart';
import 'package:kanban_board/utils/task_utils.dart';

import '../cubits/board_task/cubit.dart';
import '../models/task_model.dart';

Future<TaskModel> addComment(
    BuildContext context, TaskModel taskModel, String comment) async {
  List<CommentModel> latestCommentList = List.from(taskModel.commentList);
  latestCommentList.add(
    CommentModel(id: getTimeBasedId(), comment: comment),
  );
  return updateTask(
    taskModel,
    commentList: latestCommentList,
  ).then(
    (value) {
      log(jsonEncode(value.toJson()));
      context.read<BoardTaskCubit>().updateTask(value);
      return value;
    },
  );
}

Future<TaskModel> editComment(BuildContext context, TaskModel taskModel,
    String commentId, String updatedComment) {
  List<CommentModel> latestCommentList = List.from(taskModel.commentList);

  int index =
      latestCommentList.indexWhere((element) => element.id == commentId);

  if (index != -1) {
    latestCommentList.removeAt(index);
    latestCommentList.add(CommentModel(id: commentId, comment: updatedComment));

    return updateTask(taskModel, commentList: latestCommentList).then(
      (value) {
        context.read<BoardTaskCubit>().updateTask(value);
        return value;
      },
    );
  } else {
    return Future.delayed(Duration.zero, () => taskModel);
  }
}

Future<TaskModel> deleteComment(
    BuildContext context, TaskModel taskModel, String commentId) {
  List<CommentModel> latestCommentList = List.from(taskModel.commentList);

  int index =
      latestCommentList.indexWhere((element) => element.id == commentId);

  if (index != -1) {
    latestCommentList.removeAt(index);

    return updateTask(taskModel, commentList: latestCommentList).then(
      (value) {
        context.read<BoardTaskCubit>().updateTask(value);
        return value;
      },
    );
  } else {
    return Future.delayed(Duration.zero, () => taskModel);
  }
}
