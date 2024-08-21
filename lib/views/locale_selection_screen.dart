import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/cubits/theme/cubit.dart';
import 'package:kanban_board/utils/theme_utils.dart';

import '../../../localization/localization.dart';
import '../../../widgets/fitted_text_widget.dart';
import '../constants/extras.dart';
import '../widgets/app_bar.dart';

void showLocaleSelectionDialog(BuildContext context) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LocaleWidget(),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LocaleWidget();
      },
      barrierLabel: 'showThemeSelectionDialog',
      barrierDismissible: true,
    );
  }
}

class LocaleWidget extends StatefulWidget {
  const LocaleWidget({
    super.key,
  });

  @override
  State<LocaleWidget> createState() => _LocaleWidgetState();
}

class _LocaleWidgetState extends State<LocaleWidget> {
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

    Widget desiredWidget = SingleChildScrollView(
      child: Column(
        children: [
          LocaleSettingWidget(
            title: 'English',
            locale: supportedLocales.first,
          ),
          LocaleSettingWidget(
            title: 'Français',
            locale: supportedLocales.last,
          ),
        ],
      ),
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

class LocaleSettingWidget extends StatefulWidget {
  const LocaleSettingWidget({
    super.key,
    required this.title,
    required this.locale,
  });

  final String title;
  final Locale locale;

  @override
  State<LocaleSettingWidget> createState() => _LocaleSettingWidgetState();
}

class _LocaleSettingWidgetState extends State<LocaleSettingWidget> {
  @override
  Widget build(BuildContext context) {
    bool isCurrent = getSavedLocale() == widget.locale;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.white,
        child: ListTile(
          // contentPadding: EdgeInsets.zero,
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: isCurrent ? Colors.green : const Color(0xFF000000)),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            child: FittedText(
              widget.locale.countryCode ?? '--',
              style: TextStyle(
                color: isCurrent ? Colors.green : null,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Text(
              widget.title,
              style: TextStyle(
                color: isCurrent ? Colors.green : null,
              ),
            ),
          ),
          trailing: isCurrent
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : null,
          onTap: () {
            context
                .read<ThemeLocaleCubit>()
                .changeLocale(widget.locale.languageCode);
          },
        ),
      ),
    );
  }
}
