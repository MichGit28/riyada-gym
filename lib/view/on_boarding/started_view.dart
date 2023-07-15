import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/view/on_boarding/on_boarding_view.dart';
import '../../common_widget/round_button.dart';

// this class is the first screen that the user will see when he opens the app
class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  bool isChangeColor = false;

  @override
  Widget build(BuildContext context) {
    // this variable is used to get the size of the screen
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
          width: media.width,
          decoration: BoxDecoration(
            gradient: isChangeColor
                ? LinearGradient(
                    colors: TColor.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : null,
          ),
          child: Column(
            // this is used to align the children in the center
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // this is used to add space between the children
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Riyada-",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Gym",
                    style: TextStyle(
                      color: TColor.primaryColor1,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                "Everyone can Train",
                style: TextStyle(
                  color: TColor.grey,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              // safe area is used to make sure that the widget is not behind the notch
              // notch is the black area in the top of the screen
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: RoundButton(
                    title: "Get Started",
                    type: isChangeColor
                        ? RoundButtonType.textGradient
                        : RoundButtonType.bgGradient,
                    onPressed: () {
                      // if (isChangeColor) {
                      // Go to Next Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnBoardingView()),
                      );
                      // } else {
                      //   // Change Color
                      //   setState(() {
                      //     isChangeColor = true;
                      //   });
                      // }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
