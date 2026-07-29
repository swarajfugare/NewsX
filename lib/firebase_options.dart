import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA_NewsX_Web_ApiKey_2026_Sample',
    appId: '1:102938475610:web:8a9b0c1d2e3f4a5b6c7d',
    messagingSenderId: '102938475610',
    projectId: 'newsx-app',
    authDomain: 'newsx-app.firebaseapp.com',
    storageBucket: 'newsx-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_NewsX_Android_ApiKey_2026_Sample',
    appId: '1:102938475610:android:9f8e7d6c5b4a3f2e1d',
    messagingSenderId: '102938475610',
    projectId: 'newsx-app',
    storageBucket: 'newsx-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_NewsX_IOS_ApiKey_2026_Sample',
    appId: '1:102938475610:ios:7f6e5d4c3b2a1f0e9d',
    messagingSenderId: '102938475610',
    projectId: 'newsx-app',
    storageBucket: 'newsx-app.appspot.com',
    iosBundleId: 'com.newsx.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_NewsX_IOS_ApiKey_2026_Sample',
    appId: '1:102938475610:ios:7f6e5d4c3b2a1f0e9d',
    messagingSenderId: '102938475610',
    projectId: 'newsx-app',
    storageBucket: 'newsx-app.appspot.com',
    iosBundleId: 'com.newsx.app',
  );
}
