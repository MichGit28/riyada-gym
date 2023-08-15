import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconTitleTextFieldRow extends StatelessWidget {
  final String icon;
  final String title;
  final Color color;
  final TextEditingController controller;

  IconTitleTextFieldRow({
    required this.icon,
    required this.title,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(icon, width: 30, height: 30),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
