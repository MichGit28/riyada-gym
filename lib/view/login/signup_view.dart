import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/view/login/complete_profile.dart';
import '../../common_widget/round_textfield.dart';

// this class is used to sign up the user to the app
class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isChecked = false;

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
                const RoundTextField(
                  hintText: "First Name",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                const RoundTextField(
                  hintText: "Last Name",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                const RoundTextField(
                  hintText: "Email",
                  icon: "assets/img/message.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hintText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: true,
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
                RoundButton(
                    title: "Register",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CompleteProfileView()));
                    }),
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:riyada_gym/common/color_extension.dart';
// import 'package:riyada_gym/common_widget/round_button.dart';
// import 'package:riyada_gym/view/login/complete_profile.dart';
// import '../../common_widget/round_textfield.dart';

// // this class is used to sign up the user to the app
// class SignUpView extends StatefulWidget {
//   const SignUpView({Key? key}) : super(key: key);

//   @override
//   State<SignUpView> createState() => _SignUpViewState();
// }

// class _SignUpViewState extends State<SignUpView> {
//   TextEditingController dataController = TextEditingController();
//   bool isChecked = false;
//   final formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     dataController = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // this variable is used to get the size of the screen
//     var media = MediaQuery.of(context).size;
//     // Scaffold is used to add the appbar and the bottom navigation bar
//     // appBar is basically the top bar that contains the title and the actions
//     return Scaffold(
//       backgroundColor: TColor.white,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // this is used to add space between the children
//                 SizedBox(
//                   height: media.width * 0.09,
//                 ),
//                 Text(
//                   "Hey There,",
//                   style: TextStyle(color: TColor.grey, fontSize: 16),
//                 ),
//                 Text(
//                   "Create an Account",
//                   style: TextStyle(
//                       color: TColor.black,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(
//                   height: media.width * 0.05,
//                 ),
//                 const RoundTextField(
//                   hintText: "First Name",
//                   icon: "assets/img/user_text.png",
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 const RoundTextField(
//                   hintText: "Last Name",
//                   icon: "assets/img/user_text.png",
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   hintText: "Email",
//                   icon: "assets/img/message.png",
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null; // Return null if the email is valid
//                   },
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   hintText: "Password",
//                   icon: "assets/img/lock.png",
//                   obscureText: true,
//                   rightIcon: TextButton(
//                     onPressed: () {},
//                     child: Container(
//                       alignment: Alignment.center,
//                       width: 20,
//                       height: 20,
//                       child: Image.asset(
//                         "assets/img/show_password.png",
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.contain,
//                         color: TColor.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // we use padding to add space between the children
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             isChecked = !isChecked;
//                           });
//                         },
//                         icon: Icon(
//                           isChecked
//                               ? Icons.check_box_outlined
//                               : Icons.check_box_outline_blank_outlined,
//                           color: TColor.grey,
//                           size: 20,
//                         ),
//                       ),
//                       // we use Expanded to make the text take the remaining space
//                       Expanded(
//                         child: Text(
//                           "By continuing you accept our Privacy Policy and\nTerms of Use",
//                           style: TextStyle(color: TColor.grey, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: media.width * 0.4,
//                 ),
//                 RoundButton(
//                   title: "Register",
//                   onPressed: () {
//                     if (formKey.currentState!.validate()) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CompleteProfileView(),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 1,
//                         color: TColor.grey.withOpacity(0.5),
//                       ),
//                     ),
//                     Text(
//                       "  Or  ",
//                       style: TextStyle(color: TColor.grey, fontSize: 12),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 1,
//                         color: TColor.grey.withOpacity(0.5),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // we use GestureDetector to make the container clickable
//                     GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         width: 50,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: TColor.white,
//                           border: Border.all(
//                             width: 1,
//                             color: TColor.grey.withOpacity(0.4),
//                           ),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Image.asset(
//                           "assets/img/google.png",
//                           width: 20,
//                           height: 20,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: media.width * 0.04,
//                     ),
//                     GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         width: 50,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: TColor.white,
//                           border: Border.all(
//                             width: 1,
//                             color: TColor.grey.withOpacity(0.4),
//                           ),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Image.asset(
//                           "assets/img/facebook.png",
//                           width: 20,
//                           height: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Already have an account? ",
//                         style: TextStyle(
//                           color: TColor.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         "Login",
//                         style: TextStyle(
//                             color: TColor.grey,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
