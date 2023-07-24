import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/view/login/complete_profile.dart';
import 'package:riyada_gym/view/login/login_view.dart';
import 'package:riyada_gym/view/login/signup_view.dart';
import 'package:riyada_gym/view/login/what_your_goal_view.dart';
import 'package:riyada_gym/view/main_tab/main_tab_view.dart';
import 'package:riyada_gym/view/on_boarding/started_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riyada Gym',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: const Scaffold(
        body: StartedView(),
      ),
    );
  }
}
