import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class OnBoardingPage extends StatelessWidget {
  // this is the page object that we will pass to the widget
  final Map pageObject;
  const OnBoardingPage({super.key, required this.pageObject});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    // this sizedBox is used to make the page scrollable
    return SizedBox(
      width: media.width,
      height: media.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // here we use the page object to get the image, title and subtitle for each page
        children: [
          Image.asset(
            pageObject["image"].toString(),
            width: media.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              pageObject["title"].toString(),
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              pageObject["subtitle"].toString(),
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
