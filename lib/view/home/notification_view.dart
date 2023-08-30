import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common/dotted_line.dart';
import '../../common_widget/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List notificationArr = [
    {
      "image": "assets/imgMale/Workout1.png",
      "title": "Ensure you're staying hydrated during workouts.",
    },
    {
      "image": "assets/imgMale/Workout2.png",
      "title": "It's crucial to rest between sets for optimal results.",
    },
    {
      "image": "assets/imgMale/Workout3.png",
      "title": "A balanced diet enhances athletic performance.",
    },
    {
      "image": "assets/imgMale/Workout1.png",
      "title": "Don't skip the warm-up and cool-down sessions.",
    },
    {
      "image": "assets/imgMale/Workout2.png",
      "title": "Overtraining can hinder progress. Rest is key.",
    },
    {
      "image": "assets/imgMale/Workout3.png",
      "title": "Flexibility training is as essential as strength training.",
    },
    {
      "image": "assets/imgMale/Workout1.png",
      "title": "Consistency is the key to long-term fitness success.",
    },
    {
      "image": "assets/imgMale/Workout2.png",
      "title": "Quality over quantity: Focus on your form.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Recommendations",
          style: TextStyle(
              color: TColor.grey, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          children: [
            // Displaying the list
            for (var index = 0; index < notificationArr.length; index++) ...[
              NotificationRow(nObj: notificationArr[index]),
              if (index != notificationArr.length - 1 ||
                  index == notificationArr.length - 1)
                DottedLine(
                  dashLength: 4,
                  dashGapLength: 4,
                  lineThickness: 1,
                  dashColor: TColor.grey.withOpacity(0.5),
                )
            ],

            // Adding space after the list
            SizedBox(height: 30),

            // Adding the image
            Image.asset(
              'assets/imgMale/dumbbells.png',
              width: 120,
              height: 120,
            ),

            // Adding space after the image
            SizedBox(height: 15),

            // Adding the slogan
            Text(
              "Fitness First - Excuses Never",
              style: TextStyle(
                color: TColor.grey,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
