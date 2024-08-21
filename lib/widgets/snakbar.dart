import 'package:flutter/material.dart';
import 'package:kanban_board/constants/extras.dart';

void showSnackBar(
  String message, {
  Duration duration = const Duration(seconds: 4),
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(generalContext).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message),
      duration: duration,
    ),
  );
}
