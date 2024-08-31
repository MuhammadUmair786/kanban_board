import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import 'package:localization/localization.dart';

import '../components/task_timespan_dialog.dart';
import '../constants/extras.dart';
import '../constants/theme.dart';
import '../cubits/task/cubit.dart';
import '../cubits/task_timer/cubit.dart';
import '../localization/local_keys.dart';
import '../models/task_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_text_feilds.dart';
import 'add_task_screen.dart';

void showTaskDetailDialog(BuildContext context, TaskModel taskModel) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TaskDetailWidget(
          inputTask: taskModel,
        ),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return TaskDetailWidget(
          inputTask: taskModel,
        );
      },
      barrierLabel: 'showTaskDetailDialog',
      barrierDismissible: true,
    );
  }
}

class TaskDetailWidget extends StatelessWidget {
  final TaskModel inputTask;
  const TaskDetailWidget({super.key, required this.inputTask});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(inputTask),
        ),
        BlocProvider<TaskTimerCubit>(
          create: (context) => TaskTimerCubit(inputTask),
        ),
      ],
      child: Builder(
        builder: (context) {
          String titleText = context.read<TaskCubit>().taskModel.title;

          TaskCubit taskCubit = context.read<TaskCubit>();
          TaskTimerCubit timerCubit = context.read<TaskTimerCubit>();

          Widget desiredWidget = BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskUpdate) {
                timerCubit.updateTaskModel(state.taskModel);
              }
            },
            builder: (context, state) {
              if (state is TaskLoadSuccess || state is TaskUpdate) {
                TaskModel taskModel = (state is TaskLoadSuccess)
                    ? state.taskModel
                    : (state as TaskUpdate).taskModel;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskModel.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 20),
                      ),
                      Text(
                        taskModel.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      if (taskModel.isScheduled) ...[
                        Material(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alarmScheduledAtLK.i18n(),
                                        style: const TextStyle(
                                          fontSize: fontSizeSmall,
                                        ),
                                      ),
                                      Text(
                                        Jiffy.parseFromDateTime(
                                                taskModel.scheduleAt!)
                                            .yMMMEdjm,
                                        style: const TextStyle(
                                          fontSize: fontSizeLarge,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  onPressed: () async {
                                    taskCubit.dismissReminder();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      BlocBuilder<TaskTimerCubit, TaskTimerState>(
                        builder: (context, timerState) {
                          String durationString = timerState is TimerLoadSuccess
                              ? timerState.durationString
                              : (timerState as TimerUpdateSuccess)
                                  .durationString;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  timerCubit.startTimer(context);
                                },
                                icon: const Icon(
                                  Icons.play_arrow,
                                  size: 35,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    durationString,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  timerCubit.stopTimer(context);
                                },
                                icon: const Icon(
                                  Icons.pause,
                                  size: 35,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      CustomTextFormFieldWithLabel(
                        labelText: "Comment",
                        hintText: "Add new comment...",
                        controller: TextEditingController(),
                        textInputAction: TextInputAction.done,
                        minLines: 3,
                        maxlines: 5,
                        onActionComplete: (value) async {
                          if (value.isEmpty) {
                            return;
                          }
                          taskCubit.addComment(value.trim());
                        },
                      ),
                      const SizedBox(height: 20),
                      ...taskModel.getCommentSortedList.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Stack(
                            children: [
                              Material(
                                key: ValueKey(e.id),
                                borderRadius: BorderRadius.circular(10),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.comment,
                                        textScaler:
                                            const TextScaler.linear(1.2),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Divider(
                                          height: 5,
                                          color: Colors.grey[200],
                                          thickness: 0.1,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          Jiffy.parseFromDateTime(e.createdAt)
                                              .yMMMdjm,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: IconButton(
                                    onPressed: () async {
                                      await showConfirmationDialog(
                                        title: deleteCommentLK.i18n(),
                                        description: confirmDeleteLK.i18n(),
                                        onYes: () async {
                                          Navigator.of(context).pop();
                                          taskCubit.deleteComment(e.id);
                                        },
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    iconSize: 20,
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator.adaptive();
              }
            },
          );
          Widget deleteTaskButton = SizedBox(
            width: 25,
            height: 25,
            child: IconButton(
              onPressed: () async {
                taskCubit.deleteTask().then(
                  (value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
              icon: const Icon(Icons.delete_forever),
              padding: EdgeInsets.zero,
              splashRadius: 15,
            ),
          );
          Widget editTaskButton = SizedBox(
            width: 25,
            height: 25,
            child: IconButton(
              onPressed: () async {
                TaskModel taskModel = taskCubit.taskModel;
                showAddTaskDialog(context, taskModel.boardId,
                    taskModel: taskModel);
              },
              icon: const Icon(Icons.edit),
              padding: EdgeInsets.zero,
              splashRadius: 15,
            ),
          );
          Widget timeSpanButton = BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoadSuccess || state is TaskUpdate) {
                TaskModel taskModel = (state is TaskLoadSuccess)
                    ? state.taskModel
                    : (state as TaskUpdate).taskModel;

                if (taskModel.timespanList.isEmpty) {
                  return const SizedBox();
                }
                return SizedBox(
                  width: 25,
                  height: 25,
                  child: IconButton(
                    onPressed: () async {
                      showTaskTimeSpanDialog(taskModel);
                    },
                    tooltip: "Show Time Span",
                    icon: const Icon(
                      Icons.timeline,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 15,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          );
          if (isMobile) {
            return Scaffold(
              appBar: mobileAppbar(
                title: titleText,
                actionWidgetsList: [
                  editTaskButton,
                  const SizedBox(width: 10),
                  deleteTaskButton,
                  const SizedBox(width: 10),
                  timeSpanButton,
                  const SizedBox(width: 10),
                ],
              ),
              body: desiredWidget,
            );
          } else {
            return Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: dialogMaxWidth),
                child: Material(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                titleText,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                editTaskButton,
                                const SizedBox(width: 10),
                                deleteTaskButton,
                                const SizedBox(width: 10),
                                timeSpanButton,
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close),
                                    color: Colors.red,
                                    padding: EdgeInsets.zero,
                                    splashRadius: 15,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: double.infinity, child: desiredWidget),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
