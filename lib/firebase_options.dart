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
        return ios;
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
    apiKey: 'AIzaSyBsCQd2sINHcWkaNxbw5Qlr3DFN8BV7w9A',
    appId: '1:985283436222:web:317f622b589b27b1a488ef',
    messagingSenderId: '985283436222',
    projectId: 'innstagram-clone',
    authDomain: 'innstagram-clone.firebaseapp.com',
    storageBucket: 'innstagram-clone.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsB1R7BjiPc1lM_LifSOFNyMtlgExupdY',
    appId: '1:985283436222:android:1e1685a4f8fea916a488ef',
    messagingSenderId: '985283436222',
    projectId: 'innstagram-clone',
    storageBucket: 'innstagram-clone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdmjtJbR85bfx56hA7VJeX_AIrpgAMMrA',
    appId: '1:985283436222:ios:fe7a04a483982471a488ef',
    messagingSenderId: '985283436222',
    projectId: 'innstagram-clone',
    storageBucket: 'innstagram-clone.appspot.com',
    iosClientId: '985283436222-5sfogo098lk644au77hojo5i9e874ku5.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramClone',
  );
}
