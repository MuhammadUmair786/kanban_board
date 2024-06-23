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
        // Handle moving groups logic here if needed
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        log('Move item within group $groupId from $fromIndex to $toIndex');
        List<TaskModel> groupItemList = boardController
            .getGroupController(groupId)!
            .items
            .map(
              (element) => element as TaskModel,
            )
            .toList();

        updateTaskOrder(groupItemList, fromIndex, toIndex);
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        log('Move item from group $fromGroupId:$fromIndex to group $toGroupId:$toIndex');
        // final fromGroup = boardController.groups
        //     .firstWhere((group) => group.id == fromGroupId);
        // final toGroup =
        //     boardController.groups.firstWhere((group) => group.id == toGroupId);
        // final item = fromGroup.items[fromIndex]
        //     as AppFlowyGroupItem; // Cast to AppFlowyGroupItem
        // // Perform any additional operations with the item
        // print('Moved item: ${item.title}');
        // // Update the groups to reflect the move
        // fromGroup.removeItem(fromIndex);
        // toGroup.insertItem(toIndex, item);
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
    boardController.addGroup(AppFlowyGroupData(
        id: boardModel.id, name: boardModel.name, customData: boardModel));
  }

  void addTask(TaskModel taskModel) {
    boardController.addGroupItem(taskModel.boardId, taskModel);
  }
}
