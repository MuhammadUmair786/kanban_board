import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board/cubits/board_task/cubit.dart';
import 'package:localization/localization.dart';

import '../constants/extras.dart';
import '../helpers/date_time_input.dart';
import '../localization/local_keys.dart';
import '../models/task_model.dart';
import '../utils/task_utils.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_text_feilds.dart';
import '../widgets/snakbar.dart';

void showAddTaskDialog(
  BuildContext context,
  String boardId, {
  TaskModel? taskModel,
}) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddTaskDialog(
          boardId: boardId,
          taskModel: taskModel,
        ),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddTaskDialog(
          boardId: boardId,
          taskModel: taskModel,
        );
      },
      barrierLabel: 'showAddTaskDialog',
      barrierDismissible: false,
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({
    super.key,
    required this.boardId,
    required this.taskModel,
  });
  final String boardId;
  final TaskModel? taskModel;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  @override
  void initState() {
    super.initState();

    isUpdate = widget.taskModel != null;
    titleController = TextEditingController(text: widget.taskModel?.title);

    descriptionController =
        TextEditingController(text: widget.taskModel?.description);

    reminderController = TextEditingController(
        text: widget.taskModel == null
            ? ""
            : widget.taskModel!.isScheduled
                ? getFormatedDate(widget.taskModel!.scheduleAt!)
                : "");
    reminderDate = widget.taskModel?.scheduleAt;
  }

  String getFormatedDate(DateTime dateTime) {
    return Jiffy.parseFromDateTime(dateTime).yMMMEdjm;
  }

  bool isUpdate = false;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController reminderController;
  DateTime? reminderDate;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // "${isUpdate ? "Update" : "Create"} Task"
    String titleString = isUpdate ? updateLK.i18n() : addTaskLK.i18n();

    Widget actionButtonWidget = CustomElevatedButton(
      label: isUpdate ? updateLK.i18n() : addTaskLK.i18n(),
      icon: isUpdate ? const Icon(Icons.update) : const Icon(Icons.add),
      onPressed: () async {
        FocusScope.of(context).unfocus();

        if (formKey.currentState!.validate()) {
          if (isUpdate) {
            await updateTask(
              widget.taskModel!,
              title: titleController.text.trim(),
              description: descriptionController.text.trim(),
            ).then(
              (value) {
                Navigator.of(context).pop();
                context.read<BoardTaskCubit>().updateTask(value);
                showSnackBar(taskUpdatedSuccessfullyLK.i18n());
              },
            );
          } else {
            await addTask(
              widget.boardId,
              titleController.text.trim(),
              descriptionController.text.trim(),
              reminderDate,
            ).then(
              (value) {
                Navigator.of(context).pop();
                context.read<BoardTaskCubit>().addTask(value);
                showSnackBar(taskAddedSuccessfullyLK.i18n());
              },
            );
          }
        }
      },
      width: 200,
    );

    Widget desiredWidget = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormFieldWithLabel(
              labelText: 'Title',
              hintText: 'Enter title',
              controller: titleController,
              autofocus: true,
            ),
            CustomTextFormFieldWithLabel(
              labelText: 'Notes',
              hintText: 'Enter any relevent details',
              controller: descriptionController,
              minLines: 5,
              maxlines: 10,
              textInputAction: TextInputAction.newline,
            ),
            InkWell(
              onTap: () async {
                await getDateTimeInput(DateTime.now(),
                        DateTime.now().add(const Duration(days: 60)))
                    .then(
                  (DateTime? value) {
                    if (value != null) {
                      if (value.isBefore(DateTime.now())) {
                        showSnackBar(
                            "Reminders cannot be set for past dates. Please select a future date.");
                      } else {
                        reminderController.text = getFormatedDate(value);
                        reminderDate = value;
                      }
                    }
                  },
                );
              },
              child: AbsorbPointer(
                child: CustomTextFormFieldWithLabel(
                  labelText: "Alarm Date",
                  hintText: "Set reminder date",
                  controller: reminderController,
                  validator: (_) {
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (!isMobile) actionButtonWidget,
          ],
        ),
      ),
    );

    if (isMobile) {
      return Scaffold(
        appBar: mobileAppbar(title: titleString),
        body: desiredWidget,
        bottomSheet: Container(
          height: 70,
          alignment: Alignment.center,
          child: actionButtonWidget,
        ),
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
                      Text(
                        titleString,
                      ),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                          splashRadius: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                desiredWidget,
              ],
            ),
          ),
        ),
      );
    }
  }
}
