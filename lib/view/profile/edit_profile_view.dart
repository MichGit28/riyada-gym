import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../login/user_profile.dart';
import 'package:riyada_gym/common/color_extension.dart';
import 'package:riyada_gym/common_widget/round_button.dart';
import 'package:riyada_gym/common_widget/round_textfield.dart';

// This class is used to edit the user profile information such as weight, height, and date of birth.
class EditProfileView extends StatefulWidget {
  final UserProfile userProfile;

  EditProfileView({required this.userProfile});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController? weightController;
  TextEditingController? heightController;
  TextEditingController? dobController;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController(text: widget.userProfile.weight);
    heightController = TextEditingController(text: widget.userProfile.height);
    dobController = TextEditingController(text: widget.userProfile.dateOfBirth);
  }

  // This method is used to update the user profile information in the database.
  void updateProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(widget.userProfile.userId)
          .update({
        'dateOfBirth': dobController!.text,
        'height': heightController!.text,
        'weight': weightController!.text,
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  // This Widget is used to build the UI of the EditProfileView.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                  "Edit Profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 50),
                Container(
                  alignment: Alignment.centerLeft, // Added this line
                  child: Text(
                    "Weight",
                    style: TextStyle(color: TColor.grey, fontSize: 16),
                  ),
                ),
                RoundTextField(
                  hintText: "",
                  icon: "assets/img/weight.png", // Provide suitable icon
                  keyboardType: TextInputType.number,
                  controller: weightController,
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft, // Added this line
                  child: Text(
                    "Height",
                    style: TextStyle(color: TColor.grey, fontSize: 16),
                  ),
                ),
                RoundTextField(
                  hintText: "",
                  icon: "assets/img/height.png", // Provide suitable icon
                  keyboardType: TextInputType.number,
                  controller: heightController,
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft, // Added this line
                  child: Text(
                    "Date of Birth",
                    style: TextStyle(color: TColor.grey, fontSize: 16),
                  ),
                ),
                RoundTextField(
                  hintText: "",
                  icon: "assets/img/date.png", // Provide suitable icon
                  keyboardType: TextInputType.datetime,
                  controller: dobController,
                ),
                SizedBox(height: 50),
                RoundButton(
                  title: "Update",
                  onPressed: () async {
                    updateProfile();
                    UserProfile updatedProfile = UserProfile(
                      firstName: widget.userProfile.firstName,
                      lastName: widget.userProfile.lastName,
                      email: widget.userProfile.email,
                      gender: widget.userProfile.gender,
                      dateOfBirth: dobController!.text,
                      height: heightController!.text,
                      weight: weightController!.text,
                      userId: widget.userProfile.userId,
                    );

                    Navigator.pop(context, updatedProfile);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // we need to dispose the controllers to avoid memory leaks.
  // so we override the dispose method to dispose the controllers.
  @override
  void dispose() {
    weightController!.dispose();
    heightController!.dispose();
    dobController!.dispose();
    super.dispose();
  }
}
