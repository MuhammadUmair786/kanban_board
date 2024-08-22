import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/cubits/theme/cubit.dart';
import 'package:kanban_board/localization/local_keys.dart';
import 'package:localization/localization.dart';

import '../constants/extras.dart';
import '../constants/theme.dart';
import '../widgets/app_bar.dart';

void showThemeSelectionDialog(BuildContext context) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const ThemeWidget(),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ThemeWidget();
      },
      barrierLabel: 'showThemeSelectionDialog',
      barrierDismissible: true,
    );
  }
}

class ThemeWidget extends StatefulWidget {
  const ThemeWidget({
    super.key,
  });

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  TextEditingController searchController = TextEditingController();
  String? filterdBoard;
  @override
  Widget build(BuildContext context) {
    String titleText = appearanceLK.i18n();

    Widget desiredWidget = ListView.builder(
      itemCount: availbleThemes.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        // Get the theme name and data
        String themeName = availbleThemes.keys.elementAt(index);
        ThemeData themeData = availbleThemes.values.elementAt(index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            elevation: 6,
            color: themeData.colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: themeData.colorScheme.primary,
                width: 5,
              ),
            ),
            child: InkWell(
              onTap: () {
                context.read<ThemeLocaleCubit>().changeTheme(themeName);
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  themeName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (isMobile) {
      return Scaffold(
        appBar: mobileAppbar(title: titleText),
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
                      Text(
                        titleText,
                      ),
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
  }
}
