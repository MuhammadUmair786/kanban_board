import 'package:flutter/material.dart';
import 'package:kanban_board/views/backup_setting_screen.dart';
import 'package:kanban_board/views/locale_selection_screen.dart';
import 'package:kanban_board/views/theme_selection_screen.dart';
import 'package:kanban_board/widgets/fitted_text_widget.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            color: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const FittedText(
              "Kanban Board",
              boxFit: BoxFit.fitWidth,
              style: TextStyle(color: Colors.white),
            ),
          ),
          DrawerItemWidget(
            label: "Themes",
            onTap: () {
              showThemeSelectionDialog(context);
            },
          ),
          DrawerItemWidget(
            label: "Languages",
            onTap: () {
              showLocaleSelectionDialog(context);
            },
          ),
          DrawerItemWidget(
            label: "Backup",
            onTap: () {
              showBackupSettingDialog(context);
            },
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
          bottom: BorderSide(),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          visualDensity: const VisualDensity(vertical: 2),
          horizontalTitleGap: 5,
          dense: true,
          leading: Icon(
            leadingIcon,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
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
