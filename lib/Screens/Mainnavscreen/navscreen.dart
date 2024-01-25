import 'package:flutter/material.dart';
import 'package:medihub_1/Screens/Mainnavscreen/AddProduct.dart';
import 'package:medihub_1/Screens/Mainnavscreen/search.dart';
import 'package:medihub_1/Screens/ProfileComponent/profile.dart';
import 'package:medihub_1/color/colors.dart';

import '../Notifications/notification.dart';
import 'home.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      SearchPage(),
      AddProductPage(),
      notificationScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: 60, // Adjust this height according to your design
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _screens.length,
            (index) => buildNavBarItem(index),
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(int index) {
    return InkWell(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 30,
            height: _currentIndex == index ? 5 : 0,
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          Icon(
            index == 2 ? Icons.add : getIconData(index),
            size: 30,
            color: _currentIndex == index ? green : midnightcolor,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  IconData getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.search;
      case 3:
        return Icons.list;
      case 4:
        return Icons.person;
      default:
        return Icons.home;
    }
  }
}
