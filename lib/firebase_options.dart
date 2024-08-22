// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTKUf7C_2jlfF4w_z3lDbgnE-avAj9Wlc',
    appId: '1:572976819324:web:79c273feaa6a89f81fadf9',
    messagingSenderId: '572976819324',
    projectId: 'kanban-44dfc',
    authDomain: 'kanban-44dfc.firebaseapp.com',
    storageBucket: 'kanban-44dfc.appspot.com',
    measurementId: 'G-888PTX52BC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALIN2rc2VEGZ_38ZB7-kMf8k2spW7ajko',
    appId: '1:572976819324:android:b534e09b7476bbfa1fadf9',
    messagingSenderId: '572976819324',
    projectId: 'kanban-44dfc',
    storageBucket: 'kanban-44dfc.appspot.com',
  );
}
