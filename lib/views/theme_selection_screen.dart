import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/cubits/theme/cubit.dart';

import '../constants/extras.dart';
import '../constants/theme.dart';
import '../widgets/app_bar.dart';

void showThemeSelectionDialog(BuildContext context) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HistoryWidget(),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const HistoryWidget();
      },
      barrierLabel: 'showThemeSelectionDialog',
      barrierDismissible: true,
    );
  }
}

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({
    super.key,
  });

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  TextEditingController searchController = TextEditingController();
  String? filterdBoard;
  @override
  Widget build(BuildContext context) {
    String titleText = "Configure Themes";

    Widget buildColorPreview(Color color) {
      return Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    }

    Widget desiredWidget = ListView.builder(
      itemCount: availbleThemes.length,
      itemBuilder: (context, index) {
        // Get the theme name and data
        String themeName = availbleThemes.keys.elementAt(index);
        ThemeData themeData = availbleThemes.values.elementAt(index);

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              themeName,
              style: themeData.textTheme.titleLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Primary Color Preview:",
                  style: themeData.textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                buildColorPreview(themeData.colorScheme.primary),
                const SizedBox(height: 10),
                Text(
                  "Text Example:",
                  style: themeData.textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  "This is a sample text.",
                  style: themeData.textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Button Example:",
                  style: themeData.textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    context.read<ThemeLocaleCubit>().changeTheme(themeName);
                  },
                  style: themeData.elevatedButtonTheme.style,
                  child: const Text('Click Me'),
                ),
              ],
            ),
            onTap: () {
              // Apply the selected theme
              // You can handle theme change logic here
            },
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
