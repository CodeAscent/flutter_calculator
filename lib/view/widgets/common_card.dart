import 'package:flutter/material.dart';
import 'package:flutter_calculator/view/screens/home_screen.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.yellow, width: 4)),
      child: Text(
        label,
        style: kCommonStyle(context),
      ),
    );
  }
}
