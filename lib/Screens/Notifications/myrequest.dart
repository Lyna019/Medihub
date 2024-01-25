import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyRequestPage extends StatefulWidget {
  @override
  _MyRequestPageState createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  late Stream<QuerySnapshot> _notificationsStream;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;

    _notificationsStream = FirebaseFirestore.instance
        .collection('notification')
        .where('currentUserId', isEqualTo: _currentUserId)
        .snapshots();
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'waiting':
        return Icon(Icons.access_time, color: Colors.yellow);
      case 'accepted':
        return Icon(Icons.check, color: Colors.green);
      case 'refused':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help); // Default icon for unknown status
    }
  }

  Widget _buildDeleteIcon(String notificationId) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () {
        // Delete the notification from Firestore
        FirebaseFirestore.instance
            .collection('notification')
            .doc(notificationId)
            .delete();
      },
    );
  }

  Widget _buildUpdateIcon(String notificationId) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Colors.black,
      ),
      onPressed: () {
        // Perform the update operation for the notification
      },
    );
  }

  String _formatDate(dynamic date) {
    if (date is String) {
      // Handle the case where date is a String
      DateTime dateTime = DateTime.tryParse(date) ?? DateTime.now();
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else if (date is Timestamp) {
      // Handle the case where date is a Timestamp
      DateTime dateTime = date.toDate();
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else {
      // Handle other cases or provide a default value
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var notification =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var productId = notification['productId'] as String;
              var status = notification['status'] as String;
              return Container(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.0,
                      height: 120.0,
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('rent')
                            .doc(productId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Icon(
                                Icons.image); // Default image placeholder
                          }
                          var rentData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          var productImage = rentData['imageUrl'];

                          if (productImage is String) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                productImage,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Icon(
                                Icons.image); // Default image placeholder
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('rent')
                                  .doc(productId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Icon(
                                      Icons.image); // Default image placeholder
                                }
                                var rentData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return Text(
                                    'Product Name: ${rentData['name']}'); // Display the name property
                              },
                            ),
                            Text(
                              'Period: ${_formatDate(notification['periodFrom'])} - ${_formatDate(notification['periodTo'])}',
                            ),
                            Text('Location: ${notification['location']}'),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(notification['ownerId'] as String)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Text('Owner not found');
                                }
                                var ownerData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                var ownerName = ownerData['phone'] as String;
                                return Text('Owner Phone: $ownerName');
                              },
                            ),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStatusIcon(status),
                                  _buildDeleteIcon(
                                      snapshot.data!.docs[index].id),
                                  _buildUpdateIcon(
                                      snapshot.data!.docs[index].id),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
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
}
