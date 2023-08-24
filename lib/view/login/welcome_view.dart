import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  // this variable is used to get the current user that is logged in
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: media.width * 0.1,
              ),
              Image.asset(
                "assets/img/welcome.png",
                width: media.width * 0.75,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Text(
                // this is used to display the name of the user that is logged in
                "Welcome ${user?.displayName}",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "You are all set now, let’s reach your\ngoals together with us!",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.grey, fontSize: 16),
              ),
              const Spacer(),
              RoundButton(
                  title: "Go To Home",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainTabView()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
