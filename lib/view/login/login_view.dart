import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/common_widget/round_textfield.dart';
import 'package:riyada_gym/view/login/reset_password_view.dart';
import 'package:riyada_gym/view/login/signup_view.dart';
import 'package:riyada_gym/view/main_tab/main_tab_view.dart';

// this is te login page that prompts the user to enter his email and password
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // this variable is used to control the visibility of the password
  bool obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Check if login was successful
      if (userCredential.user != null) {
        // Call the function to delete old workouts
        try {
          await deletePreviousWeekWorkouts(userCredential.user!.uid);
        } catch (e) {
          print("Error deleting old workouts: $e");
          // Optionally show a user-friendly message to the user
        }

        // Call the function to delete old totalTimeSpent
        try {
          await deletePreviousWeekTimeSpent(userCredential.user!.uid);
        } catch (e) {
          print("Error deleting old totalTimeSpent: $e");
          // Optionally show a user-friendly message to the user
        }

        // Navigate to the home page or any other desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('User Not Found'),
            content: const Text('The email you entered does not exist.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Wrong Password'),
            content: const Text('The password you entered is incorrect.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // Function to delete workouts from previous weeks (i.e., before the current week) on login from the database
  Future<void> deletePreviousWeekWorkouts(String currentUserId) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    CollectionReference workoutsCollection = _firestore
        .collection('userProfiles')
        .doc(currentUserId)
        .collection('completedWorkouts');

    DateTime now = DateTime.now();
    int daysToSubtract = (now.weekday % 7) +
        1; // Determines the number of days to go back to the last Sunday.
    DateTime startOfThisWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysToSubtract));

    print("Start Date of This Week: $startOfThisWeek");

    QuerySnapshot workoutsToDelete = await workoutsCollection
        .where('completionDate', isLessThan: startOfThisWeek)
        .get();

    print("Number of workouts to delete: ${workoutsToDelete.docs.length}");

    for (QueryDocumentSnapshot workout in workoutsToDelete.docs) {
      await workoutsCollection.doc(workout.id).delete();
    }
  }

  // Function to delete totalTimeSpent from previous weeks (i.e., before the current week) on login from the database
  Future<void> deletePreviousWeekTimeSpent(String currentUserId) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Pointing to the totalTimeSpent collection of the user
    CollectionReference timeSpentCollection = _firestore
        .collection('userProfiles')
        .doc(currentUserId)
        .collection('totalTimeSpent');

    DateTime now = DateTime.now();
    int daysToSubtract = (now.weekday % 7) +
        1; // Determines the number of days to go back to the last Sunday.
    DateTime startOfThisWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysToSubtract));

    print("Start Date of This Week: $startOfThisWeek");

    // Fetching the timeSpent records to delete (i.e., from previous weeks)
    QuerySnapshot timesToDelete = await timeSpentCollection
        .where('completionDate', isLessThan: startOfThisWeek)
        .get();

    print(
        "Number of timeSpent records to delete: ${timesToDelete.docs.length}");

    for (QueryDocumentSnapshot timeRecord in timesToDelete.docs) {
      await timeSpentCollection.doc(timeRecord.id).delete();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: media.width * 0.09,
                ),
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.grey, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hintText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hintText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: obscurePassword,
                  controller: passwordController,
                  rightIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: TColor.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPasswordView()),
                    );
                  },
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(
                      color: TColor.grey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.5,
                ),
                Spacer(),
                RoundButton(
                  title: "Login",
                  onPressed: () => login(context),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.grey.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.grey, fontSize: 12),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpView()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
