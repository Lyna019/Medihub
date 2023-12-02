import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medihub/sceens/profile.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isRent = false;
  String? selectedCategory;
  String? selectedCondition;
  String productName = '';
  double price = 0.0;

  final _formKey = GlobalKey<FormState>();

  

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
            SizedBox(width: 25.0),
            Center(
              child:Text(
              'Add My Product',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),)
            
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      SizedBox(height: 30.0),
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
    
      SizedBox(height: 20.0),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              _buildStyledContainer(_buildTextField1('Product Name')),
              SizedBox(height: 16.0),
              _buildStyledContainer(_buildSwitch()),
              if (isRent) _buildStyledContainer(_buildTextField2('Price Per Day')),
              SizedBox(height: 16.0),
              _buildStyledContainer(_buildDropdown1( ['Mobility Aids', 'Medical Equipments', 'Other'])),
              SizedBox(height: 16.0),
              _buildStyledContainer(_buildDropdown(['New', 'Used', 'Good condition'])),
              SizedBox(height: 16.0),
              _buildStyledContainer(_buildUploadImage()),
              SizedBox(height: 16.0),
              _buildSubmitButton(),
            ],
    
          ),
        ),
    ],
      ),
      
    ),
      )
    );
  }

  Widget _buildStyledContainer(Widget child) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
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

  Widget _buildTextField2( String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        onChanged: (value) {
            setState(() {
              price = double.tryParse(value) ?? 0;
            });
          },
        ),
      ],
    );
  }
  Widget _buildTextField1( String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        TextFormField(
          
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          
          validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        onChanged: (value) {
            setState(() {
              productName = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSwitch() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          children: [
            Text(
          'Donate',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
            Expanded(
              child: Center(
                child: Switch(
                  activeColor: Color(0xFF3CF6B5), // Set the color here
                  value: isRent,
                  onChanged: (value) {
                    setState(() {
                      isRent = value;
                    });
                  },
                ),
              ),
            ),
            Text(
          ' Rent',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildDropdown( List<String> items) {
  // Remove duplicate values from the list
  items = items.toSet().toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      
       DropdownButtonFormField<String>(
              value: selectedCondition,
              hint: Text(
                'Condition',
              ),
              onChanged: (value) =>
                  setState(() => selectedCondition = value),
              validator: (value) => value == null ? 'field required' : null,
              items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
                  child: Text(item),
                );
              }).toList(),
              decoration: InputDecoration(
          // Set the hover color for the entire field
          hoverColor: Color(0xFF3CF6B5),
          border: InputBorder.none,
        ),
      ),
    ],
  );
}


  Widget _buildDropdown1(List<String> items) {
  // Remove duplicate values from the list
  items = items.toSet().toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DropdownButtonFormField<String>(
        value: selectedCategory,
        hint: Text(
          'Category',
        ),
        onChanged: (value) => setState(() => selectedCategory = value),
        validator: (value) => value == null ? 'Field required' : null,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          // Set the hover color for the entire field
          hoverColor: Color(0xFF3CF6B5),
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
          'Upload Product Image',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(child: 
        IconButton(
          onPressed: () {
            _pickImage();
          },
          
          icon: Icon(Icons.photo_library, size: 40, color: Color(0xFF3CF6B5))),
        ),
      ],
    );
  }

 Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Form is valid, submit the product
          _showSubmissionConfirmationDialog(context);
        }
      },
      child:Text(
              'Submit',
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

  
}
Future<void> _pickImage() async {

  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    // Do something with the picked image (e.g., upload to a server)
    File imageFile = File(pickedFile.path);
    // Call your upload function or save the image path
  } else {
    // User canceled the image picking
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
  }}

  void _showSubmissionConfirmationDialog(BuildContext context) {
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
          "Confirm Submission",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to Add your Product to the Viewlist?",
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
    _submitProduct(); // Add your submission logic here
    Navigator.of(context).pop(); // Close the dialog
  },
  child: Text(
    "Submit",
    style: TextStyle(
      color: Colors.black,
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

void _submitProduct(){}



