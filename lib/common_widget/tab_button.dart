import 'package:riyada_gym/common/color_extension.dart';
import 'package:flutter/material.dart';

// this is a helper widget that is used in other widgets to display a tab button with an icon and a select icon
class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final VoidCallback onTap;
  final bool isActive;
  const TabButton(
      {super.key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(isActive ? selectIcon : icon,
            width: 25, height: 25, fit: BoxFit.fitWidth),
        SizedBox(
          height: isActive ? 8 : 12,
        ),
        if (isActive)
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColor.secondaryGradient,
                ),
                borderRadius: BorderRadius.circular(2)),
          )
      ]),
    );
  }
}
