import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/formate_duration.dart';
import '../../models/task_model.dart';
import '../../utils/time_span_utils.dart';
import '../task/cubit.dart';

part 'state.dart';

class TaskTimerCubit extends Cubit<TaskTimerState> {
  late TaskModel taskModel;
  Timer? timer;

  TaskTimerCubit(this.taskModel)
      : super(TimerLoadSuccess(formatDuration(taskModel.getExistingDuration)));

  void updateTaskModel(TaskModel updatedTaskModel) {
    taskModel = updatedTaskModel;
  }

  void defaultDuration() {
    emit(
      TimerUpdateSuccess(
        formatDuration(taskModel.getExistingDuration),
      ),
    );
  }

  Future<void> startTimer(BuildContext context) async {
    if (taskModel.isAnyPendingTimespan) {
      // do nothing
    } else {
      await addTimeSpan(taskModel).then(
        (value) async {
          updateTaskModel(value);
          manageTimer();

          context.read<TaskCubit>().updateTask(value);
        },
      );
    }
  }

  Future<void> stopTimer(BuildContext context) async {
    if (taskModel.isAnyPendingTimespan) {
      await endTimeSpan(taskModel).then(
        (value) {
          updateTaskModel(value);
          context.read<TaskCubit>().updateTask(value);

          try {
            timer?.cancel();
          } catch (_) {}
          emit(
            TimerUpdateSuccess(
              formatDuration(taskModel.getExistingDuration),
            ),
          );
        },
      );
    } else {
      // do nothing
    }
  }

  void manageTimer() {
    TimespanModel? pendingTimeSpan;

    int index = taskModel.timespanList
        .lastIndexWhere((element) => element.endTime == null);

    if (index == -1) {
      pendingTimeSpan = null;
    } else {
      pendingTimeSpan = taskModel.timespanList[index];
    }

    if (pendingTimeSpan == null) {
      defaultDuration();
    } else {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          final ongoingDuration =
              DateTime.now().difference(pendingTimeSpan!.startTime);
          final totalDuration = taskModel.getExistingDuration + ongoingDuration;
          emit(
            TimerUpdateSuccess(
              formatDuration(totalDuration),
            ),
          );
        },
      );
    }
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
