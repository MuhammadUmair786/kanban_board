import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board/localization/local_keys.dart';
import 'package:localization/localization.dart';

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
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          margin: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: const TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                        Text(
                          timespansLK.i18n(),
                          textScaler: const TextScaler.linear(1.3),
                        ),
                        const SizedBox(height: 10),
                        Container(
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
                                  startTimeLK.i18n(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  endTimeLK.i18n(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  durationLK.i18n(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                padding:
                                    const EdgeInsets.only(bottom: 7, top: 7),
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
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${totalTimespanLK.i18n()}: ",
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
                ),
              ],
            ),
          ),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: "showTaskTimeSpanDialog",
  );
}
