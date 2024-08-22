import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kanban_board/constants/extras.dart';
import 'package:kanban_board/cubits/history/cubit.dart';
import 'package:kanban_board/routes/names.dart';
import 'package:kanban_board/utils/notification_utils.dart';
import 'package:localization/localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'cubits/board_task/cubit.dart';
import 'constants/theme.dart';
import 'cubits/theme/cubit.dart';
import 'firebase_options.dart';
import 'localization/localization.dart';
import 'routes/route_list.dart';
import 'utils/local_storage_utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> main() async {
  // final WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Future.wait(
    [
      NotificationService().initNotification(),
      initilizeGetStorageContainer(),
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    ],
  );

  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MapLocalization.delegate.translations = translationList;
    // context.read<ItemBloc>().add(LoadItems());
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardTaskCubit>(
          create: (context) => BoardTaskCubit()..loadBoardsAndTasks(),
        ),
        BlocProvider(
          create: (context) => ThemeLocaleCubit(),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: BlocBuilder<ThemeLocaleCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            // key: ValueKey(state.themeData.hashCode + state.locale.hashCode),
            title: 'Kanban Board',
            navigatorKey: navigatorKey,
            theme: state.themeData,
            darkTheme: darkMinimalistTheme,
            supportedLocales: supportedLocales,
            locale: state.locale,
            localizationsDelegates: [
              // delegate from flutter_localization
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              // local translations delegate
              MapLocalization.delegate,
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: defaultRouteKey,
            routes: routeList,
          );
        },
      ),
    );
  }
}
