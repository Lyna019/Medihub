import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medihub_1/color/colors.dart';

class UpdatePersonalInfoPage extends StatefulWidget {
  @override
  _UpdatePersonalInfoPageState createState() => _UpdatePersonalInfoPageState();
  String? profileImageUrl ;
}

class _UpdatePersonalInfoPageState extends State<UpdatePersonalInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _profileImage;
    String? profileImageUrl ;

  @override
  void initState() {
    super.initState();
    // Fetch and set initial data here
    _fetchInitialData();
  }

  // Method to fetch initial data
  void _fetchInitialData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
         final profileImageUrl = data['profileImageUrl'] as String? ?? '';


        setState(() {
          nameController.text = data['fullName'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          addressController.text = data['address'] ?? '';

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: midnightcolor,
          ),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigate back when the arrow back button is pressed
          },
        ),
        centerTitle: true,
        title: Text(
          'Update Profile Info ',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: midnightcolor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.0),
            CircleAvatar(
              radius: 60,
              backgroundImage: profileImageUrl  != null
                  ? NetworkImage(profileImageUrl  as String)
                  : AssetImage('assets/images/profile.jpg')
                      as ImageProvider<Object>?,
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStyledContainer(_buildTextField(
                      'Name', 'Enter your name', nameController)),
                  SizedBox(height: 16.0),
                  _buildStyledContainer(_buildTextField(
                      'Email',
                      'Enter your email',
                      emailController,
                      TextInputType.emailAddress)),
                  SizedBox(height: 16.0),
                  _buildStyledContainer(_buildTextField(
                      'Phone Number',
                      'Enter your phone number',
                      phoneController,
                      TextInputType.phone)),
                  SizedBox(height: 16.0),
                  _buildStyledContainer(_buildTextField('Home Address',
                      'Enter your home address', addressController)),
                  SizedBox(height: 16.0),
                  _buildStyledContainer(_buildUploadImage()),
                  SizedBox(height: 16.0),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledContainer(Widget child) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Color(0xFFe3e3e3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildTextField(
      String label, String hintText, TextEditingController controller,
      [TextInputType keyboardType = TextInputType.text]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Profile Image',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(
          child: IconButton(
            onPressed: _pickImage,
            icon: Icon(
              Icons.photo_library,
              size: 40,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _profileImage = File(pickedImage.path);
      }
    });
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add submit logic
        _showConfirmationDialog(context);
      },
      child: Text(
        'Save',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        // Set the background color of the button
        primary: Color(0xFF3CF6B5),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xFF3CF6B5), // Set your desired border color here
              width: 2.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            "Confirm Update",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to update your personal information?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
                _submitUpdate(); // Add your update logic here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Update",
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

  void _submitUpdate() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).set(
        {
          'fullName': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
        },
        SetOptions(merge: true),
      );

      // Upload the profile image if it changed
      if (_profileImage != null) {
        final String profileImageUrl = await _uploadProfileImage(user.uid);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .update({
          'profileImageUrl': profileImageUrl,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  Future<String> _uploadProfileImage(String userId) async {
    final String fileName = 'profile_images/$userId.jpg';
    final Reference reference = FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = reference.putFile(_profileImage!);

    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
