import 'google_auth.dart';
import 'google_drive_repository.dart';

BackUpController backUpController = BackUpController();

Future<bool> canAccessDrive() async {
  if (backUpController.authStatus) {
    return true;
  }
  return backUpController.initilizeGoogleAuthRepository().then(
    (value) {
      return backUpController.authStatus;
    },
  );
}

class BackUpController {
  late GoogleAuth googleAuth;
  late GoogleDriveRepository googleDriveRepository;

  bool authStatus = false;

  Future<void> initilizeGoogleAuthRepository() async {
    authStatus = false;
    googleAuth = GoogleAuth();
    await googleAuth.login().then(
      (value) {
        googleDriveRepository = GoogleDriveRepository();
        googleDriveRepository.initGoogleDriveCloud(googleAuth.client!);
        authStatus = true;
      },
    );
  }
}
