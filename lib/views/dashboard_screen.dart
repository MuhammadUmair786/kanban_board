import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:localization/localization.dart';

import '../components/drawer.dart';
import '../components/task_card.dart';
import '../cubits/board_task/cubit.dart';
import '../localization/local_keys.dart';
import '../models/task_model.dart';
import '../utils/board_utils.dart';
import '../utils/custom_utils.dart';
import '../utils/default_boards_utils.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/snakbar.dart';
import 'add_board_screen.dart';
import 'add_task_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AppFlowyBoardScrollController boardScrollController =
      AppFlowyBoardScrollController();

  @override
  Widget build(BuildContext context) {
    double thisScreenWidth = MediaQuery.of(context).size.width;
    double boardWidth =
        thisScreenWidth > 700 ? thisScreenWidth * 0.3 : thisScreenWidth * 0.75;

    getSavedTheme();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kanban Board",
          textScaler: TextScaler.linear(1.5),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showHistoryDialog(context);
            },
            tooltip: historyLK.i18n(),
            icon: const Icon(Icons.history_sharp),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<BoardTaskCubit, BoardTaskState>(
        builder: (context, state) {
          const config = AppFlowyBoardConfig(
            groupBackgroundColor: Colors.white,
            stretchGroupHeight: true,
          );

          return AppFlowyBoard(
            controller: context.read<BoardTaskCubit>().boardController,
            cardBuilder: (context, group, groupItem) {
              return AppFlowyGroupCard(
                key: ValueKey(groupItem.id),
                child: TaskCard(
                  key: UniqueKey(),
                  taskModel: groupItem as TaskModel,
                ),
              );
            },
            boardScrollController: boardScrollController,
            footerBuilder: (context, columnData) {
              return AppFlowyGroupFooter(
                icon: const Icon(Icons.add, size: 20),
                title: Text(addTaskLK.i18n()),
                height: 50,
                margin: config.groupBodyPadding,
                onAddButtonClick: () {
                  boardScrollController.scrollToBottom(columnData.id);
                  showAddTaskDialog(context, columnData.id);
                },
              );
            },
            headerBuilder: (context, columnData) {
              return AppFlowyGroupHeader(
                icon: const Icon(Icons.lightbulb_circle),
                title: Expanded(
                  child: Text(columnData.headerData.groupName),
                ),
                addIcon: const Icon(Icons.edit, size: 20),
                moreIcon: const Icon(
                  Icons.delete_forever_outlined,
                  size: 20,
                ),
                onMoreButtonClick: () async {
                  if (columnData.items.isEmpty) {
                    await showConfirmationDialog(
                        title: columnData.headerData.groupName,
                        description: confirmDeleteLK.i18n(),
                        onYes: () async {
                          Navigator.of(context).pop();
                          await removeBoard(columnData.customData).then(
                            (_) {
                              context
                                  .read<BoardTaskCubit>()
                                  .deleteBoard(columnData.customData);
                            },
                          );
                        });
                  } else {
                    showSnackBar(
                      boardMustBeEmptyBeforeDeletingLK.i18n(),
                      isError: true,
                    );
                  }
                },
                onAddButtonClick: () {
                  showAddBoardDialog(
                    context,
                    boardModel: columnData.customData,
                  );
                },
                height: 50,
                margin: config.groupBodyPadding,
              );
            },
            groupConstraints: BoxConstraints.tightFor(width: boardWidth),
            config: config,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addDefaultBoards().then(
            (shouldReturn) {
              if (shouldReturn) {
                return;
              }
              showAddBoardDialog(context);
            },
          );
        },
        tooltip: addBoardLK.i18n(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
