import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // await flutterLocalNotificationsPlugin
    //     .pendingNotificationRequests()
    //     .then((pendingNotificationList) {
    //   PendingNotificationRequest? threePmNotification = pendingNotificationList
    //       .firstWhereOrNull((element) => element.id == threePmNotificationId);

    //   if (threePmNotification == null) {
    //     schedule3PmNotification();
    //   }
    // });
  }

  static NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'kanbanID',
        'Task Reminder',
        importance: Importance.max,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
        enableVibration: true,
        enableLights: true,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentSound: true,
      ),
    );
  }

  static tz.TZDateTime getNotificationTime(DateTime selectedDateTime) {
    // Convert the local DateTime to UTC
    final utcDateTime = selectedDateTime.toUtc();

    // Convert UTC DateTime to TZDateTime with local time zone
    final tz.TZDateTime tzSelectedDateTime =
        tz.TZDateTime.from(utcDateTime, tz.local);

    // Get the current time in the local time zone
    final now = tz.TZDateTime.now(tz.local);

    // Ensure the selected time is not before the current time
    if (tzSelectedDateTime.isBefore(now)) {
      throw Exception("Selected time is before the current time");
    }

    return tzSelectedDateTime;
  }

  // static tz.TZDateTime getNotificationTime(DateTime selectedDateTime) {
  //   final tz.TZDateTime tzSelectedDateTime = tz.TZDateTime(
  //     tz.local,
  //     selectedDateTime.year,
  //     selectedDateTime.month,
  //     selectedDateTime.day,
  //     selectedDateTime.hour,
  //     selectedDateTime.minute,
  //     selectedDateTime.second,
  //   );

  //   log("selected      =  ${selectedDateTime.toIso8601String()}");
  //   log("tz.TZDateTime =  ${tzSelectedDateTime.toIso8601String()}");

  //   final now = tz.TZDateTime.now(tz.local);

  //   // Ensure the selected time is not before the current time
  //   if (tzSelectedDateTime.isBefore(now)) {
  //     throw Exception("Selected time is before the current time");
  //   }

  //   return tzSelectedDateTime;
  // }

  static Future scheduleTaskNotification({
    required int id,
    required String title,
    required String description,
    required DateTime selectedDateTime,
  }) async {
    final PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    }

    if (Platform.isAndroid) {
      try {
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } catch (_) {}
    }

    flutterLocalNotificationsPlugin
        .zonedSchedule(
      id,
      title,
      description,
      getNotificationTime(selectedDateTime),
      notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    )
        .then((value) {
      log("notification scheduled");
    });
  }

  static Future<void> deleteReminder(int notificationId) async {
    await flutterLocalNotificationsPlugin.pendingNotificationRequests().then(
      (notificationList) {
        if (notificationList.any(
          (element) => element.id == notificationId,
        )) {
          flutterLocalNotificationsPlugin.cancel(notificationId);
        }
      },
    );
  }
}

void checkForAnyPendingNotification() {}
