import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../backup/backup_controller.dart';
import '../backup/config.dart';
import '../constants/extras.dart';
import '../localization/local_keys.dart';
import '../widgets/app_bar.dart';
import '../widgets/show_loading.dart';
import '../widgets/snakbar.dart';

void showBackupSettingDialog(BuildContext context) {
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const BackupSettingWidget(),
      ),
    );
  } else {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const BackupSettingWidget();
      },
      barrierLabel: 'showBackupSettingDialog',
      barrierDismissible: true,
    );
  }
}

class BackupSettingWidget extends StatefulWidget {
  const BackupSettingWidget({
    super.key,
  });

  @override
  State<BackupSettingWidget> createState() => _BackupSettingWidgetState();
}

class _BackupSettingWidgetState extends State<BackupSettingWidget> {
  TextEditingController searchController = TextEditingController();
  String? filterdBoard;

  Future<void> exportDataToCloud() async {
    showLoading();
    await canAccessDrive().then(
      (isAllow) async {
        if (isAllow) {
          await backUpController.googleDriveRepository
              .upload(
            jsonEncode(
              getLocalDataConvertedIntoBackUpStandard(),
            ),
          )
              .then((_) async {
            dismissLoadingWidget();
            showSnackBar('Data back up sucessfully');
          }).onError((e, x) {
            log(e.toString());
            log(x.toString());

            showSnackBar('Fail to backup data');
          });
        } else {
          dismissLoadingWidget();
          showSnackBar('Unathorize');
        }
      },
    );
  }

  Future<void> importDataFromCloudImplementation() async {
    showLoading();
    await canAccessDrive().then(
      (isAllow) async {
        if (isAllow) {
          await backUpController.googleDriveRepository
              .downloadBackUpFile()
              .then((String? importedDataString) async {
            dismissLoadingWidget();
            if (importedDataString == null || importedDataString.isEmpty) {
              showSnackBar('No backup found');
            } else {
              Map<String, dynamic> importedJsonData =
                  jsonDecode(importedDataString);
              await initilizeDataFromBackupJSON(importedJsonData);
            }
          }).onError((e, x) {
            dismissLoadingWidget();
            log(e.toString());
            log(x.toString());
            showSnackBar(
              'Fail to import data',
            );
          });
        } else {
          dismissLoadingWidget();
          showSnackBar('Unathorize');
        }
      },
    );
  }

  Future<void> deletBackup() async {
    showLoading();
    await canAccessDrive().then((isAllow) async {
      if (isAllow) {
        await backUpController.googleDriveRepository.deleteBackUp().then(
          (isDelete) {
            dismissLoadingWidget();
            if (isDelete) {
              showSnackBar('Back up deleted sucessfuly');
            } else {
              showSnackBar('Fail to delete back up', isError: true);
            }
          },
        );
      } else {
        dismissLoadingWidget();
        showSnackBar('Unathorize');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleText = cloudBackupLK.i18n();
    Widget desiredWidget = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          BackupSettingCard(
            icon: Icons.file_upload_outlined,
            title: uploadBackupLK.i18n(),
            subtitle: savesDataToCloudLK.i18n(),
            onTap: () {
              exportDataToCloud();
            },
          ),
          BackupSettingCard(
            icon: Icons.download_outlined,
            title: restoreBackupLK.i18n(),
            subtitle: retrievesDataFromCloudLK.i18n(),
            onTap: () {
              importDataFromCloudImplementation();
            },
          ),
          BackupSettingCard(
            icon: Icons.backspace_outlined,
            title: deleteBackupLK.i18n(),
            subtitle: deleteBackupWarningLK.i18n(),
            onTap: () {
              deletBackup();
            },
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

class BackupSettingCard extends StatelessWidget {
  const BackupSettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 35,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(subtitle),
          onTap: onTap,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
