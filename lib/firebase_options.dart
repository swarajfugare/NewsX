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
    apiKey: 'AIzaSyBr85DhSImmIYqx46Hu5f854j5ekph9jxU',
    appId: '1:69418373397:web:fa0e73ea227fec6254991c',
    messagingSenderId: '69418373397',
    projectId: 'news-4053a',
    authDomain: 'news-4053a.firebaseapp.com',
    storageBucket: 'news-4053a.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBr85DhSImmIYqx46Hu5f854j5ekph9jxU',
    appId: '1:69418373397:android:fa0e73ea227fec6254991c',
    messagingSenderId: '69418373397',
    projectId: 'news-4053a',
    storageBucket: 'news-4053a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBr85DhSImmIYqx46Hu5f854j5ekph9jxU',
    appId: '1:69418373397:ios:fa0e73ea227fec6254991c',
    messagingSenderId: '69418373397',
    projectId: 'news-4053a',
    storageBucket: 'news-4053a.firebasestorage.app',
    iosBundleId: 'com.refixer.newsx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBr85DhSImmIYqx46Hu5f854j5ekph9jxU',
    appId: '1:69418373397:ios:fa0e73ea227fec6254991c',
    messagingSenderId: '69418373397',
    projectId: 'news-4053a',
    storageBucket: 'news-4053a.firebasestorage.app',
    iosBundleId: 'com.refixer.newsx',
  );
}
