import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_platform/constants.dart';
import 'package:learning_platform/screens/choose_your_role_screen/choose_role_page.dart';
import 'package:learning_platform/screens/class_attendance_screen/mark_attendance_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({Key? key}) : super(key: key);
  static String routeName = 'TeacherProfileScreen';

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  Map<String, dynamic>? professorDetails;

  @override
  void initState() {
    super.initState();
    fetchProfessorDetails();
  }

  Future<void> fetchProfessorDetails() async {
    final response = await http.get(
      Uri.parse('${baseURL}professor-details'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessVerificationToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        professorDetails = json.decode(response.body);
      });
    }
    else {
      throw Exception('Failed to load professor details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Container(
        color: kOtherColor,
        child: SingleChildScrollView(
          child: professorDetails == null
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator
              : Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(kDefaultPadding * 2),
                    bottomRight: Radius.circular(kDefaultPadding * 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      maxRadius: 50.0,
                      minRadius: 50.0,
                      backgroundColor: kSecondaryColor,
                      backgroundImage: AssetImage(
                        'assets/images/professor_image.png',
                      ),
                    ),
                    kWidthSizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          professorDetails!['name'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium,
                        ),
                        Text(
                          '${professorDetails!['department']} Department | Cabin no. ${professorDetails!['cabin_number']}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              sizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(
                    title: 'Father Name',
                    value: professorDetails!['father_name'] ?? '',
                  ),
                  ProfileDetailRow(
                    title: 'Mother Name',
                    value: professorDetails!['mother_name'] ?? '',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(
                    title: 'Gender',
                    value: professorDetails!['gender'] ?? '',
                  ),
                  ProfileDetailRow(
                    title: 'Email',
                    value: professorDetails!['email'] ?? '',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(
                    title: 'Phone Number',
                    value: professorDetails!['phone_number'] ?? '',
                  ),
                  ProfileDetailRow(
                    title: 'Date of Birth',
                    value: professorDetails!['date_of_birth'] ?? '22-02-1974',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HomeCard(
                    onPress: () {
                      Navigator.pushNamed(
                        context,
                        MarkAttendanceScreen.routeName,
                      );
                    },
                    icon: 'assets/icons/attendance-check.svg',
                    title: 'Take attendance',
                  ),
                  kHalfWidthSizedBox,
                  HomeCard(
                    onPress: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('LogOut'),
                          content: const Text('Are You Sure to LogOut?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  ChooseRoleScreen.routeName,
                                );
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: 'assets/icons/logout-icon.svg',
                    title: 'Logout',
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
                child: Divider(
                  thickness: 1.0,
                ),
              ),
              Text(
                "About Me",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: kPrimaryColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  professorDetails!['about_me'] ?? '',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: kSecondaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          right: kDefaultPadding / 4,
          left: kDefaultPadding / 4,
          top: kDefaultPadding / 2),
      width: MediaQuery.of(context).size.width / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: kTextLightColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              kHalfSizedBox,
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: kTextBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              kHalfSizedBox,
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: const Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.lock_outline,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final VoidCallback onPress;
  final String icon;
  final String title;

  const HomeCard({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(
          top: kDefaultPadding / 2,
        ),
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 40.0,
              width: 40.0,
              color: kOtherColor,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: kDefaultPadding / 3,
            ),
          ],
        ),
      ),
    );
  }
}