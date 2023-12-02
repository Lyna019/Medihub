import 'package:flutter/material.dart';
import 'package:medihub/sceens/settings.dart';
import '../sceens/addProduct.dart';
import '../sceens/updateinfo.dart';
import '../sceens/profile.dart';
void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
    routes: <String, WidgetBuilder>{
      '/addProduct': (BuildContext context) => AddProductPage(),
      '/settings': (BuildContext context) => SettingsPage(),
      '/updateinfo': (BuildContext context) => UpdatePersonalInfoPage(),
    },
  ));
}
