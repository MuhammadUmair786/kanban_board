import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board/utils/task_utils.dart';
import 'package:kanban_board/widgets/confirmation_dialog.dart';
import 'package:kanban_board/widgets/custom_buttons.dart';

import '../components/task_timespan_dialog.dart';
import '../constants/extras.dart';
import '../helpers/formate_duration.dart';
import '../models/task_model.dart';
import '../utils/comment_utils.dart';
import '../utils/time_span_utils.dart';
import '../widgets/app_bar.dart';

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskModel.title,
            textScaler: const TextScaler.linear(1.2),
          ),
          Text(taskModel.description),
          if (taskModel.timespanList.isNotEmpty) ...[
            CustomElevatedButton(
                label: "Show Time Span",
                onPressed: () {
                  showTaskTimeSpanDialog(taskModel);
                }),
          ],
          if (taskModel.isScheduled) ...[
            Text(
              "Alarm scheduled at: ${Jiffy.parseFromDateTime(taskModel.scheduleAt!).yMMMEdjm}",
            ),
            CustomElevatedButton(
                label: "Remove Reminder",
                onPressed: () async {
                  await removeReminderFromTask(taskModel).then(
                    (value) {
                      if (value != null) {
                        updateThisScreenTask(value);
                      }
                    },
                  );
                }),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                icon: const Icon(Icons.play_arrow),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(durationString),
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
                icon: const Icon(Icons.pause),
              ),
            ],
          ),
          TextFormField(
            controller: commentTextController,
            decoration: const InputDecoration(
              hintText: "Add new comment",
            ),
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) async {
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
              (e) => Container(
                key: ValueKey(e.id),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        e.comment,
                        textScaler: const TextScaler.linear(1.2),
                      ),
                    ),
                    const Divider(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: IconButton(
                                onPressed: () async {
                                  await showConfirmationDialog(
                                    title: "Delete Comment",
                                    description:
                                        "Are you sure you want to delete comment",
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
                                icon: const Icon(Icons.delete_forever_rounded),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              Jiffy.parseFromDateTime(e.createdAt).yMMMdjm),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
        color: Colors.red,
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
