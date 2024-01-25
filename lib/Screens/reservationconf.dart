import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medihub_1/color/colors.dart';

class ReservationConf extends StatefulWidget {
  final String ownerId;
  final String productId;
  final String currentUserId;

  ReservationConf({
    required this.ownerId,
    required this.productId,
    required this.currentUserId,
  });

  @override
  _ReservationConfState createState() => _ReservationConfState();
}

class _ReservationConfState extends State<ReservationConf> {
  final _formKey = GlobalKey<FormState>();
  late String _periodFrom = '';
  late String _periodTo = '';
  String _phoneNumber = '';
  String _location = '';

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _periodFrom = picked.toString();
        } else {
          _periodTo = picked.toString();
        }
      });
    }
  }

  Future<void> sendNotificationToOwner(String deviceToken) async {
    try {
      // FCM server endpoint
      final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

      // FCM server key
      final String serverKey =
          'AAAA8cwvZRw:APA91bHOIwZL1FpDWsdeq47XwoUpRKT1W7cVZaq46Q5LZWVg_GTe3tepbllvONqSYRLefx-G2U15tFx1PGd8R7B0UCl2ISJwl3P1ePRiPRbT4Fc7df7XrwdBm0ydVVYfPM8un6Dcd1BS';

      // Prepare the notification payload
      var notification = {
        'title': 'New Reservation',
        'body': 'You Have Received a New reservation Check it Now.',
      };

      // Prepare the request body
      var body = {
        'notification': notification,
        'to': deviceToken,
      };

      // Prepare the request headers
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      // Send the POST request to FCM server
      var response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check the response status
      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the notification sending
      print('Error sending notification: $error');
    }
  }
void submitReservation() {
  if (_formKey.currentState!.validate()) {
    try {
      // Generate a unique demand ID
      String demandId = UniqueKey().toString();

      FirebaseFirestore.instance.collection('notification').add({
        'demandId': demandId, // Include the demand ID in the notification data
        'ownerId': widget.ownerId,
        'productId': widget.productId,
        'currentUserId': widget.currentUserId,
        'location': _location,
        'periodFrom': _periodFrom,
        'periodTo': _periodTo,
        'phoneNumber': _phoneNumber,
        'status': "waiting",
      }).then((docRef) async {
        // Reservation document added, retrieve the owner's device token
        DocumentSnapshot ownerSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.ownerId)
            .get();
        if (ownerSnapshot.exists) {
          String deviceToken =
              (ownerSnapshot.data() as Map<String, dynamic>)['deviceToken'];
          if (deviceToken != null) {
            // Send a notification to the owner
            await sendNotificationToOwner(deviceToken); // Pass the demand ID to the notification function
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your reservation is under processing.'),
            duration: Duration(seconds: 3),
          ),
        );
      });

      // Handle the successful reservation and provide feedback to the user
    } catch (error) {
      // Handle any errors that occur during the reservation submission
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 86),
              Text(
                'Reservation Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: midnightcolor),
              ),
              SizedBox(height: 16),
              Text(
                'After Confirming your Reservation, keep your eyes on the notifications to see the progress of your demand.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a location.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Text(
                'Reservation Period',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: midnightcolor),
              ),
              SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 147, 168, 225)),
                        ),
                        child: Text(
                          _periodFrom.isNotEmpty
                              ? _periodFrom
                              : 'Select From Date',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 46),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 147, 168, 225)),
                        ),
                        child: Text(
                          _periodTo.isNotEmpty ? _periodTo : 'Select To Date',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 76),
              ElevatedButton(
                onPressed: () {
                  submitReservation();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  primary: green,
                ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Confirm Reservation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
