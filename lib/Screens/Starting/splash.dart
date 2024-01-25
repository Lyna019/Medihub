import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/helper/helper.dart';

import 'getstarted.dart';
import '../Mainnavscreen/navscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    checkExistingCredentials();
  }

  Future<void> checkExistingCredentials() async {
        await Future.delayed(Duration(seconds: 4));

    final credentials = await _dbHelper.getCredentials();
    if (credentials.isNotEmpty) {
      final String email = credentials['email'];
      final String password = credentials['password'];
      print('Email: $email');
      print('Password: $password');
      signInWithEmailAndPassword(email, password);
    } else {
      print('No stored credentials');
      // No stored credentials, navigate to the getstarted screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => getstarted()),
      );
    }
  }

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Sign-in successful, navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/lg.png', width: 250, height: 250),
            SizedBox(height: 20),
            Text(
              'MediHub        ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 25, 112), // Midnight Blue
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Equip For Life ',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Midnight Blue
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
