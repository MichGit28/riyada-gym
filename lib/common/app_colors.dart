import 'package:flutter/material.dart';

class PColor {
  // Primary colors with slight shift towards blue
  static Color get primaryColor1 => Color.fromRGBO(87, 111, 231, 1);
  static Color get primaryColor2 => Color.fromRGBO(142, 193, 255, 1);

  // Secondary colors with a slight shift towards purple and pink
  static Color get secondaryColor1 => Color.fromRGBO(187, 129, 242, 1);
  static Color get secondaryColor2 => const Color(0xffF093C9);

  // Third colors with a deeper shade to ensure differentiation
  static Color get thirdColor1 => Color.fromRGBO(33, 170, 122, 1);
  static Color get thirdColor2 => Color.fromARGB(255, 32, 79, 95);
  static Color get thirdColor3 => Color.fromARGB(255, 228, 101, 101);

  // Gradients (no change here as they are combinations of the above)
  static List<Color> get primaryGradient => [primaryColor2, primaryColor1];
  static List<Color> get secondaryGradient =>
      [secondaryColor1, secondaryColor2];

  // Background and neutral colors (no change, as these are standard shades)
  static Color get black => const Color(0xff1D1617);
  static Color get grey => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGrey => const Color.fromARGB(255, 229, 232, 232);
}
