import 'dart:developer';

import 'package:flutter/material.dart';

String getTimeBasedId() {
  int timePart = DateTime.now().microsecondsSinceEpoch;
  int hashPart = UniqueKey().hashCode;
  String id = "${(timePart + hashPart).remainder(1 << 30)}";
  log(id);
  return id;
}
