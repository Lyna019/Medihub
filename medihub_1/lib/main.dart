import 'package:flutter/material.dart';
import 'Screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: SplashScreen(),
    );
  }
}

