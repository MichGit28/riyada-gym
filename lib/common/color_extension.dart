import 'package:flutter/material.dart';

// this class is used to define the color scheme of the app
class TColor {
  // this is the primary color of the app
  static Color get primaryColor1 => Color.fromRGBO(146, 163, 253, 1);
  static Color get primaryColor2 => Color.fromRGBO(157, 206, 255, 1);

  // this is the secondary color of the app
  static Color get secondaryColor1 => Color.fromRGBO(197, 139, 242, 1);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  // this is the third color of the app
  static Color get thirdColor1 => Color.fromRGBO(43, 180, 132, 1);
  static Color get thirdColor2 => Color.fromARGB(255, 42, 89, 105);
  static Color get thirdColor3 => Color.fromARGB(255, 238, 121, 121);

  // we use this to get all the primary and secondary colors
  static List<Color> get primaryGradient => [primaryColor2, primaryColor1];
  static List<Color> get secondaryGradient =>
      [secondaryColor1, secondaryColor2];

  // this is the background color of the app
  static Color get black => const Color(0xff1D1617);
  static Color get grey => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGrey => const Color.fromARGB(255, 229, 232, 232);
}
