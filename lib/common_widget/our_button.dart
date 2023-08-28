import 'package:flutter/material.dart';
import '../common/color_extension.dart';

enum OurButtonType { bgGradient, textGradient }

// this is a helper widget that is used in other widgets to display a round button for other widgets
class OurButton extends StatelessWidget {
  final String title;
  final OurButtonType type;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final double fontSize;
  final double width;
  final double height;

  const OurButton({
    super.key,
    required this.title,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 16,
    this.width = 200, // default width
    this.height = 40, // default height
    this.type = OurButtonType.bgGradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // set the width
      height: height, // set the height
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: TColor.primaryGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(25),
        boxShadow: type == OurButtonType.bgGradient
            ? const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.5,
                    offset: Offset(0, 0.05))
              ]
            : null,
      ),
      // MaterialButton is used to create a button with ripple effect
      child: MaterialButton(
        onPressed: onPressed,
        height: height, // set the height
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: TColor.primaryColor1,
        minWidth: double.maxFinite,
        // the next couple of lines are used to remove the shadow of the button
        elevation: type == OurButtonType.bgGradient ? 0 : 1,
        color: type == OurButtonType.bgGradient
            ? Colors.transparent
            : TColor.white,
        child: type == OurButtonType.bgGradient
            ? Text(title,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: fontSize, // use the fontSize property
                  fontWeight: fontWeight, // use the fontWeight property
                ))
            // ShaderMask is used to change the color of the text
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                          colors: TColor.primaryGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      .createShader(
                          Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                },
                child: Text(title,
                    style: TextStyle(
                      color: TColor.primaryColor1,
                      fontSize: fontSize, // use the fontSize property
                      fontWeight: fontWeight, // use the fontWeight property
                    )),
              ),
      ),
    );
  }
}
