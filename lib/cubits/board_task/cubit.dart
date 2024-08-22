import 'dart:developer';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/board_model.dart';
import '../../models/task_model.dart';
import '../../utils/board_utils.dart';
import '../../utils/task_utils.dart';
import 'state.dart';

class BoardTaskCubit extends Cubit<BoardTaskState> {
  late final AppFlowyBoardController boardController;

  BoardTaskCubit() : super(BoardTaskLoadInProgress()) {
    boardController = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        log('Move group from $fromIndex to $toIndex');
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        log('Move item within group $groupId from $fromIndex to $toIndex');
        List<TaskModel> groupItemList = boardController
            .getGroupController(groupId)!
            .items
            .map((element) => element as TaskModel)
            .toList();

        updateTaskOrderWithinBoard(groupItemList, fromIndex, toIndex);
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        log('Move item from group $fromGroupId:$fromIndex to group $toGroupId:$toIndex');

        // TaskModel draggedTask = boardController
        //     .getGroupController(fromGroupId)!
        //     .items
        //     .map((element) => element as TaskModel)
        //     .toList()[fromIndex];

        List<TaskModel> newGroupItemList = boardController
            .getGroupController(toGroupId)!
            .items
            .map((element) => element as TaskModel)
            .toList();

        TaskModel draggedTask = newGroupItemList[toIndex];

        log(draggedTask.toJson().toString());

        updateTaskOrderToOtherBoard(
          newBoardId: toGroupId,
          newBoardTaskList: newGroupItemList,
          draggedTask: draggedTask,
          newIndex: toIndex,
        );
      },
    );
  }

  void loadBoardsAndTasks() async {
    emit(BoardTaskLoadInProgress());
    try {
      List<BoardModel> boardList = getBoards();
      List<TaskModel> taskList = getTasks();
      for (BoardModel board in boardList) {
        List<AppFlowyGroupItem> itemList = List.from(
          taskList.where((element) =>
              element.boardId == board.id && element.isCompleted == false),
        );

        itemList.sort(
            (a, b) => (a as TaskModel).order.compareTo((b as TaskModel).order));
        boardController.addGroup(
          AppFlowyGroupData(
            id: board.id,
            name: board.name,
            customData: board,
            items: itemList,
          ),
        );
      }
      emit(BoardTaskLoadSuccess());
    } catch (_) {
      emit(BoardOperationFailure());
    }
  }

  void addBoard(BoardModel boardModel) {
    boardController.addGroup(
      AppFlowyGroupData(
        id: boardModel.id,
        name: boardModel.name,
        customData: boardModel,
        items: [],
      ),
    );
  }

  void addMultipleBoards(List<BoardModel> boardList) {
    boardController.addGroups(boardList
        .map(
          (e) => AppFlowyGroupData(
            id: e.id,
            name: e.name,
            customData: e,
            items: [],
          ),
        )
        .toList());
  }

  void updateBoard(BoardModel boardModel) {
    List<AppFlowyGroupData<dynamic>> groupList =
        boardController.groupDatas.toList();

    int desiredIndex =
        groupList.indexWhere((element) => element.id == boardModel.id);

    if (desiredIndex != -1) {
      AppFlowyGroupData updatedGroup = AppFlowyGroupData(
        id: boardModel.id,
        name: boardModel.name,
        customData: boardModel,
        items: groupList[desiredIndex].items,
      );
      boardController.removeGroup(boardModel.id);
      boardController.insertGroup(desiredIndex, updatedGroup);
    }
  }

  void deleteBoard(BoardModel boardModel) {
    boardController.removeGroup(boardModel.id);
  }

  void addTask(TaskModel taskModel) {
    boardController.addGroupItem(taskModel.boardId, taskModel);
  }

  void updateTask(TaskModel taskModel) {
    boardController.updateGroupItem(taskModel.boardId, taskModel);
  }

  void deleteTask(TaskModel taskModel) {
    boardController.removeGroupItem(taskModel.boardId, taskModel.id);
  }
}
