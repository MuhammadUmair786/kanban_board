import 'package:flutter/material.dart';

import '../helpers/formate_duration.dart';
import '../models/task_model.dart';
import '../views/task_detail_screen.dart';
import '../widgets/fitted_text_widget.dart';
import 'task_timespan_dialog.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
              Text(
                widget.taskModel.title,
                textScaler: const TextScaler.linear(1.2),
              ),
              Text(widget.taskModel.description),
              if (widget.taskModel.getExistingDuration != Duration.zero) ...[
                Row(
                  children: [
                    Flexible(
                      child: FittedText(
                        "Time Spend: ${formatDuration(
                          widget.taskModel.getExistingDuration,
                        )}",
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    if (widget.taskModel.timespanList.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          showTaskTimeSpanDialog(widget.taskModel);
                        },
                        tooltip: "Show Time Span",
                        icon: const Icon(
                          Icons.timeline,
                        ),
                      )
                  ],
                )
              ],
              if (widget.taskModel.isAnyPendingTimespan) ...[
                const Text("to be contiue"),
              ],
              if (widget.taskModel.isScheduled) ...[
                const Text("Reminder"),
              ],
              const Divider(
                thickness: 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.taskModel.commentList.length} comments"),
                  // Text(
                  //   widget.taskModel.order.toString(),
                  //   textScaler: const TextScaler.linear(2),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
