import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medihub_1/color/colors.dart';
import 'package:table_calendar/table_calendar.dart';

import 'reservationconf.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Color.fromARGB(255, 89, 168, 232), // Set the shadow color to blue
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Set the border radius
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Match the border radius
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent], // Add a gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set text color to white
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetail extends StatefulWidget {
  final String id;

  ProductDetail({required this.id, Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Map<DateTime, List<dynamic>> _unavailableDates = {};
  Map<String, dynamic> _data = {};
  bool _isLoading = true;
  Map<DateTime, List<dynamic>> _events = {}; // Add this line
  DateTime? _focusedDay;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
      }
      final rentSnapshot = await FirebaseFirestore.instance
          .collection('rent')
          .doc(widget.id)
          .get();

      if (rentSnapshot.exists) {
        _data = rentSnapshot.data() ?? {};
        await fetchOwnerDetails(_data['userId']);
        _updateUnavailableDates(_data['unavailableDates']);
        print("Fetched unavailableDates: ${_data['unavailableDates']}");
      } else {
        final donateSnapshot = await FirebaseFirestore.instance
            .collection('donate')
            .doc(widget.id)
            .get();

        if (donateSnapshot.exists) {
          _data = donateSnapshot.data() ?? {};
          await fetchOwnerDetails(_data['userId']);
          _updateUnavailableDates(_data['unavailableDates']);
          print("Fetched unavailableDates: ${_data['unavailableDates']}");
        }
      }
    } catch (error) {
      // Handle errors here
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> fetchOwnerDetails(String userId) async {
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          final ownerPhone = userData['phone'] as String?;
          final ownerEmail = userData['email'] as String?;

          if (mounted) {
            setState(() {
              _data['ownerPhone'] = ownerPhone;
              _data['email'] = ownerEmail;
            });
          }
        }
      }
    } catch (error) {
      // Handle errors here
    }
  }

  void _updateUnavailableDates(List<dynamic>? unavailableDates) {
    if (unavailableDates != null) {
      setState(() {
        _unavailableDates = {
          for (var entry
              in _mapUnavailableDates(unavailableDates).map((date) => MapEntry(
                    DateTime(date.year, date.month,
                        date.day), // Remove time information
                    [date] as List<dynamic>,
                  )))
            entry.key: entry.value,
        };
        _events = {
          for (var entry in _unavailableDates.entries)
            DateTime(entry.key.year, entry.key.month, entry.key.day):
                [entry.key] as List<dynamic>,
        };

        print("New _unavailableDates: $_unavailableDates");
        print("New _events: $_events");
      });
    }
  }

  List<DateTime> _mapUnavailableDates(List<dynamic> unavailableDates) {
    return unavailableDates
        .map((timestamp) {
          if (timestamp is Timestamp) {
            return timestamp.toDate();
          }
          return null;
        })
        .whereType<DateTime>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          _data['name'] ?? 'N/A',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12.0), // Set the border radius
                      child: Image.network(
                        _data['imageUrl'] ?? '',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    InfoCard(
                        label: 'Description',
                        value: _data['description'] ?? 'N/A'),
                    SizedBox(height: 16),
                    InfoCard(label: 'Price', value: _data['price'] ?? 'N/A'),
                      SizedBox(height: 16),
                    InfoCard(
                        label: 'Location',
                        value: _data['wilaya'] ?? 'N/A'),
                    SizedBox(height: 16),
                    InfoCard(
                        label: 'Owner Phone',
                        value: _data['ownerPhone'] ?? 'N/A'),
                    SizedBox(height: 16),
                    InfoCard(
                        label: 'Owner Email', value: _data['email'] ?? 'N/A'),
                    SizedBox(height: 16),
                    Text(" Unavailable dates:" ,style: TextStyle(color: Colors.red,fontSize: 24),),
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(Duration(days: 365)),
                      focusedDay: _focusedDay ?? DateTime.now(),
                      eventLoader: (date) {
                        final dateWithoutTime =
                            DateTime(date.year, date.month, date.day);
                              print("EventLoader - Date: $date, Events: ${_events[dateWithoutTime]}");

                        return _events[dateWithoutTime] ?? [];
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                            print("MarkerBuilder - Date: $date, Events: ${_events[date]}");

                          final dateWithoutTime =
                              DateTime(date.year, date.month, date.day);
                          if (_unavailableDates.containsKey(dateWithoutTime)) {
                            return Positioned(
                              right: 1,
                              bottom: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                width: 10,
                                height: 16,
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationConf(
                              ownerId: _data['userId'],
                              productId: widget.id,
                              currentUserId: _currentUserId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(
                            16.0), // Add padding for better visibility
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Set the border radius
                        ),
                        primary: green, // Set the button color to green
                      ),
                      child: Container(
                        width: double
                            .infinity, // Set the button width to double.infinity
                        child: Center(
                          child: Text(
                            'Reservation',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.white, // Set the text color to white
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
