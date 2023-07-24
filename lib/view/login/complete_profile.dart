import 'package:flutter/material.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/view/login/login_view.dart';
import 'package:riyada_gym/view/login/what_your_goal_view.dart';
import '../../common_widget/round_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  // these controllers are used to get the entered data from the textfields
  TextEditingController dateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  late String gender;

  // we use dispose method to dispose the controllers after use to avoid memory leaks
  @override
  void dispose() {
    dateController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  // this method is useed to show the gender selection dropdown
  @override
  void initState() {
    super.initState();
    gender = ''; // Assign a default value to gender
  }

  // this method is used to update the user profile data in the database and navigate to the next screen
  // we use async and await to wait for the data to be updated in the database before navigating to the next screen
  Future<void> updateProfileData(BuildContext context) async {
    // Get the user ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Update the user profile document with the entered data
      await FirebaseFirestore.instance.collection('userProfiles').doc(userId).set(
          {
            'gender': gender,
            'dateOfBirth': dateController.text,
            'weight': weightController.text,
            'height': heightController.text,
          },
          SetOptions(
              merge:
                  true)); // Use merge option to update only the specified fields

      // schedulerBinding is used to navigate to the next screen after the frame is rendered
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WhatYourGoalView()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update profile. Please try again."),
        ),
      );
    }
  }

  // this Widget is used to build the UI of the screen and handle the user interactions
  // it's a stateful widget because we need to update the UI when the user enters data
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    // Scaffold is used to add the appbar and the bottom navigation bar
    return Scaffold(
      backgroundColor: TColor.white,
      // SingleChildScrollView is used to make the screen scrollable
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let's complete your profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "it will help us to know you better!",
                  style: TextStyle(color: TColor.grey, fontSize: 13),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Show the gender selection dropdown
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Choose Gender'),
                              content: DropdownButton(
                                value: gender.isNotEmpty ? gender : null,
                                items: [
                                  "Male",
                                  "Female",
                                  ""
                                ] // Added an empty string as the first item
                                    .map((name) => DropdownMenuItem(
                                          value: name,
                                          child: Text(
                                            name.isNotEmpty ? name : "Other",
                                            style: TextStyle(
                                              color: TColor.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                  Navigator.pop(context); // Close the dialog
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: TColor.lightGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.asset(
                                  "assets/img/gender.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: TColor.grey,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  gender,
                                  style: TextStyle(
                                    color: TColor.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dateController,
                            decoration: InputDecoration(
                              hintText: "Date of Birth",
                              prefixIcon: Image.asset(
                                "assets/img/date.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      // this widget is used to show the height and weight fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: weightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                // using regex to allow only 2 decimal places
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Your Weight',
                                prefixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/img/weight.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: TColor.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryGradient,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'KG',
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: heightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Your Height',
                                prefixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/img/height.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: TColor.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryGradient,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'CM',
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                          title: "Next >",
                          onPressed: () {
                            if (dateController.text.isNotEmpty &&
                                weightController.text.isNotEmpty &&
                                heightController.text.isNotEmpty &&
                                gender != null &&
                                gender.isNotEmpty) {
                              updateProfileData(
                                  context); // Call the updateProfileData method
                              return;
                            } else {
                              // SnackBar is used to show the error message to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please fill all the fields!")),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
