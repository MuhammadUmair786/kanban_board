import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/utils/board_utils.dart';
import 'package:kanban_board/views/add_task_screen.dart';
import 'package:kanban_board/views/history_screen.dart';
import 'package:kanban_board/widgets/confirmation_dialog.dart';
import 'package:kanban_board/widgets/snakbar.dart';

import '../components/drawer.dart';
import '../components/task_card.dart';
import '../cubits/board_task/cubit.dart';
import '../cubits/board_task/state.dart';
import '../models/task_model.dart';
import '../utils/default_boards_utils.dart';
import 'add_board_screen.dart';

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
            icon: const Icon(Icons.history_sharp),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<BoardTaskCubit, BoardTaskState>(
        builder: (context, state) {
          const config = AppFlowyBoardConfig(
            groupBackgroundColor: Color.fromRGBO(247, 248, 252, 1),
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
                title: const Text('New'),
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
                  color: Colors.red,
                ),
                onMoreButtonClick: () async {
                  if (columnData.items.isEmpty) {
                    await showConfirmationDialog(
                        title: columnData.headerData.groupName,
                        description:
                            "Are you sure you want to delete this board",
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
                      "Board should be empty before delating",
                      backgroundColor: Colors.red,
                    );
                  }
                },
                onAddButtonClick: () {
                  showAddBoardDialog(context,
                      boardModel: columnData.customData);
                },
                height: 50,
                margin: config.groupBodyPadding,
              );
            },
            groupConstraints: const BoxConstraints.tightFor(width: 280),
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
        tooltip: "Add new board",
        child: const Icon(Icons.add),
      ),
    );
  }
}
