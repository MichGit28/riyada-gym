import 'dart:async';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/icon_title_next_row.dart';
import 'package:riyada_gym/view/workout_tracker/exercises_step_details.dart';
import 'package:flutter/material.dart';
import 'package:riyada_gym/view/workout_tracker/workout_timer_view.dart';
import '../../common_widget/exercises_set_section.dart';
import 'package:intl/intl.dart';
import '../../common_widget/start_workout_button.dart';
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
  // determine if the workout is completed
  bool isWorkoutCompleted = false;
  late List<dynamic> exercisesArr;
  Timer? timer;
  int timePassed = 0;
  Duration elapsedTime = Duration();

  void startTimer() {
    if (timer != null) {
      timer!.cancel(); // Cancel any running timer before starting a new one.
    }

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedTime = elapsedTime + Duration(seconds: 1);
      });
    });
  }

  void pauseTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void stopTimer() async {
    if (timer != null) {
      timer!.cancel();
    }

    // Check for user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Error: No current user found.");
      return;
    }
    String userId = user.uid;

    // Check workout name
    if (widget.workoutData['title'] == null) {
      print("Error: Workout name is null.");
      return;
    }
    String workoutName = widget.workoutData['title'];

    try {
      final CollectionReference totalTimeSpentRef = FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userId)
          .collection('totalTimeSpent');

      final QuerySnapshot snapshot = await totalTimeSpentRef
          .where('workoutName', isEqualTo: workoutName)
          .limit(1)
          .get();

      // If the document already exists, update it
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        await doc.reference.update({
          'timeSpent': elapsedTime.inSeconds + (doc['timeSpent'] ?? 0),
        });
      }
      // If the document doesn't exist, create a new one
      else {
        await totalTimeSpentRef.add({
          'workoutName': workoutName,
          'timeSpent': elapsedTime.inSeconds,
        });
      }
    } catch (e) {
      print("Error writing to Firestore: $e");
    }

    // Reset the elapsedTime to 0
    setState(() {
      elapsedTime = Duration();
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    scheduleController.dispose();
    difficultyController.dispose();
    super.dispose();
  }

  Widget gradientButton(
      {required String label, required VoidCallback onPressed}) {
    return Container(
      width: 60, // Adjust as needed
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20), // Adjust for rounded edges
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 0.5,
            offset: Offset(0, 0.05),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(20), // Match parent's borderRadius
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // this function saves the workout completion status to the database and updates the UI accordingly
  Future<void> saveWorkoutCompletionStatus() async {
    // Get the current user from Firebase Authentication
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Ensure that the user is logged in
    if (currentUser != null) {
      // Use the user's UID
      String uid = currentUser.uid;

      // Calculate the start and end of the week
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      // Check if the user has already completed this workout this week
      QuerySnapshot completedWorkouts = await _firestore
          .collection('userProfiles')
          .doc(uid)
          .collection('completedWorkouts')
          .where('workoutType', isEqualTo: widget.workoutType)
          .where('completionDate', isGreaterThanOrEqualTo: startOfWeek)
          .where('completionDate', isLessThanOrEqualTo: endOfWeek)
          .get();

      if (isWorkoutCompleted) {
        // If the user is trying to mark it as not completed
        if (completedWorkouts.docs.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirmation"),
                content: Text(
                    "Are you sure you want to mark this workout as not completed?"),
                actions: [
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      await _firestore
                          .collection('userProfiles')
                          .doc(uid)
                          .collection('completedWorkouts')
                          .doc(completedWorkouts.docs.first
                              .id) // Assuming only one entry per week
                          .delete();
                      setState(() {
                        isWorkoutCompleted = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // If the user is trying to mark it as completed
        if (completedWorkouts.docs.isEmpty) {
          // Extracting day name from the DateTime object
          // String dayName = DateFormat('EEEE')
          //     .format(now);
          // // EEEE format gives full day name like "Monday"
          String abbreviatedDayName = DateFormat('E').format(now);
          await _firestore
              .collection('userProfiles')
              .doc(uid)
              .collection('completedWorkouts')
              .add({
            'workoutType': widget.workoutType,
            'completionDate': now,
            'completionDay':
                abbreviatedDayName, // Adding the completionDay to Firestore
          });
          setState(() {
            isWorkoutCompleted = true;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success"),
                content: Text(
                    "You've successfully completed this workout, good job!"),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  // This function checks if the user has completed the workout this week
  Future<void> _checkWorkoutCompletionStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      QuerySnapshot completedWorkouts = await _firestore
          .collection('userProfiles')
          .doc(uid)
          .collection('completedWorkouts')
          .where('workoutType', isEqualTo: widget.workoutType)
          .where('completionDate', isGreaterThanOrEqualTo: startOfWeek)
          .where('completionDate', isLessThanOrEqualTo: endOfWeek)
          .get();

      if (completedWorkouts.docs.isNotEmpty) {
        setState(() {
          isWorkoutCompleted = true;
        });
      }
    }
  }

  //
  ItemType determineType(int index) {
    if (index == 0) return ItemType.SetLabel;
    if (index <= exercisesArr.length) return ItemType.Exercise;
    if (index == exercisesArr.length + 1) return ItemType.Spacer;
    if (index == exercisesArr.length + 2) return ItemType.SetLabel;
    return ItemType.Exercise;
  }

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

  // the initState is used to get the workout data and check if the workout is completed
  @override
  void initState() {
    super.initState();
    getWorkoutData();
    _checkWorkoutCompletionStatus();
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
                        SizedBox(
                          height: media.width * 0.01,
                        ),
                        // Center the Timer and the buttons
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // center the items in the row
                            children: [
                              // Pause Button to the left of the timer
                              gradientButton(
                                  label: "Pause", onPressed: pauseTimer),
                              const SizedBox(
                                  width: 20), // Space between button and timer
                              // Timer UI
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: TColor.primaryGradient,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                                child: Center(
                                  child: //Text(
                                      //   "${timePassed ~/ 60}:${(timePassed % 60).toString().padLeft(2, '0')}",
                                      //   style: TextStyle(
                                      //       fontSize: 30, color: Colors.white),
                                      // ),
                                      Text(
                                    "${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 20), // Space between timer and button

                              // Stop Button to the right of the timer
                              gradientButton(
                                  label: "Stop", onPressed: stopTimer),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Start Workout button
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: StartWorkoutButton(
                            title: "Start Workout",
                            onPressed: startTimer,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // This is where you add the CheckboxListTile, right after closing off the ListView.builder
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: TColor.lightGrey,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Workout Completion",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 30,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          "assets/img/p_notification.png", // Replace with your desired icon if needed
                                          height: 17,
                                          width: 17,
                                          fit: BoxFit.contain),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Mark Workout as Completed",
                                          style: TextStyle(
                                            color: TColor.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      CustomAnimatedToggleSwitch<bool>(
                                        current: isWorkoutCompleted,
                                        values: [false, true],
                                        dif: 0.0,
                                        indicatorSize: Size.square(30.0),
                                        animationDuration:
                                            const Duration(milliseconds: 200),
                                        animationCurve: Curves.linear,
                                        iconBuilder: (context, local, global) {
                                          return const SizedBox();
                                        },
                                        defaultCursor: SystemMouseCursors.click,
                                        onTap: () {
                                          saveWorkoutCompletionStatus();
                                        },
                                        iconsTappable: false,
                                        wrapperBuilder:
                                            (context, global, child) {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Positioned(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  height: 30.0,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      gradient: isWorkoutCompleted
                                                          ? LinearGradient(
                                                              colors: TColor
                                                                  .secondaryGradient)
                                                          : LinearGradient(
                                                              colors: [
                                                                  Colors.grey,
                                                                  Colors.grey[
                                                                      400]!
                                                                ]),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  50.0)),
                                                    ),
                                                  )),
                                              child,
                                            ],
                                          );
                                        },
                                        foregroundIndicatorBuilder:
                                            (context, global) {
                                          return SizedBox.fromSize(
                                            size: const Size(10, 10),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: TColor.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50.0)),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      spreadRadius: 0.05,
                                                      blurRadius: 1.1,
                                                      offset: Offset(0.0, 0.8))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        )
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
