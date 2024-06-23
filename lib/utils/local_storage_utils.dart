import 'package:get_storage/get_storage.dart';
import 'package:kanban_board/utils/board_utils.dart';
import 'package:kanban_board/utils/task_utils.dart';

/// Initilize all GetStorage Container
Future<dynamic> initilizeGetStorageContainer() async {
  // TODO: Initilize all GetStorage Container

  await Future.wait([
    GetStorage.init(),
    GetStorage.init(boardContainerKey),
    GetStorage.init(taskContainerKey),
  ]);
}

/// Clear all GetStorage Container
Future<dynamic> clearGetStorageContainer() async {
  // TODO: Clear all GetStorage Container

  return await Future.wait([
    GetStorage().erase(),
    GetStorage(boardContainerKey).erase(),
    GetStorage(taskContainerKey).erase(),
  ]);
}
