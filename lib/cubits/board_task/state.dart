part of 'cubit.dart';

abstract class BoardTaskState {
  const BoardTaskState();
}

class BoardTaskLoadInProgress extends BoardTaskState {}

class BoardTaskLoadSuccess extends BoardTaskState {}

class BoardOperationFailure extends BoardTaskState {
  final String message;

  const BoardOperationFailure(this.message);
}
