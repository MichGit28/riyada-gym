import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/view/on_boarding/started_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// this is the main function of the app which is the entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase app with the default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// this is the main widget of the app which is the root of the widget tree
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp is used to define the app theme and the home page
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
