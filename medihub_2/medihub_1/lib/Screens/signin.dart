import 'package:flutter/material.dart';
import 'Forgetpass.dart';
import 'signup.dart';
import 'home.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'navscreen.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQueryData = MediaQuery.of(context);

    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
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

                 child :Container(
                  height: 126,
                  width: 158,
                  child: Image.asset(
                      'assets/images/signin.png'), // Replace with the actual image path
                ),
                ),
                SizedBox(height: 14),
               Align(
                    alignment: Alignment.center,
                    child: Text(
                      "MediHub",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black, // Midnight Blue

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
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 15,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: 30),
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
                    onFieldSubmitted: (_) {
                      // Handle login logic here
                    },
                  ),
                ),
                SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationScreen()),
        );
                    // Handle login logic here
                  },
                  child: Text("Sing In", style: TextStyle(
                    color: const Color.fromARGB(255, 250, 250, 250),
                    fontSize: 18,
                  ),),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30)),

                  ),
                ),
                SizedBox(height: 10),

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
               // Inside the build() method of AndroidSmallOneScreen class
SizedBox(height: 25.0),
Align(
  alignment: Alignment.centerRight,
  child: Padding(
    padding: EdgeInsets.only(right: 88.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
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
                color: Colors.blue,
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
    );
  }
}