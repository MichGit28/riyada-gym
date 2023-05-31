import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/on_boarding_page.dart';

import '../login/signup_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;

  // this is the page controller that will be used to scroll through the pages
  PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController.addListener(() {
      selectPage = _pageController.page!.round() ?? 0;

      setState(() {});
    });
  }

  // this is the list of pages that we will scroll through
  List pageList = [
    {
      "title": "Track Your Goals",
      "subtitle":
          "Don't worry if you have trouble determining your goals, We can help you determine and track your goals",
      "image": "assets/img/onBoard1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/img/onBoard2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/img/onBoard3.png"
    },
    {
      "title": "Improve Sleep\nQuality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/img/onBoard4.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // this is the media query for the screen - we will use it to get the screen size
    var media = MediaQuery.of(context).size;
    // this is the main widget for the screen - we will use it to build the UI
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // this is the background image
          PageView.builder(
            controller: _pageController,
            itemCount: pageList.length,
            itemBuilder: (context, index) {
              // we use Map here to get the page object from the list of pages
              //and pass it to the OnBoardingPage widget
              var pageObject = pageList[index] as Map? ?? {};
              return OnBoardingPage(
                pageObject: pageObject,
              );
            },
          ),
          // this is the container that will hold the page indicator
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: TColor.primaryColor1,
                    value: (selectPage + 1) / 4,
                    strokeWidth: 2,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1,
                      borderRadius: BorderRadius.circular(35)),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: TColor.white,
                      size: 35,
                    ),
                    // this is the button that we will use to navigate to the next page
                    onPressed: () {
                      // check if we are not at the last page
                      if (selectPage < 3) {
                        selectPage = selectPage + 1;

                        _pageController.animateToPage(selectPage,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.bounceInOut);
                        setState(() {});
                      } else {
                        // if we are on the last page -> Open Welcome Screen
                        print("Open Welcome Screen");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
