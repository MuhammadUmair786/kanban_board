import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart';

import 'config.dart';
import 'json_converter.dart';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;

// import 'dart:io' as local_file;

/// Make ! folder and then save all other's in it
class GoogleApiClient extends IOClient {
  late final Map<String, String> _authHeaders;
  GoogleApiClient(this._authHeaders) : super();

  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) {
    return super.send(request..headers.addAll(_authHeaders));
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    return super.head(url,
        headers: headers ?? {}
          ..addAll(_authHeaders));
  }
}

class GoogleDriveRepository {
  http.Client? client;
  dynamic cloud;
  GoogleDriveRepository() : super();

  initGoogleDriveCloud(http.Client newClient) {
    client = newClient;
    cloud = DriveApi(client!);
  }

  Future<File?> isBackupExist() async {
    final driveFileList = await (cloud as DriveApi).files.list();

    if (driveFileList.files == null || driveFileList.files!.isEmpty) {
      log('no file found');
      return null;
    } else {
      log('Files List Length:: ${driveFileList.files?.length}');
      for (int i = 0; i < driveFileList.files!.length; i++) {
        log('$i-> mimeType: ${driveFileList.files![i].mimeType.toString()}\n name: ${driveFileList.files![i].name.toString()}\n id: ${driveFileList.files![i].id.toString()}\nparent: ${driveFileList.files![i].parents}\n..................\n\n\n\n');
      }
    }
    final isExist = driveFileList.files
        ?.firstWhere((element) => element.name == driveBackUpFileName);
    if (isExist == null) {
      return null;
    }
    return isExist;
  }

  Future<void> upload(String jsonString) async {
    final filePath = (await getApplicationDocumentsDirectory()).path;
    // 1. make your json data to json file
    final jsonFile = await JsonFile.stringToJsonFile(jsonString,
        dirPath: filePath, fileName: driveBackUpFileName);
    // 2. instanciate File(this is not from io, but from googleapis
    final fileToUpload = File();
    // 3. set file name for file to upload
    fileToUpload.name = driveBackUpFileName;
    // 4. check if the backup file is already exist
    final existFile = await isBackupExist();
    try {
      // 5. if exist, call update
      if (existFile != null) {
        await (cloud as DriveApi)
            .files
            .update(fileToUpload, existFile.id!,
                uploadMedia: Media(jsonFile.openRead(), jsonFile.lengthSync()))
            .then((value) {
          log('FILE updated: at ${value.createdTime}');
        });
      } else {
        String? folderId =
            await getOrCreateFolderId(driveBackUpParentFolderName);

        if (folderId == null) {
          throw Exception('No such folder found');
        }
        // // 6. if is not exist, set path for file and call create
        fileToUpload.parents = [folderId];

        await (cloud as DriveApi)
            .files
            .create(
              fileToUpload,
              uploadMedia: Media(jsonFile.openRead(), jsonFile.lengthSync()),
            )
            .then((File value) {
          log('File Uploaded-> name: ${value.name}, id: ${value.id}, parentFolderList:${value.parents}');
        });
      }
      if (kDebugMode) {
        print('cloud : uploaded');
      }
    } catch (e, x) {
      // 7. catch any error while uploading process
      log(e.toString());
      log(x.toString());
      throw Exception('failed to upload to google drive');
    }
  }

  Future<String?> getOrCreateFolderId(String folderName) async {
    try {
      // Check if the folder already exists
      final driveFileList = await (cloud as DriveApi).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and name='$folderName'",
          );

      if (driveFileList.files?.isNotEmpty == true) {
        // Return the existing folder ID
        return driveFileList.files!.first.id!;
      } else {
        // Folder doesn't exist, create it
        final folder = File()
          ..name = folderName
          ..mimeType = 'application/vnd.google-apps.folder';
        final createdFolder = await (cloud as DriveApi).files.create(folder);

        // Return the ID of the newly created folder
        return createdFolder.id!;
      }
    } catch (error) {
      log('Error creating/getting folder: $error');
      throw Exception('Failed to create/get folder on Google Drive');
    }
  }

  // Future<bool> deleteFileById(String fileId) async {
  //   return (cloud as DriveApi).files.delete(fileId).then((value) {
  //     return true;
  //   }).onError((error, stackTrace) {
  //     return false;
  //   });
  // }

  Future<bool> deleteBackUp() async {
    final driveFileList = await (cloud as DriveApi).files.list();
    File? backUpFile = driveFileList.files
        ?.firstWhere((element) => element.name == driveBackUpParentFolderName);

    if (backUpFile == null || backUpFile.id == null) {
      log('$driveBackUpParentFolderName not found - deleteBackUp()');
      return true;
    } else {
      return (cloud as DriveApi).files.delete(backUpFile.id!).then((_) {
        return true;
      }).onError((e, x) {
        log(e.toString());
        log(x.toString());
        return false;
      });
    }
  }

  Future<String?> downloadBackUpFile({String? path}) async {
    // 1. check backup before download
    final existFile = await isBackupExist();
    if (existFile == null) {
      return null;
    }
    // 2. get drive file
    final Media driveFile = await (cloud as DriveApi).files.get(existFile.id!,
        downloadOptions: DownloadOptions.fullMedia) as Media;
    // 3. read stream from Google Drive to json string
    // In there, I used JsonFile(I didn't mentioned in there)
    // You can use any json package you want to use

    final jsonFileString = await JsonFile.streamToJson(driveFile.stream,
        fileName: driveBackUpFileName);
    return jsonFileString;
  }
}
