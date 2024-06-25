import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/helpers/formate_duration.dart';

import '../constants/extras.dart';
import '../cubits/task/cubit.dart';
import '../models/task_model.dart';
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
      barrierLabel: 'showEventsDialog',
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

  @override
  void initState() {
    existingDuration = widget.taskModel.getExistingDuration;

    log("Existing durati ${existingDuration.inSeconds}");
    int index = widget.taskModel.timespanList
        .lastIndexWhere((element) => element.endTime == null);

    if (index == -1) {
      pendingTimeSpan = null;
    } else {
      pendingTimeSpan = widget.taskModel.timespanList[index];
    }

    log(index.toString());

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
    String titleText = "";
    Widget desiredWidget = BlocProvider(
      create: (context) => TaskCubit(widget.taskModel),
      child: BlocBuilder<TaskCubit, TaskModel>(builder: (context, task) {
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
                const Row(
                  children: [
                    Expanded(child: Text("Start Time")),
                    SizedBox(width: 5),
                    Expanded(child: Text("End Time")),
                    SizedBox(width: 5),
                    Expanded(child: Text("Duration")),
                  ],
                ),
                ...widget.taskModel.timespanList
                    .where(
                      (element) => element.endTime != null,
                    )
                    .map(
                      (e) => Row(
                        children: [
                          Expanded(child: Text(e.startTime.toIso8601String())),
                          const SizedBox(width: 5),
                          Expanded(child: Text(e.endTime!.toIso8601String())),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              formatDuration(
                                e.endTime!.difference(e.startTime),
                              ),
                            ),
                          ),
                        ],
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
                const Text(
                  "Total Duration",
                  textScaler: TextScaler.linear(1.3),
                ),
              ]
            ],
          ),
        );
      }),
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
