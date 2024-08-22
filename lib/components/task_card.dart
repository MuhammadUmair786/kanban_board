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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        // color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () {
            showTaskDetailDialog(context, widget.taskModel);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskModel.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.taskModel.description,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
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
                const Divider(
                  thickness: 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.mode_comment_outlined,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.taskModel.commentList.length}",
                    ),
                    const Spacer(),
                    if (widget.taskModel.isAnyPendingTimespan) ...[
                      const Icon(
                        Icons.play_circle_outline,
                        size: 20,
                      ),
                    ],
                    const SizedBox(width: 5),
                    if (widget.taskModel.isScheduled) ...[
                      const Icon(
                        Icons.watch_later_outlined,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
