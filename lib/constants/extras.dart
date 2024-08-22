import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String TEST_TOKEN = "7f2d832b5cfe8017c07294d10fb3263a1455ea67";

const String BASEURL = "https://api.todoist.com/rest/v2";

double borderRadius = 20;

Map<String, String> get apiHeader => {
      HttpHeaders.contentTypeHeader: "application/json",
      // HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $TEST_TOKEN"
    };

bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

const double dialogMaxWidth = 700;

final navigatorKey = GlobalKey<NavigatorState>();

BuildContext generalContext = navigatorKey.currentState!.overlay!.context;
