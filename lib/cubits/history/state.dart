part of './cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<TaskModel> filteredTasks;

  HistoryLoaded(this.filteredTasks);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
