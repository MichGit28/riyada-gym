import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/view/login/complete_profile.dart';
import '../../common_widget/round_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

// this class is used to sign up the user to the app
class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // this logger is used to print the logs to the console
  final Logger logger = Logger();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    // Use a regular expression pattern to validate the email format
    // This is a basic pattern and may not cover all possible valid email formats
    // You can modify the pattern based on your specific requirements
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // void _submitForm() {
  //   if (formKey.currentState!.validate()) {
  //     // Extract the values from the text controllers and save them to the database
  //     final firstName = firstNameController.text;
  //     final lastName = lastNameController.text;
  //     final email = emailController.text;
  //     final password = passwordController.text;
  //   }
  // }

// void _submitForm() async {
//   if (formKey.currentState!.validate()) {
//     final firstName = firstNameController.text;
//     final lastName = lastNameController.text;
//     final email = emailController.text;
//     final password = passwordController.text;

//     BuildContext dialogContext;

//     try {
//       await FirebaseFirestore.instance.collection('users').add({
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'password': password,
//       });

//       if (isValidEmail(email)) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const CompleteProfileView(),
//           ),
//         );
//       } else {
//         showDialog(
//           context: dialogContext,
//           builder: (context) => AlertDialog(
//             title: const Text('Invalid Email'),
//             content: const Text('Please enter a valid email address.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error saving user data: $e');
//     }
//   }
// }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      final firstName = firstNameController.text;
      final lastName = lastNameController.text;
      final email = emailController.text;
      final password = passwordController.text;

      try {
        FirebaseFirestore.instance.collection('users').add({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }).then((_) {
          if (isValidEmail(email)) {
            Future.delayed(Duration.zero, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompleteProfileView(),
                ),
              );
            });
          } else {
            showInvalidEmailDialog();
          }
        });
      } catch (e) {
        logger.e('Error saving user data: $e');
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
                    "Hey There,",
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
                    icon: "assets/img/message.png",
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
                    obscureText: true,
                    controller: passwordController,
                    rightIcon: TextButton(
                      onPressed: () {},
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          "assets/img/show_password.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: TColor.grey,
                        ),
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
                            "By continuing you accept our Privacy Policy and\nTerms of Use",
                            style: TextStyle(color: TColor.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.4,
                  ),
                  RoundButton(title: "Register", onPressed: _submitForm),

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
                    onPressed: () {},
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
