import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/cubits/board_task/cubit.dart';
import 'package:kanban_board/utils/task_utils.dart';

import '../helpers/formate_duration.dart';
import '../models/task_model.dart';
import '../utils/time_span_utils.dart';
import '../views/task_detail_screen.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String durationString = "";
  late Duration existingDuration;

  late TimespanModel? pendingTimeSpan;
  Timer? timer;

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
    updateDurationString(existingDuration);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (pendingTimeSpan == null) {
          // do nothing
          // setState(() {
          //   updateDurationString(existingDuration);
          // });
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
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: const BorderSide()),
      child: InkWell(
        onTap: () {
          showTaskDetailDialog(context, widget.taskModel);
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    onPressed: () async {
                      await removeTask(widget.taskModel);
                      context
                          .read<BoardTaskCubit>()
                          .deleteTask(widget.taskModel);
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.delete_forever_outlined),
                  ),
                ),
              ),
              Text(
                widget.taskModel.title,
                textScaler: const TextScaler.linear(1.2),
              ),
              Text(widget.taskModel.description),
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
                  Expanded(
                    child: Center(
                      child: Text(durationString),
                    ),
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
              const Divider(
                thickness: 0.1,
              ),
              Text("${widget.taskModel.commentList.length} comments"),
            ],
          ),
        ),
      ),
    );
  }
}
