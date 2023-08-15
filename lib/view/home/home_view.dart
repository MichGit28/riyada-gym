import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:riyada_gym/view/login/login_view.dart';
import 'package:riyada_gym/view/main_tab/main_tab_view.dart';
import 'package:riyada_gym/view/workout_tracker/workout_detail_view.dart';
import '../login/user_profile.dart';
import '../main_tab/workout_service.dart';
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double? bmi;
  late PageController _pageController;
  int _currentPage = 0;
  String? userGender;
  List<String> images = [];
  Map<String, String> workoutTypeMap = {};

  // list of videos for the workouts tab
  //List<String> videos = ["workout1.mp4", "workout2.mp4", "workout3.mp4"];

  Future<UserProfile> fetchUserProfile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw StateError('No current user');
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserProfile.fromMap(data, userId); // Updated this line
  }

  // this variable is used to get the current user that is logged in
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserProfile> getUserProfile() async {
    User? user = _auth.currentUser;
    String uid = user!.uid;

    print('Fetching user profile for user id: $uid');

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        print('Snapshot data: ${snapshot.data()}');
        return UserProfile.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        print('No document found for user');
        throw Exception('No document found for user');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);

    // Fetch the user's gender and update the userGender variable
    fetchUserProfile().then((UserProfile profile) {
      setState(() {
        // list of images for the workouts tab
        images = [
          "assets/imgMale/abs.png",
          "assets/imgMale/back.png",
          "assets/imgMale/biceps.png",
          "assets/imgMale/cardio.png",
          "assets/imgMale/chest.png",
          "assets/imgMale/fullbody.png",
          "assets/imgMale/legs.png",
        ];

        // Setting workoutTypeMap
        workoutTypeMap = {
          "assets/imgMale/abs.png": "abs_workout",
          "assets/imgMale/back.png": "back_workout",
          "assets/imgMale/biceps.png": "biceps_workout",
          "assets/imgMale/cardio.png": "cardio_workout",
          "assets/imgMale/chest.png": "chest_workout",
          "assets/imgMale/fullbody.png": "fullbody_workout",
          "assets/imgMale/legs.png": "legs_workout",
        };
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // this buildEquipmentImages function is used to build the equipment images for the workouts
  List<Widget> buildEquipmentImages(List<Map<String, dynamic>> equipmentList) {
    return equipmentList.map((equipmentMap) {
      String imageUrl = equipmentMap['image'];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Image.asset(imageUrl,
            height: 80, width: 80), // Adjust dimensions as needed
      );
    }).toList();
  }

  final List<String> _weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Icon(
                  Icons.logout_outlined,
                  color: TColor.primaryColor1,
                ),
              ),
            ),
          ),
          title: Text(
            "Welcome Back ${user?.displayName}",
            style: TextStyle(color: TColor.grey, fontSize: 16),
          ),
          bottom: TabBar(
            labelColor: TColor.primaryColor1,
            unselectedLabelColor: TColor.black,
            indicatorColor: TColor.primaryColor1,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Workouts'),
              // Tab(text: 'Programs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildWorkoutsTab(),
            // _buildProgramsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutsTab() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // week days are shown above the workout images
            children: _weekdays.map((day) {
              int index = _weekdays.indexOf(day);
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  _weekdays[index],
                  style: TextStyle(
                    color: _currentPage == index
                        ? TColor.primaryColor1
                        : TColor.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) => Column(
              children: [
                _buildWorkoutCarouselItem(index),
                _buildEquipmentCarouselItem(index),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // this buildWorkoutCarouselItem function is used to build the workout images
  Widget _buildWorkoutCarouselItem(int index) {
    return FutureBuilder<Map<String, dynamic>>(future: () {
      String workoutId = workoutTypeMap[images[index]]!;
      WorkoutService workoutService = WorkoutService();
      return workoutService.getWorkout(workoutId);
    }(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      Map<String, dynamic> workoutData = snapshot.data!;

      return GestureDetector(
        onTap: () async {
          String difficulty = workoutData['difficulty'] ?? 'Unknown';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailView(
                workoutData: workoutData,
                workoutType: workoutTypeMap[images[index]]!,
                difficulty: difficulty,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Text(
              // <- Title goes here
              workoutData['title'],
              style: TextStyle(
                  fontSize: 17,
                  color: TColor.primaryColor1,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.29,
              width: MediaQuery.of(context).size.width * 0.99,
              child: Image.asset(
                images[index],
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      );
    });
  }

// this buildEquipmentCarouselItem function is used to build the equipment images
  Widget _buildEquipmentCarouselItem(int index) {
    return FutureBuilder<Map<String, dynamic>>(
      future: () {
        String workoutId = workoutTypeMap[images[index]]!;
        WorkoutService workoutService = WorkoutService();
        return workoutService.getWorkout(workoutId);
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        Map<String, dynamic> workoutData = snapshot.data!;

        // Cast the equipment list
        List<Map<String, dynamic>> equipmentList =
            (workoutData['equipment'] as List? ?? [])
                .cast<Map<String, dynamic>>();

        // Spacer();
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
            ),
            child: Column(
              children: [
                // Workout Description
                Text(
                  workoutData['details'] ?? 'No description available',
                  style: TextStyle(fontSize: 16, color: TColor.grey),
                  textAlign: TextAlign.center,
                ),
                // You'll Need section
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "You'll Need",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      children: buildEquipmentImages(equipmentList),
                    )
                  ],
                ),
                SizedBox(height: 50), // Spacer after equipment images
                // Your "Select Workout" Button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(TColor.primaryColor1),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    String workoutId = workoutTypeMap[images[_currentPage]]!;
                    WorkoutService workoutService = WorkoutService();
                    Map<String, dynamic> workoutData =
                        await workoutService.getWorkout(workoutId);

                    String difficulty = workoutData['difficulty'] ?? 'Unknown';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailView(
                          workoutData: workoutData,
                          workoutType: workoutTypeMap[images[_currentPage]]!,
                          difficulty: difficulty,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Select Workout',
                    style: TextStyle(color: TColor.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
