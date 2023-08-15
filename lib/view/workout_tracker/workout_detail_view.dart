import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/icon_title_next_row.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/view/home/home_view.dart';
import 'package:riyada_gym/view/workout_tracker/exercises_step_details.dart';
import 'package:flutter/material.dart';
import 'package:riyada_gym/view/workout_tracker/workout_timer_view.dart';
import '../../common_widget/exercises_set_section.dart';
import 'package:intl/intl.dart';
import '../main_tab/main_tab_view.dart';

enum ItemType { SetLabel, Exercise, Spacer }

class WorkoutDetailView extends StatefulWidget {
  final Map<String, dynamic> workoutData;
  final String workoutType;
  final String difficulty;
  const WorkoutDetailView(
      {Key? key,
      required this.workoutData,
      required this.workoutType,
      required this.difficulty})
      : super(key: key);

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  // Firestore instance
  final _firestore = FirebaseFirestore.instance;
  final scheduleController = TextEditingController();
  final difficultyController = TextEditingController();
  // Start with loading state
  bool isLoading = true;

  @override
  void dispose() {
    scheduleController.dispose();
    difficultyController.dispose();
    super.dispose();
  }

  ItemType determineType(int index) {
    if (index == 0) return ItemType.SetLabel;
    if (index <= exercisesArr.length) return ItemType.Exercise;
    if (index == exercisesArr.length + 1) return ItemType.Spacer;
    if (index == exercisesArr.length + 2) return ItemType.SetLabel;
    return ItemType.Exercise;
  }

  late List<dynamic> exercisesArr;

  Future<void> getWorkoutData() async {
    DocumentReference workoutRef =
        _firestore.collection('workouts').doc(widget.workoutType);
    DocumentSnapshot documentSnapshot = await workoutRef.get();
    if (documentSnapshot.exists) {
      setState(() {
        var data = documentSnapshot.data();
        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('exercises')) {
          exercisesArr = data['exercises'] ?? [];
        } else {
          exercisesArr = [];
          isLoading = false;
        }

        isLoading = false; // End loading state
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWorkoutData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.primaryGradient)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainTabView()));
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
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                              color: TColor.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.workoutData["title"].toString(),
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Image.asset(
                                "assets/img/fav.png",
                                width: 15,
                                height: 15,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        IconTitleNextRow(
                          icon: "assets/img/time.png",
                          title: "Today's Workout",
                          time: DateFormat('dd/MM, hh:mm a')
                              .format(DateTime.now()),
                          color: TColor.primaryColor2.withOpacity(0.3),
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: media.width * 0.02,
                        ),
                        IconTitleNextRow(
                          icon: "assets/img/difficulity.png",
                          title: "Difficulty",
                          time: widget.difficulty, // use passed difficulty
                          color: TColor.secondaryColor2.withOpacity(0.3),
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Exercises",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${2} Sets",
                                style:
                                    TextStyle(color: TColor.grey, fontSize: 16),
                              ),
                            )
                          ],
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercisesArr.length + 1,
                          itemBuilder: (context, index) {
                            print('Current index: $index');
                            switch (determineType(index)) {
                              case ItemType.SetLabel:
                              case ItemType.Spacer:
                                return const SizedBox(height: 15);
                              case ItemType.Exercise:
                              default:

                                // Calculate the adjusted index for accessing exercisesArr
                                var adjustedIndex;
                                adjustedIndex = index - 1;
                                var sObj =
                                    exercisesArr[adjustedIndex] as Map? ?? {};

                                String imagePath = sObj['image'] ??
                                    ''; // Fetch the image path from Firestore data

                                return Row(children: [
                                  if (imagePath.isNotEmpty) ...[
                                    // Display the image only if imagePath is not empty
                                    ClipOval(
                                      child: Image.asset(
                                        imagePath,
                                        width:
                                            40, // You can adjust width and height as needed
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            12), // A little space between the image and the exercise details
                                  ],
                                  Expanded(
                                    child: ExercisesSetSection(
                                      sObj: sObj,
                                      onPressed: (obj) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExercisesStepDetails(
                                              workoutType: widget
                                                  .workoutType, // Keep this as is
                                              exerciseName: widget.workoutData[
                                                      'exercises'][index - 1][
                                                  'name'], // Send the exercise name
                                              videoPath: widget.workoutData[
                                                      'exercises'][index - 1][
                                                  'video'], // Send the video path for this exercise
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // New Button with Right Arrow
                                  IconButton(
                                      icon: Icon(Icons.arrow_circle_right,
                                          color: Colors
                                              .grey), // You can choose your desired color.
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExercisesStepDetails(
                                              workoutType: widget
                                                  .workoutType, // Keep this as is
                                              exerciseName: widget.workoutData[
                                                      'exercises'][index - 1][
                                                  'name'], // Send the exercise name
                                              videoPath: widget.workoutData[
                                                      'exercises'][index - 1][
                                                  'video'], // Send the video path for this exercise
                                            ),
                                          ),
                                        );
                                      }),
                                ]);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
