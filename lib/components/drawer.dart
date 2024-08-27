import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/localization/local_keys.dart';
import 'package:kanban_board/views/backup_setting_screen.dart';
import 'package:kanban_board/views/locale_selection_screen.dart';
import 'package:kanban_board/views/theme_selection_screen.dart';
import 'package:kanban_board/widgets/fitted_text_widget.dart';
import 'package:kanban_board/widgets/snakbar.dart';
import 'package:localization/localization.dart';

import '../constants/assets.dart';
import '../views/scheduled_reminder_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Expanded(child: Image.asset(logoTransparentPath)),
                const SizedBox(height: 5),
                const FittedText(
                  "Kanban Board",
                  boxFit: BoxFit.fitWidth,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DrawerItemWidget(
            label: appearanceLK.i18n(),
            onTap: () {
              showThemeSelectionDialog(context);
            },
            leadingIcon: Icons.color_lens_outlined,
          ),
          DrawerItemWidget(
            label: languageLK.i18n(),
            onTap: () {
              showLocaleSelectionDialog(context);
            },
            leadingIcon: Icons.language_outlined,
          ),
          DrawerItemWidget(
            label: cloudBackupLK.i18n(),
            onTap: () {
              if (kIsWeb) {
                showSnackBar(featureNotAvailableWebLK.i18n(), isError: true);
              } else {
                showBackupSettingDialog(context);
              }
            },
            leadingIcon: Icons.backup_outlined,
          ),
          DrawerItemWidget(
            label: upcomingTasksLK.i18n(),
            onTap: () {
              if (kIsWeb) {
                showSnackBar(featureNotAvailableWebLK.i18n(), isError: true);
              } else {
                showScheduledReminderDialog(context);
              }
            },
            leadingIcon: Icons.notification_add_outlined,
          ),
        ],
      ),
    );
  }
}

///Both leadingLogoPath, leadingIcon should'nt be null
class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.leadingIcon,
    this.shouldBack = true,
  });

  final String label;
  final Function() onTap;

  final IconData? leadingIcon;

  final bool shouldBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          visualDensity: const VisualDensity(vertical: 2),
          horizontalTitleGap: 5,
          dense: true,
          leading: Icon(
            leadingIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Directionality.of(context) == TextDirection.ltr
                ? Alignment.topLeft
                : Alignment.topRight,
            child: Text(
              label,
            ),
          ),
          onTap: () {
            if (shouldBack) {
              Navigator.of(context).pop();
            }
            onTap();
          },
        ),
      ),
    );
  }
}
