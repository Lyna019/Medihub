import 'package:flutter/material.dart';
import 'dart:ui';
import 'navscreen.dart';
import 'signin.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUp extends StatelessWidget {
  final TextEditingController userProfileController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
  fit: StackFit.expand, // This makes the stack children fill the available space
  alignment: Alignment.topCenter,
  children: [
Positioned(
          top: 0.0, // Positioned at the top
          child:
      
    Padding(
      padding: EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 50.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 20.0),
        child: Container(
                width: MediaQuery.of(context).size.width, // Set width based on screen size
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
            color: Color.fromARGB(255, 254, 254, 255), // Midnight Blue
            ),
          ),
        ),
      ),
    ),

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(1.0, 150.0, 1.0, 0),
                child: Form(
                  child:Container(
                    width: 590,
                    decoration: BoxDecoration(color: Colors.white ,
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
                    // Handle sign-in with Google
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
            MaterialPageRoute(builder: (context) => SigninScreen()),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            "Sign In",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 82, 162, 228),
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
      controller: phoneNumberController,
      decoration: InputDecoration(
        hintText: "  Phone Number",
      ),
      keyboardType: TextInputType.phone,
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

/// Section Widget
Widget _buildSignUp(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationScreen()),
        );
        // Handle sign up button press
      },
      child: Text("Sign Up"),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
            color: Colors.grey,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ' OR ',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ],
    );
  }
}
