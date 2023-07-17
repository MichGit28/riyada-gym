// // import 'package:flutter/material.dart';
// // import 'package:riyada_gym/common/color_extension.dart';
// // import 'package:riyada_gym/common_widget/round_button.dart';
// // import 'package:riyada_gym/common_widget/round_textfield.dart';
// // import 'package:riyada_gym/view/login/complete_profile.dart';

// // class LoginView extends StatefulWidget {
// //   const LoginView({super.key});

// //   @override
// //   State<LoginView> createState() => _LoginViewState();
// // }

// // class _LoginViewState extends State<LoginView> {
// //   bool isCheck = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     var media = MediaQuery.of(context).size;
// //     return Scaffold(
// //       backgroundColor: TColor.white,
// //       body: SingleChildScrollView(
// //         child: SafeArea(
// //           child: Container(
// //             height: media.height * 0.9,
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   "Hey there,",
// //                   style: TextStyle(color: TColor.grey, fontSize: 16),
// //                 ),
// //                 Text(
// //                   "Welcome Back",
// //                   style: TextStyle(
// //                       color: TColor.black,
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.w700),
// //                 ),
// //                 SizedBox(
// //                   height: media.width * 0.05,
// //                 ),
// //                 SizedBox(
// //                   height: media.width * 0.04,
// //                 ),
// //                 const RoundTextField(
// //                   hintText: "Email",
// //                   icon: "assets/img/email.png",
// //                   keyboardType: TextInputType.emailAddress,
// //                 ),
// //                 SizedBox(
// //                   height: media.width * 0.04,
// //                 ),
// //                 RoundTextField(
// //                   hintText: "Password",
// //                   icon: "assets/img/lock.png",
// //                   obscureText: true,
// //                   rightIcon: TextButton(
// //                       onPressed: () {},
// //                       child: Container(
// //                           alignment: Alignment.center,
// //                           width: 20,
// //                           height: 20,
// //                           child: Image.asset(
// //                             "assets/img/show_password.png",
// //                             width: 20,
// //                             height: 20,
// //                             fit: BoxFit.contain,
// //                             color: TColor.grey,
// //                           ))),
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       "Forgot your password?",
// //                       style: TextStyle(
// //                           color: TColor.grey,
// //                           fontSize: 10,
// //                           decoration: TextDecoration.underline),
// //                     ),
// //                   ],
// //                 ),
// //                 const Spacer(),
// //                 RoundButton(
// //                     title: "Login",
// //                     onPressed: () {
// //                       Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                               builder: (context) =>
// //                                   const CompleteProfileView()));
// //                     }),
// //                 SizedBox(
// //                   height: media.width * 0.04,
// //                 ),
// //                 Row(
// //                   // crossAxisAlignment: CrossAxisAlignment.,
// //                   children: [
// //                     Expanded(
// //                         child: Container(
// //                       height: 1,
// //                       color: TColor.grey.withOpacity(0.5),
// //                     )),
// //                     Text(
// //                       "  Or  ",
// //                       style: TextStyle(color: TColor.black, fontSize: 12),
// //                     ),
// //                     Expanded(
// //                         child: Container(
// //                       height: 1,
// //                       color: TColor.grey.withOpacity(0.5),
// //                     )),
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: media.width * 0.04,
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () {},
// //                       child: Container(
// //                         width: 50,
// //                         height: 50,
// //                         alignment: Alignment.center,
// //                         decoration: BoxDecoration(
// //                           color: TColor.white,
// //                           border: Border.all(
// //                             width: 1,
// //                             color: TColor.grey.withOpacity(0.4),
// //                           ),
// //                           borderRadius: BorderRadius.circular(15),
// //                         ),
// //                         child: Image.asset(
// //                           "assets/img/google.png",
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       width: media.width * 0.04,
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {},
// //                       child: Container(
// //                         width: 50,
// //                         height: 50,
// //                         alignment: Alignment.center,
// //                         decoration: BoxDecoration(
// //                           color: TColor.white,
// //                           border: Border.all(
// //                             width: 1,
// //                             color: TColor.grey.withOpacity(0.4),
// //                           ),
// //                           borderRadius: BorderRadius.circular(15),
// //                         ),
// //                         child: Image.asset(
// //                           "assets/img/facebook.png",
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: media.width * 0.04,
// //                 ),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                   },
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Text(
// //                         "Don’t have an account yet? ",
// //                         style: TextStyle(
// //                           color: TColor.black,
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                       Text(
// //                         "Register",
// //                         style: TextStyle(
// //                             color: TColor.black,
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w700),
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: media.width * 0.04,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:riyada_gym/common/color_extension.dart';
// import 'package:riyada_gym/common_widget/round_button.dart';
// import 'package:riyada_gym/common_widget/round_textfield.dart';
// import 'package:riyada_gym/view/login/complete_profile.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({Key? key}) : super(key: key);

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> login(BuildContext context) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       // Check if login was successful
//       if (userCredential.user != null) {
//         // Navigate to the home page or any other desired page
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('User Not Found'),
//             content: const Text('The email you entered does not exist.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       } else if (e.code == 'wrong-password') {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Wrong Password'),
//             content: const Text('The password you entered is incorrect.'),
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
//       print(e);
//     }
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: TColor.white,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Container(
//             height: media.height * 0.9,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Hey there,",
//                   style: TextStyle(color: TColor.grey, fontSize: 16),
//                 ),
//                 Text(
//                   "Welcome Back",
//                   style: TextStyle(
//                       color: TColor.black,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(
//                   height: media.width * 0.05,
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   hintText: "Email",
//                   icon: "assets/img/email.png",
//                   keyboardType: TextInputType.emailAddress,
//                   controller: emailController,
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 RoundTextField(
//                   hintText: "Password",
//                   icon: "assets/img/lock.png",
//                   obscureText: true,
//                   controller: passwordController,
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
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Forgot your password?",
//                       style: TextStyle(
//                         color: TColor.grey,
//                         fontSize: 10,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 RoundButton(
//                   title: "Login",
//                   onPressed: () => login(context),
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
//                       style: TextStyle(color: TColor.black, fontSize: 12),
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
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: media.width * 0.04,
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Don’t have an account yet? ",
//                         style: TextStyle(
//                           color: TColor.black,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         "Register",
//                         style: TextStyle(
//                             color: TColor.black,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       )
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/common_widget/round_textfield.dart';
import 'package:riyada_gym/view/home/home_view.dart';
import 'package:riyada_gym/view/login/complete_profile.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        // Navigate to the home page or any other desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: TColor.grey,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
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
                      style: TextStyle(color: TColor.black, fontSize: 12),
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
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.black,
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
