import 'package:flutter/material.dart';
import '../common/color_extension.dart';

enum StartWorkoutButtonType { bgGradient, textGradient }

class StartWorkoutButton extends StatelessWidget {
  final String title;
  final StartWorkoutButtonType type;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final double fontSize;

  const StartWorkoutButton(
      {super.key,
      required this.title,
      this.fontWeight = FontWeight.w700,
      this.fontSize = 16,
      this.type = StartWorkoutButtonType.bgGradient,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: TColor.primaryGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(25),
        boxShadow: type == StartWorkoutButtonType.bgGradient
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
        height: 40,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: TColor.primaryColor1,
        minWidth: 200,
        // the next couple of lines are used to remove the shadow of the button
        elevation: type == StartWorkoutButtonType.bgGradient ? 0 : 1,
        color: type == StartWorkoutButtonType.bgGradient
            ? Colors.transparent
            : TColor.white,
        child: type == StartWorkoutButtonType.bgGradient
            ? Text(title,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
              ),
      ),
    );
  }
}
