import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'package:learning_platform/screens/login_screen/login_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  static String routeName = 'ChooseRoleScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOtherColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Choose Your Role",
            style: TextStyle(
              fontSize: 36,
              color: kTextBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          sizedBox,
          CustomCard(
            title: "Student",
            imageData: 'assets/images/student_image.png',
            onPress: () {
              userRole.setRole = 'Student';
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
          sizedBox,
          CustomCard(
            title: "Teacher",
            imageData: 'assets/images/professor_image.png',
            onPress: () {
              userRole.setRole = 'Teacher';
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final VoidCallback onPress;
  final String title;
  final String imageData;

  const CustomCard({super.key, required this.title, required this.imageData, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 120).copyWith(
          top: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.purpleAccent,
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(kDefaultPadding)),
        ),
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imageData),
                    ),
                  ),
                ),
              ],
            ),
            kHalfSizedBox,
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: kTextBlackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
