import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web no configurado.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Plataforma no configurada.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaAu8O1MV-bNFVebR-8vQKnyPpJJHtesg',
    appId: '1:765681862200:android:6ebdc658a2905a5f1888cd',
    messagingSenderId: '765681862200',
    projectId: 'pruebaproyecto-a8753',
    storageBucket: 'pruebaproyecto-a8753.appspot.com',
  );
}