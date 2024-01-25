import 'package:flutter/material.dart';
import 'package:medihub_1/color/colors.dart';

import 'demends.dart';
import 'myrequest.dart';

class notificationScreen extends StatefulWidget {
  final int initialIndex;

  notificationScreen({this.initialIndex = 0});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<notificationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  final List<Widget> _screens = [
    MyRequestPage(),
    UpcomingDemandsPage(),
  ];

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
          'Notifications',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: midnightcolor,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.0),
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildCategoryButton(0, 'My Requests'),
                  buildCategoryButton(1, 'Comming demmands'),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _screens,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryButton(int index, String label) {
    // Extract the first word from the label
    String firstWord = label.split(' ')[0];

    return TextButton(
      onPressed: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: firstWord,
              style: TextStyle(
                color: _currentIndex == index ? green : midnightcolor,
              ),
            ),
            TextSpan(text: '\n'), // Add a line break
            TextSpan(
              text: label
                  .substring(firstWord.length)
                  .trim(), // Exclude the first word
              style: TextStyle(
                color: _currentIndex == index ? green : midnightcolor,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center, // Center the text
      ),
    );
  }
}
