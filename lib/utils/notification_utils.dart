import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
    final tz.TZDateTime tzSelectedDateTime =
        tz.TZDateTime.from(selectedDateTime.toUtc(), tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (tzSelectedDateTime.isBefore(now)) {
      throw Exception("Selected time is before the current time");
    }

    return tzSelectedDateTime;
  }

  static Future<void> cancelNotificationIfAlreadyExist(
      int notificationId) async {
    await flutterLocalNotificationsPlugin.pendingNotificationRequests().then(
      (list) async {
        if (list.any((element) => element.id == notificationId)) {
          await flutterLocalNotificationsPlugin.cancel(notificationId);
        }
      },
    );
  }

  static Future scheduleTaskNotification({
    required int id,
    required String title,
    required String description,
    required DateTime selectedDateTime,
  }) async {
    if (kIsWeb) {
      return;
    }

    await cancelNotificationIfAlreadyExist(id);
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
