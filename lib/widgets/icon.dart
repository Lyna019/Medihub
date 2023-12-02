import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add your button click logic here
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF3CF6B5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Container(), // Add an empty Container as the child
    );
  }
}
