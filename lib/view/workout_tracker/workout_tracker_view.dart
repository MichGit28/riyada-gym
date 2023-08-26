import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:riyada_gym/common/app_colors.dart';
import 'package:riyada_gym/common/color_extension.dart';
// import 'package:riyada_gym/presentation/resources/app_resources.dart';
import 'package:intl/intl.dart';
import '../../common/colors_app.dart';
import '../../common/dotted_line.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// statefulWidget is essentially the blurprint for a widget that has mutable state(can change over time)
// It can be considered as the "static" part of your widget
class WorkoutTracker extends StatefulWidget {
  final String userID;

  WorkoutTracker({required this.userID});

  @override
  _WorkoutTrackerState createState() => _WorkoutTrackerState();
}

// The State is the dynamic or mutable part of a StatefulWidget.
//It contains the values that can change over time and potentially cause the widget to rebuild.
class _WorkoutTrackerState extends State<WorkoutTracker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, dynamic>> userProfileData;
  late Future<List<Map<String, dynamic>>> completedWorkouts;
  late Future<Map<String, int>> completedWorkoutsCount;

  // For pie chart representation
  Map<String, int> workoutCounts = {};
  List<String> workoutTypes = [
    'Abs Workout',
    'Back Workout',
    'Chest Workout',
    'Legs Workout',
    'Fullbody Workout',
    'Biceps & Triceps',
    'Cardio Workout'
  ];

  // workoutColors is a list of colors that will be used to represent each workout type
  final List<Color> workoutColors = [
    PColor.primaryColor1,
    PColor.primaryColor2,
    PColor.secondaryColor1,
    PColor.secondaryColor2,
    PColor.thirdColor1,
    PColor.thirdColor2,
    PColor.thirdColor3
  ];

  // This method will be called when the widget is first created (i.e. when the app is first launched)
  @override
  void initState() {
    super.initState();
    userProfileData = FirebaseService(widget.userID).fetchUserProfile();
    completedWorkouts =
        FirebaseService(widget.userID).getCompletedWorkouts(widget.userID);
    completedWorkoutsCount =
        FirebaseService(widget.userID).getCompletedWorkoutsCount();
    _tabController = TabController(length: 2, vsync: this);
  }

  // generatePieChartSections() will generate a list of PieChartSectionData objects
  // that will be used to represent each workout type in the pie chart
  List<PieChartSectionData> generatePieChartSections(
      Map<String, int> totalTimeSpentData) {
    List<PieChartSectionData> sections = [];
    for (int i = 0; i < workoutTypes.length; i++) {
      final workoutType = workoutTypes[i];
      final time = totalTimeSpentData[workoutType] ?? 0;
      if (time > 0) {
        // ensure we're only adding workouts with non-zero time
        sections.add(
          PieChartSectionData(
            color: workoutColors[i],
            value: time.toDouble(),
            title: '${time.toString()}m', // displaying time in seconds
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          ),
        );
      }
    }
    // sorting sections by time (so that bigger pieces represent workouts with more time)
    sections.sort((a, b) => b.value.compareTo(a.value));
    return sections;
  }

  // showingSections() will generate a list of PieChartSectionData objects
  List<PieChartSectionData> showingSections(Map<String, int> workoutCounts) {
    int totalWorkouts =
        workoutCounts.values.fold(0, (prev, element) => prev + element);

    if (totalWorkouts == 0) {
      // if no workouts are present, just return an empty list
      return [];
    }

    // of there are workouts, generate a list of PieChartSectionData objects
    // that will be used to represent each workout type in the pie chart
    return List.generate(workoutTypes.length, (i) {
      final workoutType = workoutTypes[i];
      final count = workoutCounts[workoutType] ?? 0;
      final percentage = (count / totalWorkouts) * 100;
      return PieChartSectionData(
        color: workoutColors[i],
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.mainTextColor1,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    });
  }

  // our build widget is where we define the widget's UI and behavior of the screen
  @override
  Widget build(BuildContext context) {
    // Scaffold is a widget from the Material library that provides a default app barm
    // title and a body property that holds the widget tree for the home screen
    return Scaffold(
      backgroundColor: TColor.lightGrey.withOpacity(0.4),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // this will remove the back button
        title: Text(
          'Workout Tracker',
          style: TextStyle(
            color: TColor.black,
            fontSize: 20,
          ),
        ),
        backgroundColor:
            TColor.primaryColor2.withOpacity(0.7), // applying primary color
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: TColor.black, // active tab color
          unselectedLabelColor:
              TColor.grey.withOpacity(0.5), // inactive tab color
          indicatorColor:
              TColor.black.withOpacity(0.8), // underline color for tabs
          labelStyle: TextStyle(fontSize: 16),
          tabs: [
            Tab(text: 'Total Time Spent'),
            Tab(text: 'Completed Workouts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TotalTimeSpentTab(userID: widget.userID),
          CompletedWorkoutsTab(userID: widget.userID),
        ],
      ),
    );
  }
}

