import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../constants/extras.dart';
import '../helpers/formate_duration.dart';
import '../models/task_model.dart';

Future<dynamic> showTaskTimeSpanDialog(TaskModel taskModel) async {
  return showGeneralDialog(
    context: generalContext,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          margin: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: const TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Timespans",
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
                  ...taskModel.timespanList
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
                          taskModel.getExistingDuration,
                        ),
                        textScaler: const TextScaler.linear(1.2),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: "showTaskTimeSpanDialog",
  );
}
