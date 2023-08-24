import 'package:firebase_auth/firebase_auth.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import '../workout_tracker/workout_tracker_view.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
                title: "Workout Tracker",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkoutTracker(userID: currentUserId),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