// tis FirebaseService class will be used to fetch data from Firebase Firestore database
class FirebaseService {
  final String userID;

  FirebaseService(this.userID);
  // Future is used to represent a potential value, or error, that will be available at some time in the future
  Future<Map<String, dynamic>> fetchUserProfile() async {
    DocumentSnapshot userProfile = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userID)
        .get();
    return userProfile.data() as Map<String, dynamic>;
  }

  // this method will fetch completed workouts from the database
  Future<List<Map<String, dynamic>>> getCompletedWorkouts(String userId) async {
    QuerySnapshot completedWorkoutsSnapshot = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .collection('completedWorkouts')
        .get();

    // convert the list of documents to a list of maps
    List<Map<String, dynamic>> completedWorkouts = completedWorkoutsSnapshot
        .docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return completedWorkouts;
  }

  // fetch the number of completed workouts from the database in the previous week
  Future<Map<String, int>> fetchCompletedWorkoutsByWeek(String userId) async {
    final now = DateTime.now().toUtc();

    // calculate the start and end of the current week, considering Sunday as the first day
    final startOfWeekMonday = now.subtract(
        Duration(days: now.weekday % 7)); // Monday of the current week
    final endOfWeek = startOfWeekMonday
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    // Saturday of the current week

    // use startOfWeekSunday in the query to get workouts from the previous week
    QuerySnapshot completedWorkoutsSnapshot = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .collection('completedWorkouts')
        .where('completionDate', isGreaterThanOrEqualTo: startOfWeekMonday)
        .where('completionDate', isLessThanOrEqualTo: endOfWeek)
        .get();

    Map<String, int> workoutsByDay = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0
    };

    // loop through the list of documents and count the number of workouts for each day
    for (var doc in completedWorkoutsSnapshot.docs) {
      final date =
          (doc.data() as Map<String, dynamic>)['completionDate'].toDate();
      final weekday = DateFormat('E').format(date);
      workoutsByDay[weekday] = (workoutsByDay[weekday] ?? 0) + 1;
    }

    return workoutsByDay;
  }

  // fetch completed workouts from the database in the previous week, along with their names
  Future<Map<String, List<String>>> fetchCompletedWorkoutsWithNamesByWeek(
      String userId) async {
    final now = DateTime.now().toUtc();

    // calculate the start and end of the current week, considering Sunday as the first day
    final startOfWeekMonday = now.subtract(
        Duration(days: now.weekday % 7)); // Monday of the current week
    final endOfWeek = startOfWeekMonday
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    // Saturday of the current week

    QuerySnapshot completedWorkoutsSnapshot = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .collection('completedWorkouts')
        .where('completionDate', isGreaterThanOrEqualTo: startOfWeekMonday)
        .where('completionDate', isLessThanOrEqualTo: endOfWeek)
        .get();

    Map<String, List<String>> workoutsWithNamesByDay = {
      'Mon': [],
      'Tue': [],
      'Wed': [],
      'Thu': [],
      'Fri': [],
      'Sat': [],
      'Sun': []
    };

    // loop through the list of documents and add the workout names to the list for each day
    for (var doc in completedWorkoutsSnapshot.docs) {
      final date =
          (doc.data() as Map<String, dynamic>)['completionDate'].toDate();
      final workoutName = (doc.data() as Map<String, dynamic>)['workoutType'];
      final weekday = DateFormat('E').format(date);
      workoutsWithNamesByDay[weekday] = [
        ...?workoutsWithNamesByDay[weekday],
        workoutName
      ];
    }

    return workoutsWithNamesByDay;
  }

  // fetch the total time spent on each workout type from the database
  Future<Map<String, int>> getTotalTimeSpent() async {
    QuerySnapshot timeSpentSnapshot = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userID)
        .collection('totalTimeSpent')
        .get();

    // loop through the list of documents and add the time spent for each workout type
    Map<String, int> totalTimeSpent = {};
    for (var doc in timeSpentSnapshot.docs) {
      String workoutName = doc['workoutName'];
      int time = doc['timeSpent'];
      totalTimeSpent[workoutName] = (totalTimeSpent[workoutName] ?? 0) + time;
    }
    return totalTimeSpent;
  }

  // this function calculates the count of completed workouts for each type
  Future<Map<String, int>> getCompletedWorkoutsCount() async {
    QuerySnapshot completedWorkoutsSnapshot = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userID)
        .collection('completedWorkouts')
        .get();

    Map<String, int> completedWorkoutsCount = {};

    // loop through the list of documents and count the number of workouts for each type
    for (var doc in completedWorkoutsSnapshot.docs) {
      String workoutName = doc['workoutType'];
      completedWorkoutsCount[workoutName] =
          (completedWorkoutsCount[workoutName] ?? 0) + 1;
    }

    return completedWorkoutsCount;
  }
}

