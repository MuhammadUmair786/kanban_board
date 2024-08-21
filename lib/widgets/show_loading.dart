import 'package:flutter/material.dart';
import 'package:kanban_board/constants/extras.dart';

showLoading() {
  showDialog(
    context: generalContext,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () {},
              child: const CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
      );
    },
  );
}

void dismissLoadingWidget() {
  Navigator.of(generalContext).pop();
}
