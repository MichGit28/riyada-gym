import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/our_button.dart';
import 'dart:ui';

class WorkoutTimerView extends StatefulWidget {
  WorkoutTimerView({Key? key}) : super(key: key);

  @override
  _WorkoutTimerViewState createState() => _WorkoutTimerViewState();
}

class _WorkoutTimerViewState extends State<WorkoutTimerView> {
  // Timer fields
  Timer? timer;
  int startTime = 60 * 60; // 60 minutes in seconds
  int timeLeft = 60 * 60;

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    setState(() {
      timeLeft = startTime;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timeLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void pauseTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void resetTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    setState(() {
      timeLeft = startTime;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      color: Colors.white, // To set the whole page to be white
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/dont_quit.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: media.height * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.2,
                      ),
                      Text(
                        "Workout Timer",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.3,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: TColor.primaryGradient,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                        ),
                        child: Center(
                          child: Text(
                            "${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: OurButton(
                          title: "Start",
                          onPressed: startTimer,
                          width: 220,
                          height: 40,
                        ),
                      ),
                      SizedBox(height: 15),
                      OurButton(
                        title: "Pause",
                        onPressed: pauseTimer,
                        width: 220,
                        height: 40,
                      ),
                      SizedBox(height: 15),
                      OurButton(
                        title: "Reset",
                        onPressed: resetTimer,
                        width: 220,
                        height: 40,
                      ),
                      SizedBox(height: 15),
                      OurButton(
                        onPressed: () => Navigator.pop(context),
                        title: "Back",
                        width: 220,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
