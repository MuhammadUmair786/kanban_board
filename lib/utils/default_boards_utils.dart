import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/constants/extras.dart';
import 'package:kanban_board/cubits/board_task/cubit.dart';
import 'package:kanban_board/models/board_model.dart';

import '../widgets/confirmation_dialog.dart';
import 'board_utils.dart';

/// should Return
Future<bool> addDefaultBoards() async {
  if (getBoards().isEmpty) {
    return showConfirmationDialog(
        title: "Default Boards",
        description: "Do you want to add default boards to start quickly",
        onYes: () async {
          Navigator.of(generalContext).pop(true); // close dialogs
          List<Future<BoardModel>> futureList =
              ["ToDo", "In Progress", "Completed"]
                  .map(
                    (e) => addBoard(e),
                  )
                  .toList();

          await Future.wait(futureList).then(
            (boardList) {
              generalContext
                  .read<BoardTaskCubit>()
                  .addMultipleBoards(boardList);
            },
          );
        }).then(
      (value) {
        return value ?? false;
      },
    );
  } else {
    return false;
  }
}
