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
    apiKey: 'AIzaSyD0b22Tp1mmFHHfIHcHI6lf-T4c6azyTm8',
    appId: '1:432310880033:web:71813dfa766730ad082060',
    messagingSenderId: '432310880033',
    projectId: 'liquor-lens',
    authDomain: 'liquor-lens.firebaseapp.com',
    databaseURL: 'https://liquor-lens-default-rtdb.firebaseio.com',
    storageBucket: 'liquor-lens.appspot.com',
    measurementId: 'G-TTFHSVEHBL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAP4M3ysotzuNV-vlNnE3gs2qmCBCVlmPw',
    appId: '1:432310880033:android:92463902f92ed3d1082060',
    messagingSenderId: '432310880033',
    projectId: 'liquor-lens',
    databaseURL: 'https://liquor-lens-default-rtdb.firebaseio.com',
    storageBucket: 'liquor-lens.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB28fQYd6bC8KVfCdYC9ChbrLcEHg3E6UQ',
    appId: '1:432310880033:ios:f9c9820faf0901ad082060',
    messagingSenderId: '432310880033',
    projectId: 'liquor-lens',
    databaseURL: 'https://liquor-lens-default-rtdb.firebaseio.com',
    storageBucket: 'liquor-lens.appspot.com',
    iosClientId: '432310880033-352e39mlvf2fbodf7m8rqm7eqpca0hvt.apps.googleusercontent.com',
    iosBundleId: 'com.mikeyflorsheim.alcoholInventory',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB28fQYd6bC8KVfCdYC9ChbrLcEHg3E6UQ',
    appId: '1:432310880033:ios:f98789dfd26452ca082060',
    messagingSenderId: '432310880033',
    projectId: 'liquor-lens',
    databaseURL: 'https://liquor-lens-default-rtdb.firebaseio.com',
    storageBucket: 'liquor-lens.appspot.com',
    iosClientId: '432310880033-ih6uobrdifbgecc0cj85ukka5hgkqvoq.apps.googleusercontent.com',
    iosBundleId: 'com.mikeyflorsheim.alcoholInventory.RunnerTests',
  );
}
