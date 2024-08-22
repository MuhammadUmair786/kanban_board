import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board/constants/theme.dart';
import 'package:kanban_board/widgets/custom_text_feilds.dart';
import 'package:localization/localization.dart';

import '../components/task_timespan_dialog.dart';
import '../constants/extras.dart';
import '../helpers/formate_duration.dart';
import '../localization/local_keys.dart';
import '../models/task_model.dart';
import '../utils/comment_utils.dart';
import '../utils/task_utils.dart';
import '../utils/time_span_utils.dart';
import '../widgets/app_bar.dart';
import '../widgets/confirmation_dialog.dart';

void showTaskDetailDialog(BuildContext context, TaskModel taskModel) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => TaskDetailWidget(
          taskModel: taskModel,
        ),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return TaskDetailWidget(
          taskModel: taskModel,
        );
      },
      barrierLabel: 'showTaskDetailDialog',
      barrierDismissible: true,
    );
  }
}

class TaskDetailWidget extends StatefulWidget {
  const TaskDetailWidget({
    super.key,
    required this.taskModel,
  });
  final TaskModel taskModel;

  @override
  State<TaskDetailWidget> createState() => _TaskDetailWidgetState();
}

class _TaskDetailWidgetState extends State<TaskDetailWidget> {
  late TaskModel taskModel;
  String durationString = "";
  late Duration existingDuration;

  late TimespanModel? pendingTimeSpan;
  Timer? timer;

  TextEditingController commentTextController = TextEditingController();

  @override
  void initState() {
    taskModel = widget.taskModel;
    durationString = formatDuration(taskModel.getExistingDuration);
    manageTimer();
    super.initState();
  }

  void manageTimer() {
    existingDuration = taskModel.getExistingDuration;

    int index = taskModel.timespanList
        .lastIndexWhere((element) => element.endTime == null);

    if (index == -1) {
      pendingTimeSpan = null;
    } else {
      pendingTimeSpan = taskModel.timespanList[index];
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        log("inside postframe call");
        if (pendingTimeSpan == null) {
          log("peding is null");
          setState(() {
            updateDurationString(existingDuration);
          });
        } else {
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            setState(() {
              final ongoingDuration =
                  DateTime.now().difference(pendingTimeSpan!.startTime);
              final totalDuration = existingDuration + ongoingDuration;
              updateDurationString(totalDuration);
            });
          });
        }
      },
    );
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void stopTimer() {
    try {
      timer?.cancel();
    } catch (_) {}
  }

  void updateDurationString(Duration duration) {
    durationString = formatDuration(duration);
  }

  void updateThisScreenTask(TaskModel newValue) {
    setState(() {
      taskModel = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleText = taskModel.title;
    Widget desiredWidget = SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskModel.title,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
          ),
          Text(
            taskModel.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          if (taskModel.isScheduled) ...[
            Material(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Alarm Scheduled At",
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                            ),
                          ),
                          Text(
                            Jiffy.parseFromDateTime(taskModel.scheduleAt!)
                                .yMMMEdjm,
                            style: const TextStyle(
                              fontSize: fontSizeLarge,
                              color: Colors.black, // TODO fix accordngly
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () async {
                        await removeReminderFromTask(taskModel).then(
                          (value) {
                            if (value != null) {
                              updateThisScreenTask(value);
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: handle onclicking
              IconButton(
                onPressed: () async {
                  if (taskModel.isAnyPendingTimespan) {
                    // do nothing
                  } else {
                    await addTimeSpan(context, taskModel).then(
                      (value) async {
                        updateThisScreenTask(value);
                        manageTimer();
                      },
                    );
                  }
                },
                icon: const Icon(
                  Icons.play_arrow,
                  size: 35,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    durationString,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (taskModel.isAnyPendingTimespan) {
                    await endTimeSpan(context, taskModel).then(
                      (value) {
                        stopTimer();
                        updateThisScreenTask(value);
                      },
                    );
                  } else {
                    // do nothing
                  }
                },
                icon: const Icon(
                  Icons.pause,
                  size: 35,
                ),
              ),
            ],
          ),
          CustomTextFormFieldWithLabel(
            labelText: "Comment",
            hintText: "Add new comment...",
            controller: commentTextController,
            textInputAction: TextInputAction.done,
            onActionComplete: (value) async {
              if (value.isEmpty) {
                return;
              }

              await addComment(context, taskModel, value.trim()).then(
                (value) {
                  updateThisScreenTask(value);
                  commentTextController.clear();
                },
              );
            },
          ),
          const SizedBox(height: 20),
          if (taskModel.commentList.isNotEmpty) ...[
            ...taskModel.getCommentSortedList.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Stack(
                  children: [
                    Material(
                      key: ValueKey(e.id),
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.comment,
                              textScaler: const TextScaler.linear(1.2),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                height: 5,
                                color: Colors.grey[200],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                Jiffy.parseFromDateTime(e.createdAt).yMMMdjm,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          onPressed: () async {
                            await showConfirmationDialog(
                              title: "Delete Comment",
                              description: confirmDeleteLK.i18n(),
                              onYes: () async {
                                Navigator.of(context).pop();
                                await deleteComment(
                                  taskModel,
                                  e.id,
                                ).then(
                                  (value) {
                                    updateThisScreenTask(value);
                                  },
                                );
                              },
                            );
                          },
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    Widget deleteTaskButton = SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () async {
          await removeTask(taskModel).then(
            (value) {
              if (value) {
                Navigator.of(context).pop();
              }
            },
          );
        },
        icon: const Icon(Icons.delete_forever),
        padding: EdgeInsets.zero,
        splashRadius: 15,
      ),
    );

    Widget timeSpanButton = taskModel.timespanList.isEmpty
        ? const SizedBox()
        : SizedBox(
            width: 25,
            height: 25,
            child: IconButton(
              onPressed: () async {
                showTaskTimeSpanDialog(taskModel);
              },
              tooltip: "Show Time Span",
              icon: const Icon(
                Icons.timeline,
              ),
              padding: EdgeInsets.zero,
              splashRadius: 15,
            ),
          );

    if (isMobile) {
      return Scaffold(
        appBar: mobileAppbar(
          title: titleText,
          actionWidgetsList: [
            deleteTaskButton,
            const SizedBox(width: 10),
            timeSpanButton,
            const SizedBox(width: 10),
          ],
        ),
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
                      Expanded(
                        child: Text(
                          titleText,
                        ),
                      ),
                      deleteTaskButton,
                      const SizedBox(width: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          timeSpanButton,
                          const SizedBox(width: 10),
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
                          const SizedBox(width: 10),
                        ],
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
