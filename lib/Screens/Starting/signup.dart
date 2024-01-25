import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medihub_1/color/colors.dart';
import 'package:medihub_1/helper/helper.dart';
import '../Mainnavscreen/navscreen.dart';
import 'signin.dart';
  
class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userProfileController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    checkExistingCredentials();
  }

  Future<void> checkExistingCredentials() async {
    final credentials = await _dbHelper.getCredentials();
    if (credentials.isNotEmpty) {
      final String email = credentials['email'];
      final String password = credentials['password'];
      signInWithEmailAndPassword(email, password);
    }
  }

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
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
    final mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit
              .expand, // This makes the stack children fill the available space
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0.0, // Positioned at the top
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 50.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 20.0),
                  child: Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width based on screen size
                    child: Image.asset(
                      'assets/images/last.png',
                      height: 250.0,
                      alignment: Alignment.center,
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 60.0, left: 20.0),
                child: Container(
                  width: 490.0,
                  height: 100.0,

                  //decoration: BoxDecoration(color: Colors.white),
                  child: Text(
                    "            Sign Up",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color:
                          Color.fromARGB(255, 254, 254, 255), // Midnight Blue
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(1.0, 150.0, 1.0, 0),
                child: Form(
                  child: Container(
                    width: 590,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        _buildUserProfile(context),
                        SizedBox(height: 20.0),
                        _buildPhoneNumber(context),
                        SizedBox(height: 20.0),
                        _buildPassword(context),
                        SizedBox(height: 20.0),
                        _buildConfirmPassword(context),
                        SizedBox(height: 40.0),
                        _buildSignUp(context),
                        SizedBox(height: 20.0),
                        CustomDivider(),
                        Padding(
                          padding: EdgeInsets.only(left: 90.0),
                          child: SignInButton(
                            Buttons.Google,
                            text: "Sign up with Google", 
                              onPressed: () {
              _signUpWithGoogle(context);
            },
                          ),
                        ),
                        SizedBox(height: 100.0),
                        Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Row(
                            children: [
                              Text(
                                "    Already have an account?",
                                style: TextStyle(fontSize: 15.0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SigninScreen()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 82, 162, 228),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: userProfileController,
        decoration: InputDecoration(
          hintText: "  Full Name",
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: EmailController,
        decoration: InputDecoration(
          hintText: "  Email",
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          hintText: "  Password",
        ),
        obscureText: true,
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: confirmPasswordController,
        decoration: InputDecoration(
          hintText: "  Confirm Password",
        ),
        obscureText: true,
      ),
    );
  }
  Future<void> _signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if userCredential.user is not null before accessing uid
        if (userCredential.user != null) {
          // Perform any additional tasks or navigate to the next screen
          // For example, you can update the UI with user information
          print("Google sign-up successful!");
        } else {
          // Show an error message if userCredential.user is null
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Google sign-up failed. Please try again.'),
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
      } else {
        // User canceled Google sign-up
        print("Google sign-up canceled");
      }
    } catch (e) {
      // Show an error message if Google sign-up fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Google sign-up failed. Please try again.'),
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

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      String email = EmailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Check if userCredential.user is not null before accessing uid
        if (userCredential.user != null) {
          // Send email verification
          await userCredential.user!.sendEmailVerification();

          // Show a success message and navigate to the next screen
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text(
                  'Verification email sent. Please check your email and verify your account to continue.',
                ),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to the next screen if needed
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Show an error message if userCredential.user is null
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Sign up failed. Please try again.'),
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
      } else {
        // Show an error message if the email or password is empty
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please enter email and password.'),
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
    } catch (e) {
      // Show an error message if registration fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
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
  Widget _buildSignUp(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        onPressed: () {
          _signUpWithEmailAndPassword(context);
        },
        child: Text(
          'Sign up',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: midnightcolor,
          minimumSize: Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
              color: const Color.fromARGB(255, 108, 181, 241),
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ' OR ',
            style: TextStyle(
              color: const Color.fromARGB(255, 108, 181, 241),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
              color: const Color.fromARGB(255, 108, 181, 241),
            height: 1,
          ),
        ),
      ],
    );
  }
}
