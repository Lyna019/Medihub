import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/color/colors.dart';

import '../searchresault.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> availableEquipment = [];
  List<String> availableLocations = [];
  List<String> availableConditions = [];

  @override
  void initState() {
    super.initState();
    fetchEquipment();
    fetchLocations();
    fetchConditions();
  }

  Future<void> fetchEquipment() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('rent').get();

      Set<String> equipmentSet = {}; // Use a Set to store unique equipment

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? equipmentName = data['name'] as String?;
          if (equipmentName != null) {
            equipmentSet.add(equipmentName); // Add equipment to the set
          }
        }
      });

      setState(() {
        availableEquipment = equipmentSet.toList(); // Convert set to list
      });
    } catch (e) {
      print('Error fetching equipment: $e');
    }
  }

  Future<void> fetchLocations() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('rent').get();

      Set<String> locationSet = {}; // Use a Set to store unique locations

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? location = data['wilaya'] as String?;
          if (location != null) {
            locationSet.add(location); // Add location to the set
          }
        }
      });

      print('Locations from Firestore: $locationSet');

      setState(() {
        availableLocations = locationSet.toList(); // Convert set to list
      });
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  Future<void> fetchConditions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('rent').get();

      Set<String> conditionSet = {}; // Use a Set to store unique conditions

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? condition = data['condition'] as String?;
          if (condition != null) {
            conditionSet.add(condition); // Add condition to the set
          }
        }
      });

      setState(() {
        availableConditions = conditionSet.toList(); // Convert set to list
      });
    } catch (e) {
      print('Error fetching conditions: $e');
    }
  }

  String selectedEquipment = '';
  String selectedlocation = '';
  String selectedcondition = '';

  Map<DateTime, Color> _dayColors = {};
  double minPrice = 0.0;
  double maxPrice = 100.0; // Set your maximum price range

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
          'Search ',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: midnightcolor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SearchBar(),
            SizedBox(height: 20),
            Text(
              'Available Equipment :',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: midnightcolor),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableEquipment
                    .map(
                      (equipment) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEquipment = equipment;
                          });
                          print('Selected: $equipment');
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: equipment == selectedEquipment
                                ? green
                                : Colors.blue,
                          ),
                          child: Text(
                            equipment,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Available Locations:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: midnightcolor),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableLocations
                    .map(
                      (location) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedlocation = location;
                          });
                          // Handle location selection
                          print('Selected Location: $location');
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: location == selectedlocation
                                ? green
                                : Colors.blue,
                          ),
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Available Conditions:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: midnightcolor),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableConditions
                    .map(
                      (condition) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedcondition = condition;
                          });
                          // Handle condition selection
                          print('Selected Condition: $condition');
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: condition == selectedcondition
                                ? green
                                : Colors.blue,
                          ),
                          child: Text(
                            condition,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Price Range:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: midnightcolor),
            ),
            Slider(
              min: 0,
              activeColor: green,
              max: 7000,
              value: maxPrice,
              onChanged: (value) {
                setState(() {
                  maxPrice = value;
                });
              },
            ),
            Text('Max Price: ${maxPrice.toStringAsFixed(2)} DZD /Day '),
            SizedBox(height: 20),
            SizedBox(height: 80),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                primary: midnightcolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPageres(
                            selectedEquipment: selectedEquipment,
                            selectedLocation: selectedlocation,
                            selectedCondition: selectedcondition,
                            maxPrice: maxPrice,
                          )),
                );
              },
              child: Text(
                'Book',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: midnightcolor), // Change hint text color

          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon:
              Icon(Icons.search, color: midnightcolor), // Change icon color
        ),
      ),
    );
  }
}
