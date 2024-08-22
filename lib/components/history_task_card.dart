import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board/utils/board_utils.dart';

import '../helpers/formate_duration.dart';
import '../models/task_model.dart';
import '../views/task_detail_screen.dart';
import '../widgets/fitted_text_widget.dart';

class HistoryTaskCard extends StatefulWidget {
  const HistoryTaskCard({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  State<HistoryTaskCard> createState() => _HistoryTaskCardState();
}

class _HistoryTaskCardState extends State<HistoryTaskCard> {
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
    double thisScreenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: InkWell(
          onTap: () {
            showTaskDetailDialog(context, widget.taskModel);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
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
                  const SizedBox(height: 3),
                  Text(
                      "Time Spend: ${formatDuration(widget.taskModel.getExistingDuration)}"),
                ],
                const Divider(
                  thickness: 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: thisScreenWidth * 0.6,
                      child: FittedText(
                        widget.taskModel.updatedAt == null
                            ? "Created At: ${Jiffy.parseFromDateTime(widget.taskModel.createdAt).yMMMEdjm}"
                            : "Last Update: ${Jiffy.parseFromDateTime(widget.taskModel.updatedAt!).yMMMEdjm}",
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: thisScreenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: FittedText(
                        getBoardById(widget.taskModel.boardId).name,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
