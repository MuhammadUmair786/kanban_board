import 'package:flutter/material.dart';

String getTimeBasedId() {
  int timePart = DateTime.now().microsecondsSinceEpoch;
  int hashPart = UniqueKey().hashCode;
  return "${(timePart + hashPart).remainder(1 << 30)}";
}
