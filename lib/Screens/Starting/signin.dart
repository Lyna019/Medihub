import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:medihub_1/color/colors.dart';
import 'package:medihub_1/helper/helper.dart';

import 'Forgetpass.dart';
import '../Mainnavscreen/navscreen.dart';
import 'signup.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  DBHelper _dbHelper = DBHelper();
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 39),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 126,
                      width: 158,
                      child: Image.asset(
                        'assets/images/signin.png',
                      ), // Replace with the actual image path
                    ),
                  ),
                  SizedBox(height: 14),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "MediHub",
                      style: TextStyle(
                        fontSize: 24,
                        color: midnightcolor, // Midnight Blue
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Rent, donate, review and share",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 43),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 1, right: 7),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        contentPadding:
                            EdgeInsets.only(left: 19, top: 15, bottom: 15),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: signInWithEmailAndPasswordd,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: midnightcolor,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: _isLoading,
                    child: Container(
                      color: const Color.fromARGB(255, 250, 250, 250)
                          .withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AndroidSmallFiveScreen(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 90.0),
                    child: SignInButton(
                      Buttons.Google,
                      text: "Continue with Google",
                      onPressed: () {
                        // Handle sign-in with Google
                      },
                    ),
                  ),
                  SizedBox(height: 70),
                  SizedBox(height: 40.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 88.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the sign-up screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Haven’t account please",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 108, 181, 241),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
void signInWithEmailAndPassword(String email, String password) async {
  setState(() {
    _isLoading = true; // Start loading indicator
  });

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? deviceToken = await FirebaseMessaging.instance.getToken();

    // Update the user document in Firestore with the device token
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userCredential.user?.uid)
        .set({'deviceToken': deviceToken}, SetOptions(merge: true));

    // Sign-in successful, save credentials in local storage
    await _dbHelper.saveCredentials(email, password);

    // Navigate to the main screen and replace the sign-in screen
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
  } finally {
    setState(() {
      _isLoading = false; // Stop loading indicator
    });
  }
}
  void signInWithEmailAndPasswordd() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String email = emailController.text.trim();
        final String password = passwordController.text;
        await _dbHelper.saveCredentials(email, password);
        signInWithEmailAndPassword(email, password);
      } catch (e) {
        // Handle storage or other errors
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
  }
}
