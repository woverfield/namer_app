// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC_byWfeoSSI-E1BokdGho0a3Wd6d6RTn4',
    appId: '1:207313310581:web:65d5e515594371b274b93c',
    messagingSenderId: '207313310581',
    projectId: 'namer-app-cded9',
    authDomain: 'namer-app-cded9.firebaseapp.com',
    storageBucket: 'namer-app-cded9.appspot.com',
    measurementId: 'G-C3HR6H5YXR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBC0qOpMPk7L0QM9yX9EG_fZA0nQFtTXmc',
    appId: '1:207313310581:android:7ba7bc7eb129a4c074b93c',
    messagingSenderId: '207313310581',
    projectId: 'namer-app-cded9',
    storageBucket: 'namer-app-cded9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDv5rgHfSevrkNxP6AY8mP123a2z4cUYrk',
    appId: '1:207313310581:ios:0367911eda23057174b93c',
    messagingSenderId: '207313310581',
    projectId: 'namer-app-cded9',
    storageBucket: 'namer-app-cded9.appspot.com',
    iosBundleId: 'com.example.namerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDv5rgHfSevrkNxP6AY8mP123a2z4cUYrk',
    appId: '1:207313310581:ios:0367911eda23057174b93c',
    messagingSenderId: '207313310581',
    projectId: 'namer-app-cded9',
    storageBucket: 'namer-app-cded9.appspot.com',
    iosBundleId: 'com.example.namerApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_byWfeoSSI-E1BokdGho0a3Wd6d6RTn4',
    appId: '1:207313310581:web:7e1521684162304d74b93c',
    messagingSenderId: '207313310581',
    projectId: 'namer-app-cded9',
    authDomain: 'namer-app-cded9.firebaseapp.com',
    storageBucket: 'namer-app-cded9.appspot.com',
    measurementId: 'G-T7ZMJTXF26',
  );

}