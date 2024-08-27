part of 'cubit.dart';

abstract class TaskTimerState {}

class TimerLoadSuccess extends TaskTimerState {
  final String durationString;

  TimerLoadSuccess(this.durationString);
}

class TimerUpdateSuccess extends TaskTimerState {
  final String durationString;

  TimerUpdateSuccess(this.durationString);
}
