import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board/models/task_model.dart';
import 'package:kanban_board/utils/notification_utils.dart';
import 'package:kanban_board/utils/task_utils.dart';
import 'package:kanban_board/widgets/fitted_text_widget.dart';
import 'package:localization/localization.dart';

import '../constants/extras.dart';
import '../localization/local_keys.dart';
import '../widgets/app_bar.dart';

void showScheduledReminderDialog(BuildContext context) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const ScheduledReminderWidget(),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ScheduledReminderWidget();
      },
      barrierLabel: 'showScheduleReminderDialog',
      barrierDismissible: true,
    );
  }
}

class ScheduledReminderWidget extends StatefulWidget {
  const ScheduledReminderWidget({
    super.key,
  });

  @override
  State<ScheduledReminderWidget> createState() =>
      _ScheduledReminderWidgetState();
}

class _ScheduledReminderWidgetState extends State<ScheduledReminderWidget> {
  TextEditingController searchController = TextEditingController();
  String? filterdBoard;
  @override
  Widget build(BuildContext context) {
    double thisScreenHeight = MediaQuery.of(context).size.height;
    String titleText = upcomingTasksLK.i18n();
    Widget desiredWidget = FutureBuilder<List<PendingNotificationRequest>>(
      future: NotificationService.flutterLocalNotificationsPlugin
          .pendingNotificationRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: thisScreenHeight * 0.45,
            alignment: Alignment.bottomCenter,
            child: const CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: thisScreenHeight * 0.45,
            alignment: Alignment.bottomCenter,
            child: const Text("Unexpected error"),
          );
        }
        List<PendingNotificationRequest> desiredList = snapshot.requireData;

        if (desiredList.isEmpty) {
          return Container(
            height: thisScreenHeight * 0.45,
            alignment: Alignment.bottomCenter,
            child: Text(noUpcomingTasksLK.i18n()),
          );
        }
        return ListView.builder(
          itemCount: desiredList.length,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemBuilder: (context, index) {
            TaskModel taskModel = getTaskById(desiredList[index].id.toString());
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text(
                            taskModel.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      if (taskModel.scheduleAt != null) ...[
                        Expanded(
                          flex: 5,
                          child: FittedText(
                              Jiffy.parseFromDateTime(taskModel.scheduleAt!)
                                  .yMMMEdjm),
                        )
                      ],
                      IconButton(
                        onPressed: () async {
                          await removeReminderFromTask(taskModel).then(
                            (value) {
                              if (value != null) {
                                setState(() {});
                              }
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.timer_off_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
                Flexible(child: desiredWidget),
              ],
            ),
          ),
        ),
      );
    }
  }
}
