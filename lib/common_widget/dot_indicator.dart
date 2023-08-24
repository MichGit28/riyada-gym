import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int totalDots;
  final int currentDot;

  const DotIndicator({
    Key? key,
    required this.totalDots,
    required this.currentDot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: currentDot == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentDot == index
                ? Colors.blue
                : Colors.grey.shade400, // You can adjust the colors as required
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
