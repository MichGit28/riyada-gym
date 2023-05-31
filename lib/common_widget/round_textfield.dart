import 'package:flutter/material.dart';
import '../common/color_extension.dart';

// this class is used to create a round text field
class RoundTextField extends StatelessWidget {
  // variables used in this class
  // "?" means that the variable can be null
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String icon;
  final Widget? rightIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  const RoundTextField(
      {super.key,
      this.controller,
      required this.hintText,
      required this.icon,
      this.margin,
      this.keyboardType,
      this.obscureText = false,
      this.rightIcon});

  @override
  Widget build(BuildContext context) {
    // this is the main widget that is used to create a round text field
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: TColor.lightGrey, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        // controller is used to get the value of the text field
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding:
                // EdgeInsets is used to add padding to the text field
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            // suffix and prefix icons are used to add icons to the text field
            suffixIcon: rightIcon,
            prefixIcon: Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                child: Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: TColor.grey,
                )),
            hintStyle: TextStyle(color: TColor.grey, fontSize: 12)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../common/color_extension.dart';

// // this class is used to create a round text field
// class RoundTextField extends StatelessWidget {
//   // variables used in this class
//   // "?" means that the variable can be null
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String hintText;
//   final String icon;
//   final Widget? rightIcon;
//   final bool obscureText;
//   final EdgeInsets? margin;
//   final String? Function(String?)? validator; // Email validator function
//   const RoundTextField({
//     Key? key,
//     this.controller,
//     required this.hintText,
//     required this.icon,
//     this.margin,
//     this.keyboardType,
//     this.obscureText = false,
//     this.rightIcon,
//     this.validator, // Add validator parameter
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // this is the main widget that is used to create a round text field
//     return Container(
//       margin: margin,
//       decoration: BoxDecoration(
//         color: TColor.lightGrey,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextFormField(
//         // Use TextFormField instead of TextField
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           hintText: hintText,
//           suffixIcon: rightIcon,
//           prefixIcon: Container(
//             alignment: Alignment.center,
//             width: 20,
//             height: 20,
//             child: Image.asset(
//               icon,
//               width: 20,
//               height: 20,
//               fit: BoxFit.contain,
//               color: TColor.grey,
//             ),
//           ),
//           hintStyle: TextStyle(color: TColor.grey, fontSize: 12),
//         ),
//         validator: validator, // Set the validator function
//       ),
//     );
//   }
// }
