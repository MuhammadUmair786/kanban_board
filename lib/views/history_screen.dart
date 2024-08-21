import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/history_task_card.dart';
import '../constants/extras.dart';
import '../cubits/history/cubit.dart';
import '../utils/board_utils.dart';
import '../widgets/app_bar.dart';

void showHistoryDialog(BuildContext context) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HistoryWidget(),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const HistoryWidget();
      },
      barrierLabel: 'showHistoryDialog',
      barrierDismissible: true,
    );
  }
}

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({
    super.key,
  });

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  TextEditingController searchController = TextEditingController();
  String? filterdBoard;
  @override
  Widget build(BuildContext context) {
    String titleText = "History";
    Widget desiredWidget = BlocProvider(
      create: (context) => HistoryCubit(),
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, task) {
          if (task is HistoryInitial || task is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (task is HistoryError) {
            return Center(
              child: Text(task.message),
            );
          } else if (task is HistoryLoaded) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CupertinoSearchTextField(
                          placeholder: "Search here...",
                          onChanged: (value) {
                            context.read<HistoryCubit>().searchAndFilterTasks(
                                  searchText: value.trim(),
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      StatefulBuilder(builder: (context, innerState) {
                        return PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == filterdBoard) {
                              context.read<HistoryCubit>().searchAndFilterTasks(
                                    searchText: searchController.text.trim(),
                                    filterdBoardId: null,
                                  );
                              innerState(() {
                                filterdBoard = null;
                              });
                            } else {
                              context.read<HistoryCubit>().searchAndFilterTasks(
                                    searchText: searchController.text.trim(),
                                    filterdBoardId: value,
                                  );
                              innerState(() {
                                filterdBoard = value;
                              });
                            }
                          },
                          itemBuilder: (context) {
                            return getBoards().map(
                              (e) {
                                return PopupMenuItem(
                                  value: e.id,
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                      color: e.id == filterdBoard
                                          ? Colors.blue
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ).toList();
                          },
                          child: Stack(
                            children: [
                              const Icon(
                                Icons.filter_alt_sharp,
                                size: 28,
                              ),
                              if (filterdBoard != null)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...task.filteredTasks.map(
                        (taskModel) {
                          return HistoryTaskCard(taskModel: taskModel);
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: mobileAppbar(title: titleText),
        body: desiredWidget,
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: dialogMaxWidth),
          child: Material(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        titleText,
                      ),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                          splashRadius: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: double.infinity, child: desiredWidget),
              ],
            ),
          ),
        ),
      );
    }
  }
}
