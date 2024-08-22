import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../backup/backup_controller.dart';
import '../backup/config.dart';
import '../constants/extras.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_buttons.dart';
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

  Future<void> exportDataToCloud({required void Function()? onFinish}) async {
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
            showSnackBar('Data back up sucessfully');

            if (onFinish != null) {
              onFinish();
            }
          }).onError((e, x) {
            log(e.toString());
            log(x.toString());

            showSnackBar('Fail to backup data');
          });
        } else {
          showSnackBar('Unathorize');
        }
      },
    );
  }

  Future<void> importDataFromCloudImplementation() async {
    await canAccessDrive().then(
      (isAllow) async {
        if (isAllow) {
          await backUpController.googleDriveRepository
              .downloadBackUpFile()
              .then((String? importedDataString) async {
            if (importedDataString == null || importedDataString.isEmpty) {
              showSnackBar('No backup found');
            } else {
              Map<String, dynamic> importedJsonData =
                  jsonDecode(importedDataString);
              await initilizeDataFromBackupJSON(importedJsonData);
            }
          }).onError((e, x) {
            log(e.toString());
            log(x.toString());
            showSnackBar(
              'Fail to import data',
            );
          });
        } else {
          showSnackBar('Unathorize');
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String titleText = "Backup Setting";
    Widget desiredWidget = SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomElevatedButton(
                label: "Backup",
                onPressed: () {
                  exportDataToCloud(onFinish: () {});
                },
                icon: const Icon(Icons.file_upload_outlined),
                width: 150,
              ),
              CustomElevatedButton(
                label: "Download",
                onPressed: () {
                  importDataFromCloudImplementation();
                },
                icon: const Icon(Icons.download_outlined),
                width: 150,
              ),
            ],
          )
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
