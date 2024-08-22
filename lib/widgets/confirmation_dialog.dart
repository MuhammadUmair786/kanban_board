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
          ),
          margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
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
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                label: 'Yes',
                width: 70,
                height: 30,
                onPressed: onYes,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: "showConfirmationDialog-$title",
  );
}