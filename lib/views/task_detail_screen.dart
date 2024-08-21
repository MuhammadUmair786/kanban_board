import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../constants/extras.dart';
import '../cubits/task/cubit.dart';
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
  String durationString = "";
  late Duration existingDuration;

  late TimespanModel? pendingTimeSpan;
  Timer? timer;

  TextEditingController commentTextController = TextEditingController();

  String? updateCommentId;

  @override
  void initState() {
    existingDuration = widget.taskModel.getExistingDuration;

    int index = widget.taskModel.timespanList
        .lastIndexWhere((element) => element.endTime == null);

    if (index == -1) {
      pendingTimeSpan = null;
    } else {
      pendingTimeSpan = widget.taskModel.timespanList[index];
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (pendingTimeSpan == null) {
          setState(() {
            updateDurationString(existingDuration);
          });
        } else {
          startTimer();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final ongoingDuration =
            DateTime.now().difference(pendingTimeSpan!.startTime);
        final totalDuration = existingDuration + ongoingDuration;
        updateDurationString(totalDuration);
      });
    });
  }

  void updateDurationString(Duration duration) {
    durationString = formatDuration(duration);
  }

  @override
  Widget build(BuildContext context) {
    String titleText = widget.taskModel.title;
    Widget desiredWidget = BlocProvider(
      create: (context) => TaskCubit(widget.taskModel),
      child: BlocBuilder<TaskCubit, TaskModel>(
        builder: (context, task) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskModel.title,
                  textScaler: const TextScaler.linear(1.2),
                ),
                Text(widget.taskModel.description),
                if (widget.taskModel.timespanList.isNotEmpty) ...[
                  const Text(
                    "TImespans",
                    textScaler: TextScaler.linear(1.3),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Start Time",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "End Time",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Duration",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...widget.taskModel.timespanList
                      .where(
                        (element) => element.endTime != null,
                      )
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${Jiffy.parseFromDateTime(e.startTime).yMMMd}\n${Jiffy.parseFromDateTime(e.startTime).jm}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  "${Jiffy.parseFromDateTime(e.endTime!).yMMMd}\n${Jiffy.parseFromDateTime(e.endTime!).jm}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  formatDuration(
                                    e.endTime!.difference(e.startTime),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (widget.taskModel.isAnyPendingTimespan) ...[
                    // Row(
                    //   children: [
                    //     Expanded(child: Text(e.startTime.toIso8601String())),
                    //     const SizedBox(width: 5),
                    //     Expanded(child: Text(e.endTime!.toIso8601String())),
                    //     const SizedBox(width: 5),
                    //     Expanded(
                    //       child: Text(
                    //         formatDuration(
                    //           e.endTime!.difference(e.startTime),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.taskModel.isAnyPendingTimespan) {
                              // do nothing
                            } else {
                              addTimeSpan(context, widget.taskModel);
                            }
                          },
                          icon: const Icon(Icons.play_arrow),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.taskModel.isAnyPendingTimespan) {
                              endTimeSpan(context, widget.taskModel);
                            } else {
                              // do nothing
                            }
                          },
                          icon: const Icon(Icons.pause),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total Duration: ",
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatDuration(
                          widget.taskModel.getExistingDuration,
                        ),
                        textScaler: const TextScaler.linear(1.2),
                      )
                    ],
                  ),
                ],
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
                    if (updateCommentId == null) {
                      await addComment(context, widget.taskModel, value.trim());
                    } else {
                      await editComment(
                        context,
                        widget.taskModel,
                        updateCommentId!,
                        value.trim(),
                      );
                    }
                    commentTextController.clear();
                  },
                ),
                const SizedBox(height: 20),
                if (widget.taskModel.commentList.isNotEmpty) ...[
                  ...widget.taskModel.getCommentSortedList.map(
                    (e) => Container(
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
                                      onPressed: () {
                                        deleteComment(
                                            context, widget.taskModel, e.id);
                                      },
                                      padding: EdgeInsets.zero,
                                      iconSize: 20,
                                      icon: const Icon(
                                          Icons.delete_forever_rounded),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: IconButton(
                                      onPressed: () {
                                        updateCommentId = e.id;
                                        commentTextController.text = e.comment;
                                      },
                                      padding: EdgeInsets.zero,
                                      iconSize: 20,
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(Jiffy.parseFromDateTime(e.createdAt)
                                    .yMMMdjm),
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
