// ignore_for_file: unused_import

import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/tab_button.dart';
import 'package:riyada_gym/view/home/blank_view.dart';
import 'package:riyada_gym/view/main_tab/select_view.dart';
import 'package:flutter/material.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import '../workout_tracker/workout_tracker_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        decoration: BoxDecoration(color: TColor.white, boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
        ]),
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TabButton(
                icon: "assets/img/home_tab.png",
                selectIcon: "assets/img/home_tab_select.png",
                isActive: selectTab == 0,
                onTap: () {
                  selectTab = 0;
                  currentTab = const HomeView();
                  if (mounted) {
                    setState(() {});
                  }
                }),
            TabButton(
                icon: "assets/img/activity_tab.png",
                selectIcon: "assets/img/activity_tab_select.png",
                isActive: selectTab == 1,
                onTap: () {
                  final user = FirebaseAuth.instance.currentUser;
                  final String currentUserId = user?.uid ?? '';
                  selectTab = 1;
                  currentTab = WorkoutTracker(userID: currentUserId);

                  if (mounted) {
                    setState(() {});
                  }
                }),
            TabButton(
                icon: "assets/img/profile_tab.png",
                selectIcon: "assets/img/profile_tab_select.png",
                isActive: selectTab == 3,
                onTap: () {
                  selectTab = 3;
                  currentTab = const ProfileView();
                  if (mounted) {
                    setState(() {});
                  }
                })
          ],
        ),
      )),
    );
  }
}
