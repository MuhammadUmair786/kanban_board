import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/constants/extras.dart';
import 'package:kanban_board/cubits/board_task/cubit.dart';
import 'package:kanban_board/utils/board_utils.dart';
import 'package:kanban_board/utils/task_utils.dart';

import '../utils/custom_utils.dart';

const String driveBackUpParentFolderName = "kanbanDataFolder";
const String driveBackUpFileName = "kanban_backup";
const String driveBackUpFileExtension = "json";

const String updatedAtKey = "updatedAt";
const String boardKey = "board";
const String tasksKey = "tasks";

Map<String, dynamic> getLocalDataConvertedIntoBackUpStandard() {
  return <String, dynamic>{
    updatedAtKey: DateTime.now().toUtc().toIso8601String(),
    boardKey: getBoards().map((e) => e.toJson()).toList(),
    tasksKey: getTasks().map((e) => e.toJson()).toList(),
  };
}

Future<void> initilizeDataFromBackupJSON(Map<String, dynamic> json) async {
  log(json[updatedAtKey]);
  List<Future<dynamic>> futureList = <Future<dynamic>>[];
  if (json[updatedAtKey] != null) {
    DateTime? dateTime = DateTime.tryParse(json[updatedAtKey]);
    if (dateTime != null) {
      futureList.add(setLastUpdatebackUp(dateTime));
    }
  }
  if (json[boardKey] != null) {
    futureList.add(addBoardInBulk(json[boardKey]));
  }
  if (json[tasksKey] != null) {
    futureList.add(addTasksInBulk(json[tasksKey]));
  }

  await Future.wait(futureList).then((value) async {
    generalContext.read<BoardTaskCubit>().loadBoardsAndTasks();
  });
}

// final Map<String, dynamic> config = {
//   // 'api': {
//   //   ...
//   // },
//   'auth': {
//     'apple': {'UID': 'APPLE_UID_KEY'},
//     'google': {'UID': 'GOOGLE_UID_KEY'}
//   },
//   'cloud': {
//     'common': {
//       'DRIVE_BACKUP_DIR_PARENT': 'fullyNotedDataFolder',
//       'DRIVE_BACKUP_FILE_NAME': 'fully_noted_backup',
//       'DRIVE_BACKUP_FILE_EXT': 'json',
//     },
//     // 'apple': {'ICLOUD_CONTAINER_ID': 'iCloud.com.example.flutter_app_starter'},
//     'google': {}
//   },
//   // 'payment': {
//   //   ...
//   // }
// };

/// Android client for com.app.fullynoted (auto created by Google Service)
///
///Oct 2, 2023
///
/// Also called as secrect
// Map<String, dynamic> clientSecretJson = {
//   "installed": {
//     "client_id":
//         "482064951726-net1rdsg8r1hsjrqhlsvmahqvbo0pvpf.apps.googleusercontent.com",
//     "project_id": "blue-ridge-8cbf2",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs"
//   }
// };

/// Android key (auto created by Firebase)
///
/// Also called as identifier
// String get getClientId => clientSecretJson["installed"]["client_id"];

/// Also called as secrect
///
// String get getApiKey => 'AIzaSyAKzBEGHoO4vb2N0litHqrgto4xQ8mgraA';

 