import 'package:firebase_analytics/firebase_analytics.dart';

enum AnalyticEvent { reminder, defaultBoard, historyFilter }

Future<void> logAnalyticEvent(AnalyticEvent event) async {
  await FirebaseAnalytics.instance.logEvent(
    name: event.name,
  );
}
