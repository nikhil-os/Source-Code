// File generated based on google-services.json
// This file contains the Firebase configuration for the Mova app

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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

  // Android configuration from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmH2CMKSMWlX-c7TN63MIUoZy6Rn5AyFc',
    appId: '1:589896898909:android:9db852d5479330c7ec70b4',
    messagingSenderId: '589896898909',
    projectId: 'ocean-movies',
    storageBucket: 'ocean-movies.firebasestorage.app',
  );

  // iOS configuration - update these values from GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmH2CMKSMWlX-c7TN63MIUoZy6Rn5AyFc',
    appId: '1:589896898909:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '589896898909',
    projectId: 'ocean-movies',
    storageBucket: 'ocean-movies.firebasestorage.app',
    iosBundleId: 'com.webtimemovieocean.app',
  );

  // Web configuration - update if needed
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBmH2CMKSMWlX-c7TN63MIUoZy6Rn5AyFc',
    appId: '1:589896898909:web:YOUR_WEB_APP_ID',
    messagingSenderId: '589896898909',
    projectId: 'ocean-movies',
    storageBucket: 'ocean-movies.firebasestorage.app',
    authDomain: 'ocean-movies.firebaseapp.com',
  );

  // macOS configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmH2CMKSMWlX-c7TN63MIUoZy6Rn5AyFc',
    appId: '1:589896898909:ios:YOUR_MACOS_APP_ID',
    messagingSenderId: '589896898909',
    projectId: 'ocean-movies',
    storageBucket: 'ocean-movies.firebasestorage.app',
    iosBundleId: 'com.webtimemovieocean.app',
  );

  // Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBmH2CMKSMWlX-c7TN63MIUoZy6Rn5AyFc',
    appId: '1:589896898909:web:YOUR_WINDOWS_APP_ID',
    messagingSenderId: '589896898909',
    projectId: 'ocean-movies',
    storageBucket: 'ocean-movies.firebasestorage.app',
    authDomain: 'ocean-movies.firebaseapp.com',
  );
}
