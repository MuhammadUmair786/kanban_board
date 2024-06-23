import 'package:flutter/material.dart';
import 'package:kanban_board/constants/extras.dart';

const double mobileAppbarTitleFontSize = 16;
const FontWeight mobileAppbarTitleFontWeight = FontWeight.w500;
const double mobileAppBarHeight = 45;
const double mobileAppbarBackIconSize = 20;

AppBar mobileAppbar({
  required String title,
  bool isBackButton = true,
  List<Widget>? actionWidgetsList,
  double elevation = 5,
  Color baseColor = Colors.red,
  Color contentColor = Colors.white,
  void Function()? onBack,
  double height = 43,
}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: contentColor,
        fontSize: mobileAppbarTitleFontSize,
        fontWeight: mobileAppbarTitleFontWeight,
      ),
    ),
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     bottom: Radius.circular(20),
    //   ),
    // ),
    toolbarHeight: height,
    automaticallyImplyLeading: isBackButton,
    backgroundColor: baseColor,
    elevation: elevation,
    centerTitle: true,
    leading: isBackButton
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
            color: contentColor,
            padding: EdgeInsets.zero,
            splashRadius: 20,
            iconSize: mobileAppbarBackIconSize,
            onPressed: onBack ?? () => Navigator.of(generalContext).pop(),
          )
        : null,
    actions: actionWidgetsList,
  );
}
