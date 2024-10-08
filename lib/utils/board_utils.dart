import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import '../models/board_model.dart';
import '../helpers/time_based_id.dart';

String boardContainerKey = 'BoardContainer';

Future<BoardModel> addBoard(String name) async {
  String id = getTimeBasedId();
  BoardModel tempBoard = BoardModel(
    id: id,
    name: name,
    createdAt: DateTime.now(),
  );
  await GetStorage(boardContainerKey).write(id, tempBoard.toJson());

  return tempBoard;
}

Future<void> addBoardInBulk(List<dynamic> jsonList) async {
  List<Future<dynamic>> futureList = jsonList
      .map(
        (json) => GetStorage(boardContainerKey).write(json['id'], json),
      )
      .toList();
  await Future.wait(futureList);
}

BoardModel getBoardById(String id) {
  try {
    return BoardModel.fromJson(GetStorage(boardContainerKey).read(id));
  } catch (_) {
    // log(e.toString());
    // log(x.toString());
    return BoardModel(
        id: getTimeBasedId(), name: 'Unknown', createdAt: DateTime(100));
  }
}

List<BoardModel> getBoards() {
  try {
    Iterable<dynamic> tempList = GetStorage(boardContainerKey).getValues();
    log('getBoard()-> length ${tempList.length}');

    return tempList.map((e) => BoardModel.fromJson(e)).toList();
  } catch (e, x) {
    log(e.toString());
    log(x.toString());
    return [];
  }
}

Future<void> removeBoard(BoardModel board) async {
  await GetStorage(boardContainerKey).remove(board.id);
}

Future<BoardModel> updateBoard(BoardModel board, String updatedName) async {
  BoardModel tempBoard =
      BoardModel(id: board.id, name: updatedName, createdAt: board.createdAt);
  await GetStorage(boardContainerKey).write(board.id, tempBoard.toJson());
  return tempBoard;
}
