import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Starting/signin.dart';
import 'Screens/Starting/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyAzbSwqTXYy1xm7cKzIDCQcF_YPhtFL7cs",
            appId: "1:1038512776476:android:1a3a2a1c0436c484a846d9",
            messagingSenderId: "1038512776476",
            projectId: "medihub-974e4",
            storageBucket: "gs://medihub-974e4.appspot.com",

          ),
        )
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       routes: {
    '/signin': (context) => SigninScreen(),
  },
      home: SplashScreen(),
    );
  }
}
