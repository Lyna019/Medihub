import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medihub_1/color/colors.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = "";
  String productName = "";
  bool isRent = false;
  double productPrice = 0.0;
  String productStatus = "";
  String productCategory = "";
  String productSubcategory = "";
  String? imagePath;

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      }
    });
  }
  @override
  void initState() {
    super.initState();

    // Set initial values for dropdowns

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.white, title: Text("Add Product",style: TextStyle(color: midnightcolor),), centerTitle: true, ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage("assets/images/lg.png"), // Replace with your image
            ),
            SizedBox(height: 10.0),
            Text(
              "Username $username",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Product Name"),
                    onChanged: (value) {
                      setState(() {
                        productName = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                 Row(
  children: [
    Expanded(
      child: Text("Donate", textAlign: TextAlign.end),
    ),
                      SizedBox(width: 90.0),

    Switch(
      value: isRent,
      onChanged: (value) {
        setState(() {
          isRent = value;
        });
      },
    ),
                          SizedBox(width: 90.0),

    Expanded(
      child: Text("Rent", textAlign: TextAlign.start),
    ),
  ],
),

                  TextFormField(
                    decoration: InputDecoration(labelText: "Product Price"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        productPrice = double.parse(value);
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
  items: ["Good", "Not Good", "Excellent"]
      .map((status) => DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          ))
      .toList(),
  onChanged: (value) {
    setState(() {
      productStatus = value!;
    });
  },
  selectedItemBuilder: (BuildContext context) {
    return ["Good", "Not Good", "Excellent"]
        .map<Widget>((String item) {
      return Text(item);
    }).toList();
  },
  hint: Text('Select Product Status'), // Set the hint
),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    items: ["Category 1", "Category 2", "Category 3"]
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        productCategory = value!;
                      });
                    },
                                          hint: Text('Product Category'), // Set the hint

                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    items: ["Subcategory 1", "Subcategory 2", "Subcategory 3"]
                        .map((subcategory) => DropdownMenuItem<String>(
                              value: subcategory,
                              child: Text(subcategory),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        productSubcategory = value!;
                      });
                    },
                      hint: Text('Product subcategory'), // Set the hint

                  ),
                  SizedBox(height: 10.0),
                  InkWell(
                    
                    onTap: _getImage,
                    child: Container(
                      height: 100.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: imagePath == null
                          ? Icon(Icons.upload, size: 50.0)
                          : Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                   ElevatedButton(
                  onPressed: () {
                    // Handle continue logic here
                  },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    primary: Colors.blue,
                                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30)),

                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}