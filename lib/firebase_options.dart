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
        return macos;
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
    apiKey: 'AIzaSyB31EHrFhucsNki0rdQlzvc2yex0DTxw3w',
    appId: '1:393782419443:web:2a02a7d03ddcb3b31c7c86',
    messagingSenderId: '393782419443',
    projectId: 'chat-app-2-2b202',
    authDomain: 'chat-app-2-2b202.firebaseapp.com',
    storageBucket: 'chat-app-2-2b202.appspot.com',
    measurementId: 'G-SHVXHCG7XJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByCZsJ_gmQD7imJ8BdBSnDh6Su01tGNR8',
    appId: '1:393782419443:android:d1973855eebfde2f1c7c86',
    messagingSenderId: '393782419443',
    projectId: 'chat-app-2-2b202',
    storageBucket: 'chat-app-2-2b202.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCi_zIyKSd5iVfJ-PFubGeS1S6I1JAM2mk',
    appId: '1:393782419443:ios:ae330f5ba5e1e9111c7c86',
    messagingSenderId: '393782419443',
    projectId: 'chat-app-2-2b202',
    storageBucket: 'chat-app-2-2b202.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCi_zIyKSd5iVfJ-PFubGeS1S6I1JAM2mk',
    appId: '1:393782419443:ios:8349f683e280a87d1c7c86',
    messagingSenderId: '393782419443',
    projectId: 'chat-app-2-2b202',
    storageBucket: 'chat-app-2-2b202.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
