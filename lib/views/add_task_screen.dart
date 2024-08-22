import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/cubits/board_task/cubit.dart';

import '../constants/extras.dart';
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
  }

  bool isUpdate = false;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String titleString = "${isUpdate ? "Update" : "Create"} Task";

    Widget actionButtonWidget = CustomElevatedButton(
      label: isUpdate ? 'Update' : 'Create Event',
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
                showSnackBar("Task update sucessfully");
              },
            );
          } else {
            await addTask(widget.boardId, titleController.text.trim(),
                    descriptionController.text.trim())
                .then(
              (value) {
                Navigator.of(context).pop();
                context.read<BoardTaskCubit>().addTask(value);
                showSnackBar("Task added sucessfully");
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
