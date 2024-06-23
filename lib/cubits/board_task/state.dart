import 'package:equatable/equatable.dart';

abstract class BoardTaskState extends Equatable {
  const BoardTaskState();

  @override
  List<Object?> get props => [];
}

class BoardTaskLoadInProgress extends BoardTaskState {}

class BoardTaskLoadSuccess extends BoardTaskState {
  // final List<BoardModel> boardList;
  // final List<TaskModel> taskList;

  // const BoardTaskLoadSuccess(this.boardList, this.taskList);

  // @override
  // List<Object?> get props => [boardList];
}

class BoardOperationFailure extends BoardTaskState {}
