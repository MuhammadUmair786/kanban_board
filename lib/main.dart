import 'package:flutter/material.dart';
import 'package:kanban_board/routes/names.dart';
import 'package:localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants/theme.dart';
import 'localization/localization.dart';
import 'routes/route_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MapLocalization.delegate.translations = translationList;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: classicBlueTheme,
      darkTheme: darkMinimalistTheme,
      supportedLocales: supportedLocales,
      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // local translations delegate
        MapLocalization.delegate,
      ],
      initialRoute: defaultRouteKey,
      routes: routeList,
    );
  }
}
