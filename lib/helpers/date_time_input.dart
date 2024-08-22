import 'package:flutter/material.dart';

import '../constants/extras.dart';

Future<DateTime?> getDateTimeInput(DateTime firstDateTime, DateTime lastDate,
    {bool isOnlyDate = false}) async {
  FocusScope.of(generalContext).unfocus();

  DateTime dateTime = DateTime.now();

  return showDatePicker(
    context: generalContext,
    initialDate: dateTime,
    firstDate: firstDateTime,
    lastDate: lastDate,
  ).then(
    (DateTime? pickedDate) {
      if (isOnlyDate) {
        return pickedDate;
      }
      if (pickedDate == null) {
        return null;
      } else {
        return showTimePicker(
          context: generalContext,
          initialTime: TimeOfDay.fromDateTime(dateTime),
        ).then(
          (TimeOfDay? pickedTime) {
            return DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime?.hour ?? 0,
              pickedTime?.minute ?? 0,
            );
          },
        );
      }
    },
  );
}
