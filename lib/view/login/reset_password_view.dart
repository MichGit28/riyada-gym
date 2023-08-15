import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/reset_button.dart';
// ignore: unused_import
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/common_widget/round_textfield.dart';
import 'dart:ui';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );

      // Show a dialog to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset Email Sent'),
          content: const Text(
              'A password reset email has been sent to your email address. Please check your inbox and follow the instructions to reset your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      color: Colors.white, // To set the whole page to be white
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/dont_quit.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
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
                        "Reset Password",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      RoundTextField(
                        hintText: "Email",
                        icon: "assets/img/email.png",
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                      SizedBox(
                        height: media.width * 0.5,
                      ),
                      Spacer(),
                      ResetButton(
                        title: "Send Password Reset Email",
                        onPressed: () => sendPasswordResetEmail(context),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
