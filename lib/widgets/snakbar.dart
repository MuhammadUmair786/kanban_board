import 'package:flutter/material.dart';
import 'package:kanban_board/constants/extras.dart';

void showSnackBar(
  String message, {
  Duration duration = const Duration(seconds: 4),
  bool isError = false,
}) {
  ScaffoldMessenger.of(generalContext).showSnackBar(
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(message),
      duration: duration,
    ),
  );
}