// this class is used to display the total time spent on each workout type
// ignore: must_be_immutable
class TotalTimeSpentTab extends StatelessWidget {
  final String userID;

  List<String> workoutImages = [
    'assets/imgMale/abs.png',
    'assets/imgMale/back.png',
    'assets/imgMale/chest.png',
    'assets/imgMale/legs.png',
    'assets/imgMale/fullbody.png',
    'assets/imgMale/biceps.png',
    'assets/imgMale/cardio.png',
  ];

  TotalTimeSpentTab({required this.userID});

  @override
  Widget build(BuildContext context) {
    final totalTimeSpent = FirebaseService(userID).getTotalTimeSpent();
    // we use a FutureBuilder to display a loading indicator while the data is being fetched
    return FutureBuilder<Map<String, int>>(
      future: totalTimeSpent,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // here we have the data from the database and we can display it in a pie chart
          final data = snapshot.data!;
          final int totalMinutes = data.values.fold(0, (a, b) => a + b);
          final maxTime = data.values.fold(0, (a, b) => a > b ? a : b);
          final sections =
              _WorkoutTrackerState().generatePieChartSections(data);

          // design the pie chart
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: PieChart(PieChartData(sections: sections)),
                ),
                SizedBox(height: 10),
                Text(
                  'Available Workouts',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: TColor.grey,
                  ),
                ),

