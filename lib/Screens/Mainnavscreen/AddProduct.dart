import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medihub_1/color/colors.dart';
import 'package:medihub_1/helper/db_helper.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isRent = false;
  String? selectedCategory;
  String? selectedCondition;
  String productName = '';

  String wilaya = '';
  double price = 0.0;
  File? _pickedImage;
  List<String> wilayaList = []; // List to store wilaya names

  final _formKey = GlobalKey<FormState>();
  final dbHelper = DbHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isSubmitting = false;
  @override
  void initState() {
    super.initState();
    fetchWilayaData(); // Fetch unique wilaya data from Firebase Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 25.0),
            Center(
              child: Text(
                'Add My Product',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: midnightcolor),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField1('Product Name'),
                        SizedBox(height: 16.0),
                        _buildSwitch(),
                        if (isRent)
                          _buildFormFieldContainer(
                              _buildTextField2('Price Per Day')),
                        SizedBox(height: 16.0),
                        _buildDropdown1([
                          'Mobility Aids',
                          'Medical Equipments',
                          'Medical supplies',
                          'Diagnostic Equipment',
                          'Medicines'
                        ]),
                        SizedBox(height: 16.0),
                        _buildDropdown(['New', 'Used', 'Good condition']),
                        SizedBox(height: 16.0),
                        _buildLocationField(),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildFormFieldContainer(_buildUploadImage()),
                            SizedBox(width: 16.0),
                            Text("Or"),
                            SizedBox(width: 16.0),
                            _buildFormFieldContainer(_buildTakePicture()),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isSubmitting)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: _showSubmittingDialog(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormFieldContainer(Widget child) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Color(0xFFe3e3e3)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 128, 192, 244)
                .withOpacity(0.5), // Blue shadow color
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildTextField2(String hintText) {
    return _buildFormFieldContainer(
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
    );
  }

  Widget _buildTextField1(String hintText) {
    return _buildFormFieldContainer(
      Column(
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
      ),
    );
  }

  Widget _buildSwitch() {
    return _buildFormFieldContainer(
      Container(
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
                      activeColor: Color(0xFF3CF6B5),
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
      ),
    );
  }

  Widget _buildDropdown(List<String> items) {
    items = items.toSet().toList();

    return _buildFormFieldContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: selectedCondition,
            hint: Text('Condition'),
            onChanged: (value) => setState(() => selectedCondition = value),
            validator: (value) {
              return value == null ? 'Field required' : null;
            },
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: InputDecoration(
              hoverColor: Color(0xFF3CF6B5),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown1(List<String> items) {
    items = items.toSet().toList();

    return _buildFormFieldContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: selectedCategory,
            hint: Text('Category'),
            onChanged: (value) => setState(() => selectedCategory = value),
            validator: (value) {
              return value == null ? 'Field required' : null;
            },
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: InputDecoration(
              hoverColor: Color(0xFF3CF6B5),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  void fetchWilayaData() async {
    final QuerySnapshot rentSnapshot =
        await FirebaseFirestore.instance.collection('rent').get();

    final QuerySnapshot donateSnapshot =
        await FirebaseFirestore.instance.collection('donate').get();

    final List<String> rentWilayas = rentSnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['wilaya'] as String)
        .toList();

    final List<String> donateWilayas = donateSnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['wilaya'] as String)
        .toList();

    final List<String> allWilayas = [...rentWilayas, ...donateWilayas];

    final List<String> uniqueWilayas = allWilayas.toSet().toList();

    setState(() {
      wilayaList = uniqueWilayas;
    });
  }

  final FocusNode focusNode = FocusNode(); // Create a FocusNode instance
  late Timer _debounce;
  Widget _buildLocationField() {
    return _buildFormFieldContainer(
      AutoCompleteTextField<String>(
        decoration: InputDecoration(
          hintText: 'Enter your location (Wilaya)',
          border: InputBorder.none,
        ),
        suggestions: wilayaList,
        itemBuilder: (context, suggestion) => ListTile(
          title: Text(suggestion),
        ),
        itemFilter: (suggestion, query) =>
            suggestion.toLowerCase().startsWith(query.toLowerCase()),
        itemSorter: (a, b) => a.compareTo(b),
        itemSubmitted: (query) {
          setState(() {
            wilaya = query;
            focusNode
                .unfocus(); // Unfocus the field when a suggestion is selected
          });
        },
        key: GlobalKey<AutoCompleteTextFieldState<String>>(),
        clearOnSubmit: false, // Prevent clearing the field on submit
        textChanged: (query) {
          if (_debounce?.isActive ?? false) _debounce.cancel();

          _debounce = Timer(const Duration(milliseconds: 500), () {
            setState(() {
              wilaya = query;
            });
          });
        },
        controller: TextEditingController(
            text: wilaya), // Set the initial value of the field
        focusNode: focusNode, // Assign the FocusNode to the field
      ),
    );
  }

  Widget _buildTakePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Take Product Picture',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: midnightcolor,
          ),
        ),
        Center(
          child: IconButton(
            onPressed: () {
              _takePicture();
            },
            icon: Icon(
              Icons.camera_alt,
              size: 40.0,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    } else {
      // User canceled the operation
    }
  }

  Widget _buildUploadImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Upload Product Image',
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: midnightcolor),
        ),
        IconButton(
          onPressed: () {
            _pickImage();
          },
          icon: Icon(
            Icons.upload,
            size: 40.0,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _showSubmissionConfirmationDialog(context);
        }
      },
      child: Text(
        'Submit',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF3CF6B5),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    } else {
      // User canceled the image picking
    }
  }

  void _showSubmissionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xFF3CF6B5),
              width: 2.0,
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
                _submitProduct();
                Navigator.of(context).pop();
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

  Widget _showSubmittingDialog(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text(
              'Please wait...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitProduct() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        String? userId = currentUser.uid;
        if (_pickedImage != null) {
          List<int> imageBytes = await _pickedImage!.readAsBytes();
          Uint8List uint8List = Uint8List.fromList(imageBytes);

          final storageRef = _storage.ref().child(
              'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = storageRef.putData(uint8List);
          final TaskSnapshot uploadSnapshot = await uploadTask;

          final imageUrl = await uploadSnapshot.ref.getDownloadURL();

          final product = {
            'name': productName,
            'wilaya': wilaya,
            'category': selectedCategory!,
            'condition': selectedCondition!,
            'imageUrl': imageUrl,
            'userId': userId,
          };

          if (isRent) {
            product['price'] = price.toString();
            final rentDocRef = await _firestore.collection('rent').add(product);
            final String productId = rentDocRef.id;
            await rentDocRef.update({'productId': productId});
          } else {
            final donateDocRef =
                await _firestore.collection('donate').add(product);
            final String productId = donateDocRef.id;
            await donateDocRef.update({'productId': productId});
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product successfully added!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          print('Error: _pickedImage is null');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please upload an image before submitting.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error submitting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting product. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
