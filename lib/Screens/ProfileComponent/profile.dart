import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/Screens/Mainnavscreen/AddProduct.dart';
import 'package:medihub_1/Screens/ProfileComponent/My%20Product/MyProducts.dart';
import 'package:medihub_1/Screens/ProfileComponent/Updateinfo.dart';
import 'package:medihub_1/Screens/ProfileComponent/mydonation.dart';
import 'package:medihub_1/color/colors.dart';
import 'package:medihub_1/helper/helper.dart';

class ProfileScreen extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not authenticated'));
          }

          final User user = snapshot.data!;
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available'));
              }

              final data = snapshot.data!.data() as Map<String, dynamic>?;

              if (data == null) {
                return Center(child: Text('No data available'));
              }

              final username = data['fullName'] as String? ?? 'Unknown';
              final profileImageUrl = data['profileImageUrl'] as String? ?? '';

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 36.0),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profileImageUrl != null
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('assets/images/profile.jpg')
                                as ImageProvider<Object>?,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: green),
                      ),
                      SizedBox(height: 36.0),
                      ShadowedBox(
                        textColor: midnightcolor,
                        iconColor: midnightcolor,
                        text: 'Update personal information',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePersonalInfoPage(),
                            ),
                          );
                        },
                        icon: Icons.person,
                      ),
                      SizedBox(height: 20.0),
                      ShadowedBox(
                        textColor: midnightcolor,
                        iconColor: midnightcolor,
                        text: 'Add my product',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductPage(),
                            ),
                          );
                        },
                        icon: Icons.add_box,
                      ),
                      SizedBox(height: 20.0),
                      ShadowedBox(
                        textColor: midnightcolor,
                        iconColor: midnightcolor,
                        text: 'My Products',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProducts(),
                            ),
                          );
                        },
                        icon: Icons.favorite,
                      ),
                      SizedBox(height: 20.0),
                      ShadowedBox(
                        textColor: midnightcolor,
                        iconColor: midnightcolor,
                        text: 'My Donation',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyDonations(),
                            ),
                          );
                        },
                        icon: Icons.favorite_border,
                        backgroundColor:
                            Colors.pink, // Set a cute background color
                        iconSize:
                            35.0, // Increase the icon size for a cute touch
                      ),
                     
                      SizedBox(height: 20.0),
                      ShadowedBox(
                        text: 'Logout',
                        onPressed: () {
                          _showLogoutConfirmationDialog(context);
                        },
                        icon: Icons.logout,
                        textColor: Colors.red,
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color.fromARGB(255, 246, 66, 60),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          "Logout",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              logout(context);
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      );
    },
  );
}

void logout(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DBHelper _dbHelper = DBHelper();

  try {
    await _auth.signOut();
    await _dbHelper.deleteCredentials();

    // Remove all routes and replace with the sign-in screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signin', // Replace with the route name of your sign-in screen
      (Route<dynamic> route) => false, // Remove all routes in the stack
    );
  } catch (e) {
   
  print('Logout Error: $e'); 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while logging out.'),
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

class ShadowedBox extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor; // Added parameter for background color
  final double iconSize; // Added parameter for icon size

  ShadowedBox({
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.textColor,
    required this.iconColor,
    this.backgroundColor = Colors.white, // Set a default background color
    this.iconSize = 30.0, // Set a default icon size
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        //shadowColor: Colors.grey,
        elevation: 5,
        fixedSize: Size.fromHeight(60.0), // Set the desired height
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30.0), // Set the desired icon size
          SizedBox(width: 18),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.0, // Set the desired text size
            ),
          ),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;

  CircleIconButton({
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: CircleBorder(),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
