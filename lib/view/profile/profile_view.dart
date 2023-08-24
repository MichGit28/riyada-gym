import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import '../login/user_profile.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // this variable is used to get the current user that is logged in
  final user = FirebaseAuth.instance.currentUser;
  bool positive = false;
  Future<UserProfile>? _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = fetchUserProfile();
  }

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/img/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/img/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  // calculate the age of the user based on the date of birth
  int calculateAge(String dateOfBirth) {
    DateTime dob = DateTime.parse(dateOfBirth);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age;
  }

  // this method is used to get the user's full name from the database
  Future<String> fetchUserFullName() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final String firstName = data['firstName'];
        final String lastName = data['lastName'];

        return '$firstName $lastName';
      }
    }

    throw Exception('User not logged in');
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.lightGrey.withOpacity(0.1),
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Your Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.lightGrey.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  //
                  FutureBuilder<UserProfile>(
                    future: fetchUserProfile(),
                    builder: (BuildContext context,
                        AsyncSnapshot<UserProfile> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String imagePath;
                          if (snapshot.data!.gender == 'Male') {
                            imagePath = 'assets/img/u1.png';
                          } else {
                            imagePath = 'assets/img/u2.png';
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: fetchUserFullName(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  snapshot.data!, // Display the full name
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () async {
                        UserProfile userProfile =
                            await _userProfileFuture!; // Get current user data
                        UserProfile? updatedProfile = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileView(userProfile: userProfile),
                          ),
                        );
                        if (updatedProfile != null) {
                          setState(() {
                            _userProfileFuture = Future.value(
                                updatedProfile); // Set the new profile details
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder<UserProfile>(
                future: _userProfileFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<UserProfile> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      UserProfile userProfile = snapshot.data!;
                      int age = calculateAge(
                          userProfile.dateOfBirth); // calculate age
                      return Row(
                        children: [
                          Expanded(
                            child: TitleSubtitleCell(
                              title: userProfile
                                  .height, // get height from user profile
                              subtitle: "Height",
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: userProfile
                                  .weight, // get weight from user profile
                              subtitle: "Weight",
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TitleSubtitleCell(
                              title: age.toString(), // display age
                              subtitle: "Age",
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notification",
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
                            Image.asset("assets/img/p_notification.png",
                                height: 15, width: 15, fit: BoxFit.contain),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "Pop-up Notification",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            CustomAnimatedToggleSwitch<bool>(
                              current: positive,
                              values: [false, true],
                              dif: 0.0,
                              indicatorSize: Size.square(30.0),
                              animationDuration:
                                  const Duration(milliseconds: 200),
                              animationCurve: Curves.linear,
                              onChanged: (b) => setState(() => positive = b),
                              iconBuilder: (context, local, global) {
                                return const SizedBox();
                              },
                              defaultCursor: SystemMouseCursors.click,
                              onTap: () => setState(() => positive = !positive),
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
                                            gradient: LinearGradient(
                                                colors:
                                                    TColor.secondaryGradient),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50.0)),
                                          ),
                                        )),
                                    child,
                                  ],
                                );
                              },
                              foregroundIndicatorBuilder: (context, global) {
                                return SizedBox.fromSize(
                                  size: const Size(10, 10),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: TColor.white,
                                      borderRadius: const BorderRadius.all(
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
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
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
