import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/view/login/complete_profile.dart';
import 'package:riyada_gym/view/login/login_view.dart';
import '../../common_widget/round_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

// this class is used to sign up the user to the app
class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // this logger is used to print the logs to the console
  final Logger logger = Logger();
  // this variable is used to control the Privacy Policy checkbox
  bool isChecked = false;
  // this variable is used to control the visibility of the password
  bool obscurePassword = true;
  // these attributes are used to control the text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // this key is used to validate the form meaning that all the fields are filled
  final formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    // this pattern is used to validate the email address
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // this if statement is used to check if the checkbox is checked
      if (!isChecked) {
        // Show an error message if the checkbox is not checked
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Accept Terms'),
            content: const Text(
                'Please accept our Privacy Policy and Terms of Use.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Form is valid, proceed with registration
      User? user;
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        user = userCredential.user;

        if (user != null) {
          // update the user's display name and display it in HomeView
          await user.updateDisplayName("${firstNameController.text}");

          // create the user profile document in the "userProfiles" collection in Firestore
          await FirebaseFirestore.instance
              .collection('userProfiles')
              .doc(user.uid)
              .set({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
          });

          // after the user data has been set, navigate to the next screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CompleteProfileView(),
              ),
            );
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //print('The password provided is too weak.');
          // Show a dialog to the user
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Weak Password'),
              content:
                  const Text('The password you have provided is too weak.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          // print('The account already exists for that email.');
          // Show a dialog to the user
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Email Already in Use'),
              content:
                  const Text('The email you have provided is already in use.'),
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
  }

  void showInvalidEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Email'),
        content: const Text('Please enter a valid email address.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // We use this widget to build the UI of the screen
  @override
  Widget build(BuildContext context) {
    // this variable is used to get the size of the screen
    var media = MediaQuery.of(context).size;
    // Scaffold is used to add the appbar and the bottom navigation bar
    // appBar is basically the top bar that contains the title and the actions
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // this is used to add space between the children
                  SizedBox(
                    height: media.width * 0.09,
                  ),
                  Text(
                    "Hey there,",
                    style: TextStyle(color: TColor.grey, fontSize: 16),
                  ),
                  Text(
                    "Create an Account",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    hintText: "First Name",
                    icon: "assets/img/user_text.png",
                    controller: firstNameController,
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundTextField(
                    hintText: "Last Name",
                    icon: "assets/img/user_text.png",
                    // controller: dataController,
                    controller: lastNameController,
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundTextField(
                    hintText: "Email",
                    icon: "assets/img/email.png",
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null; // Return null if the email is valid
                    },
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
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: TColor.grey,
                      ),
                    ),
                  ),
                  // we use padding to add space between the children
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          icon: Icon(
                            isChecked
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank_outlined,
                            color: TColor.grey,
                            size: 20,
                          ),
                        ),
                        // we use Expanded to make the text take the remaining space
                        Expanded(
                          child: Text(
                            "By continuing you accept our Privacy Policy and Terms of Use",
                            style: TextStyle(color: TColor.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.4,
                  ),
                  RoundButton(
                      title: "Register", onPressed: () => register(context)),
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
                      // we use GestureDetector to make the container clickable
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
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to LoginView when clicked on Login text
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: TColor.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                              color: TColor.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
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
      ),
    );
  }
}
