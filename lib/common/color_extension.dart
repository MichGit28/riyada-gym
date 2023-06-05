import 'package:flutter/material.dart';

// this class is used to define the color scheme of the app
class TColor {
  // this is the primary color of the app
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  // this is the secondary color of the app
  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

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
