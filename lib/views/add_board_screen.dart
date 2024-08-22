import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/extras.dart';
import '../cubits/board_task/cubit.dart';
import '../models/board_model.dart';
import '../utils/board_utils.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_text_feilds.dart';
import '../widgets/snakbar.dart';

void showAddBoardDialog(BuildContext context, {BoardModel? boardModel}) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddBoardDialog(
          boardModel: boardModel,
        ),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddBoardDialog(
          boardModel: boardModel,
        );
      },
      barrierLabel: 'showAddBoardDialog',
      barrierDismissible: false,
    );
  }
}

class AddBoardDialog extends StatefulWidget {
  const AddBoardDialog({
    super.key,
    required this.boardModel,
  });

  final BoardModel? boardModel;

  @override
  State<AddBoardDialog> createState() => _AddBoardDialogState();
}

class _AddBoardDialogState extends State<AddBoardDialog> {
  @override
  void initState() {
    super.initState();

    isUpdate = widget.boardModel != null;
    titleController = TextEditingController(text: widget.boardModel?.name);
  }

  bool isUpdate = false;
  late TextEditingController titleController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String titleString = "${isUpdate ? "Update" : "Create"} Board";

    Future<void> handleSubmit() async {
      FocusScope.of(context).unfocus();

      if (formKey.currentState!.validate()) {
        if (isUpdate) {
          await updateBoard(
            widget.boardModel!,
            titleController.text.trim(),
          ).then(
            (updatedBoardModel) {
              context.read<BoardTaskCubit>().updateBoard(updatedBoardModel);
              Navigator.of(context).pop();
              showSnackBar("Board Details update");
            },
          );
        } else {
          await addBoard(titleController.text.trim()).then(
            (value) {
              context.read<BoardTaskCubit>().addBoard(value);
              Navigator.of(context).pop();
              showSnackBar("Board added sucessfully");
            },
          );
        }
      }
    }

    Widget actionButtonWidget = CustomElevatedButton(
      label: isUpdate ? 'Update' : 'Create Board',
      icon: isUpdate ? const Icon(Icons.update) : const Icon(Icons.add),
      onPressed: () {
        handleSubmit();
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
              textInputAction: TextInputAction.done,
              autofocus: true,
              onActionComplete: (p0) {
                handleSubmit();
              },
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
