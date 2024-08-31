import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/cubits/theme/cubit.dart';
import 'package:localization/localization.dart';

import '../../../localization/localization.dart';
import '../../../widgets/fitted_text_widget.dart';
import '../constants/extras.dart';
import '../localization/local_keys.dart';
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
    String titleText = languageLK.i18n();

    Widget desiredWidget = Builder(builder: (context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            LocaleSettingWidget(
              key: UniqueKey(),
              title: 'English',
              locale: supportedLocales[0],
              onChange: () {
                setState(() {});
              },
            ),
            LocaleSettingWidget(
              key: UniqueKey(),
              title: 'Français',
              locale: supportedLocales[1],
              onChange: () {
                setState(() {});
              },
            ),
            LocaleSettingWidget(
              key: UniqueKey(),
              title: 'العربية',
              locale: supportedLocales[2],
              onChange: () {
                setState(() {});
              },
            ),
            LocaleSettingWidget(
              key: UniqueKey(),
              title: 'Deutsch',
              locale: supportedLocales[3],
              onChange: () {
                setState(() {});
              },
            ),
          ],
        ),
      );
    });

    if (isMobile) {
      return Scaffold(
        appBar: mobileAppbar(title: titleText),
        body: desiredWidget,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: dialogMaxWidth),
          child: Material(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Theme.of(context).scaffoldBackgroundColor,
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
    required this.onChange,
  });

  final String title;
  final Locale locale;
  final void Function() onChange;

  @override
  State<LocaleSettingWidget> createState() => _LocaleSettingWidgetState();
}

class _LocaleSettingWidgetState extends State<LocaleSettingWidget> {
  @override
  Widget build(BuildContext context) {
    bool isCurrent =
        context.read<ThemeLocaleCubit>().state.locale == widget.locale;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: isCurrent
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFF000000)),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: FittedText(
            widget.locale.countryCode ?? '--',
            style: TextStyle(
              color: isCurrent ? Theme.of(context).colorScheme.primary : null,
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
              color: isCurrent ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
        trailing: isCurrent
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          context
              .read<ThemeLocaleCubit>()
              .changeLocale(widget.locale.languageCode);

          widget.onChange();
        },
      ),
    );
  }
}
