import 'package:flutter/material.dart';




class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleIconButton(
              onPressed: () {
                Navigator.pop(context); // Handle back button press
              },
              icon: Icons.arrow_back_ios,
              backgroundColor: Color(0xFF3CF6B5),
              
            ),
            SizedBox(width: 70.0),
            Center(
              child:Text(
              'Profile',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),)
            
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.jpg'), // Replace with your image asset
            ),
            SizedBox(height: 16.0),
            Text(
              'Username',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 150.0),
            ShadowedBox(
              text: 'Update personal information',
              onPressed: () {
                Navigator.pushNamed(context, '/updateinfo');
              },
              icon: Icons.person,
            ),
            SizedBox(height: 16.0),
            ShadowedBox(
              text: 'Add my product',
              onPressed: () {
                Navigator.pushNamed(context, '/addProduct');
              },
              icon: Icons.add_box,
            ),
            SizedBox(height: 16.0),
            ShadowedBox(
              text: 'My donations',
              onPressed: () {
                // Handle box 3 press
              },
              icon: Icons.favorite,
            ),
            SizedBox(height: 16.0),
            ShadowedBox(
              text: 'Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: Icons.settings,
            ),
            SizedBox(height: 16.0),
            ShadowedBox(
              text: 'Logout',
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              icon: Icons.logout,
            ),
          ],
        ),
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
            color:Color(0xFF3CF6B5), // Set your desired border color here
            width: 2.0, // Set the border width
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child:  Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
    "Logout",
    style: TextStyle(
      color: Colors.white,
    ),
  ),
  style: TextButton.styleFrom(
    backgroundColor: Color(0xFF3CF6B5),
  ),
            ),
          ],
        );
      },
    );
}

class ShadowedBox extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  ShadowedBox({required this.text, required this.onPressed , required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 16.0),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
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


