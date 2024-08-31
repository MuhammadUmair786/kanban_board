import 'package:flutter/material.dart';
import 'package:kanban_board/constants/extras.dart';

import '../widgets/custom_buttons.dart';

Future<dynamic> showConfirmationDialog({
  required String title,
  required String description,
  required void Function() onYes,
}) async {
  return showGeneralDialog(
    context: generalContext,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 350,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    // style: const TextStyle(
                    //   fontSize: 15,
                    //   fontWeight: FontWeight.w600,
                    //   decoration: TextDecoration.none,
                    // ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomOutlineButton(
                  label: 'Yes',
                  width: 120,
                  height: 25,
                  borderColor: Theme.of(context).colorScheme.primary,
                  onPressed: onYes,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: "showConfirmationDialog-$title",
  );
}
