import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:riyada_gym/view/workout_tracker/workout_timer_view.dart';
import 'package:video_player/video_player.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/step_detail_row.dart';

class ExercisesStepDetails extends StatefulWidget {
  final String workoutType;
  final String exerciseName;
  final String videoPath;

  const ExercisesStepDetails({
    Key? key,
    required this.workoutType,
    required this.exerciseName,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  bool isLoading = true;
  late Map<String, dynamic> exerciseDetails;
  VideoPlayerController? _videoPlayerController;
  bool _showControls = true;
  bool isWorkoutCompleted = false;

  @override
  void initState() {
    super.initState();
    getExerciseDetails();
    _videoPlayerController =
        _videoPlayerController = VideoPlayerController.asset(widget.videoPath)
          ..initialize().then((_) {
            // Ensure the first frame is shown and set state to refresh the widget.
            _videoPlayerController!.addListener(() {
              setState(
                  () {}); // <-- This is to ensure UI refreshes on video state change

              if (_videoPlayerController!.value.position ==
                  _videoPlayerController!.value.duration) {
                _videoPlayerController!.seekTo(Duration(seconds: 0));
                _videoPlayerController!.play();
              }
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
  }

  Future<void> getExerciseDetails() async {
    final _firestore = FirebaseFirestore.instance;
    DocumentReference workoutRef =
        _firestore.collection('workouts').doc(widget.workoutType);
    DocumentSnapshot documentSnapshot = await workoutRef.get();

    if (documentSnapshot.exists) {
      var allExercises =
          (documentSnapshot.data() as Map<String, dynamic>)['exercises'] ?? [];

      var selectedExercise = allExercises.firstWhere(
        (exercise) => exercise['name'] == widget.exerciseName,
        orElse: () => {},
      );

      if (mounted) {
        if (selectedExercise.isNotEmpty) {
          setState(() {
            exerciseDetails = selectedExercise;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        isLoading = false; // Also update loading state if doc doesn't exist
      });
    }
  }

  List<Widget> _generateSteps() {
    var steps = exerciseDetails['howTo'] as Map<String, dynamic>;
    var keys = steps.keys.toList();

    return List.generate(steps.length, (index) {
      return StepDetailRow(
        sObj: {
          'no': keys[index],
          'title': steps[keys[index]],
        },
        isLast: steps.length - 1 == index,
      );
    });
  }

  Widget gradientButton(
      {required String label, required VoidCallback onPressed}) {
    return Container(
      width: 80, // Adjust as needed
      height: 40,
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

  @override
  Widget build(BuildContext context) {
    //var media = MediaQuery.of(context).size;
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
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      backgroundColor: TColor.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showControls =
                              !_showControls; // toggle the visibility of the controls
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.27,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: TColor.primaryGradient),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AspectRatio(
                              aspectRatio:
                                  _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.27,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: TColor.secondaryColor1, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          if (_showControls)
                            IconButton(
                              onPressed: () {
                                if (_videoPlayerController!.value.isPlaying) {
                                  _videoPlayerController!.pause();
                                } else {
                                  _videoPlayerController!.play();
                                }
                                setState(() {
                                  _showControls = !_showControls;
                                });
                              },
                              icon: Icon(
                                _videoPlayerController!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: TColor.primaryColor1,
                                size: 30,
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      exerciseDetails['name'] ?? 'Unknown Exercise',
                      style: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize:
                              20, // you can adjust the font size as per your design needs
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ReadMoreText(
                      exerciseDetails['description'] ??
                          'Description not available',
                      trimLines: 2,
                      // colorClickableText: TColor.primaryColor1,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: TextStyle(
                        color: TColor.grey,
                        fontSize: 12,
                      ),
                      moreStyle: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      lessStyle: TextStyle(
                          color: TColor.primaryColor1,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (exerciseDetails != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "How To Do It",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        Align(
                          alignment: Alignment
                              .centerRight, // This aligns the child to the right
                          child: Text(
                            "4 Sets",
                            style: TextStyle(color: TColor.grey, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ..._generateSteps(),
                    const SizedBox(
                      height: 40,
                    ),
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
                            "Exercise Completion",
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      "Mark Exercise as Completed",
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
                                      setState(() {
                                        isWorkoutCompleted =
                                            !isWorkoutCompleted;
                                      });
                                    },
                                    iconsTappable: false,
                                    wrapperBuilder: (context, global, child) {
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
                                                      : LinearGradient(colors: [
                                                          Colors.grey,
                                                          Colors.grey[400]!
                                                        ]),
                                                  borderRadius:
                                                      const BorderRadius.all(
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
    );
  }
}