                SizedBox(height: 8), // spacing after dotted line
                Expanded(
                  // this is the list of workouts with the time spent on each one
                  child: ListView.separated(
                    itemCount: _WorkoutTrackerState().workoutTypes.length,
                    separatorBuilder: (context, index) => DottedLine(
                        dashLength: 4,
                        dashGapLength: 4,
                        lineThickness: 1,
                        dashColor: TColor.black.withOpacity(
                            0.4)), // this will add a dotted line between each workout
                    // itemBuilder to display each workout with the time spent on it
                    itemBuilder: (context, index) {
                      final workoutType =
                          _WorkoutTrackerState().workoutTypes[index];
                      final workoutColor =
                          _WorkoutTrackerState().workoutColors[index];
                      final workoutImage = workoutImages[index];
                      final minutesSpent = data[workoutType] ?? 0;
                      final percentage = ((minutesSpent / totalMinutes) * 100)
                          .toStringAsFixed(1);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        // this is the row that displays the workout name, time spent and percentage
                        // we also highlight the workout with the highest time spent and display images for each workout
                        child: Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(workoutImage),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                workoutType,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: (minutesSpent == maxTime)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '($percentage% - ${minutesSpent}m)',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: (minutesSpent == maxTime)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: workoutColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// this class is used to display the workouts completed on each day of the week
class CompletedWorkoutsTab extends StatefulWidget {
  final String userID;

  CompletedWorkoutsTab({required this.userID});

  @override
  _CompletedWorkoutsTabState createState() => _CompletedWorkoutsTabState();
}

class _CompletedWorkoutsTabState extends State<CompletedWorkoutsTab> {
  List<String> daysOfTheWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  List<String> workoutImages = [
    'assets/imgMale/abs.png',
    'assets/imgMale/back.png',
    'assets/imgMale/chest.png',
    'assets/imgMale/legs.png',
    'assets/imgMale/fullbody.png',
    'assets/imgMale/biceps.png',
    'assets/imgMale/cardio.png',
  ];

  final List<Color> workoutColors = [
    PColor.primaryColor1,
    PColor.primaryColor2,
    PColor.secondaryColor1,
    PColor.secondaryColor2,
    PColor.thirdColor1,
    PColor.thirdColor2,
    PColor.thirdColor3
  ];

  @override
  Widget build(BuildContext context) {
    final completedWorkoutsWithNamesByWeek = FirebaseService(widget.userID)
        .fetchCompletedWorkoutsWithNamesByWeek(widget.userID);
    // this is the chart that displays the workouts completed on each day of the week
    return FutureBuilder<Map<String, List<String>>>(
      future: completedWorkoutsWithNamesByWeek,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final workoutsData = snapshot.data!;
          List<ColumnSeries<MapEntry<String, int>, String>> chartSeries = [];
          List<MapEntry<String, int>> chartDataSource = workoutsData.entries
              .map((e) => MapEntry(e.key, e.value.length))
              .toList();
          // we use a column series to display the workouts completed on each day of the week
          chartSeries.add(
            ColumnSeries<MapEntry<String, int>, String>(
              dataSource: chartDataSource,
              xValueMapper: (MapEntry<String, int> data, _) => data.key,
              yValueMapper: (MapEntry<String, int> data, _) => data.value,
              pointColorMapper: (MapEntry<String, int> data, _) =>
                  workoutColors[
                      daysOfTheWeek.indexOf(data.key)], // color for each day
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          );

          // we use a listview to display the workouts completed on each day of the week
          // we also build the chart above and display it at the top of the listview
          return Column(
            children: [
              Container(
                height: 250.0,
                width: double.infinity,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: chartSeries,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Weekly Workout Summary',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: TColor.grey,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: workoutsData.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: TColor.black.withOpacity(0.4),
                    ),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final entry = workoutsData.entries.elementAt(index);
                    final day = entry.key;
                    final workoutsList = entry.value;
                    final workoutsCount = workoutsList.length;
                    final dayIndex = daysOfTheWeek.indexOf(day);
                    final workoutImage =
                        (dayIndex >= 0 && dayIndex < workoutImages.length)
                            ? workoutImages[dayIndex]
                            : null;
                    // image section of the listview
                    return ListTile(
                      leading: workoutImage != null
                          ? Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(workoutImage),
                                ),
                              ),
                            )
                          : SizedBox(width: 40, height: 90),
                      title: Text('$day - $workoutsCount Workouts',
                          style: TextStyle(fontSize: 14.0)),
                      subtitle: Text(workoutsList.join('\n'),
                          style: TextStyle(fontSize: 14.0)),
                      trailing: Container(
                        width:
                            40, // this constrains the width of the trailing widget
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: (dayIndex >= 0 &&
                                      dayIndex < workoutColors.length)
                                  ? workoutColors[dayIndex]
                                  : Colors.grey, // fallback color
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
