import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double dashLength;
  final double dashGapLength;
  final double lineThickness;
  final Color dashColor;

  DottedLine({
    this.dashLength = 4,
    this.dashGapLength = 4,
    this.lineThickness = 1,
    this.dashColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = dashLength + dashGapLength;
        final dashCount = (boxWidth / (dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashLength,
              height: lineThickness,
              child: DecoratedBox(
                decoration: BoxDecoration(color: dashColor),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
