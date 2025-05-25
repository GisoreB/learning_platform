import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_platform/constants.dart';
import 'package:learning_platform/screens/Holiday_screen/holiday_screen.dart';
import 'package:learning_platform/screens/ResetPassword_screen/resetPassword_screen.dart';
import 'package:learning_platform/screens/Timetable_Screen/timetable_screen.dart';
import 'package:learning_platform/screens/attendance_screen/attendance_screen.dart';
import 'package:learning_platform/screens/datesheet_screen/datesheet_screen.dart';
import 'package:learning_platform/screens/fee_screen/fee_screen.dart';
import 'package:learning_platform/screens/home_screen/widgets/student_data.dart';
import 'package:learning_platform/screens/my_profile/my_profile.dart';
import 'package:learning_platform/screens/notes_screen/notes_screen.dart';
import 'package:learning_platform/screens/result_screen/result_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? studentDetails;

  @override
  void initState() {
    super.initState();
    fetchStudentDetails();
  }

  Future<void> fetchStudentDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${baseURL}student-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessVerificationToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          studentDetails = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load student details');
      }
    } catch (e) {
      throw Exception('Failed to load student details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            padding: const EdgeInsets.all(kDefaultPadding),
            child: studentDetails == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              StudentName(
                                  studentName: studentDetails!['first_name']),
                              kHalfSizedBox,
                              StudentClass(
                                  studentClass:
                                      '${studentDetails!['branch_name']} | Roll no. ${studentDetails!['roll_number']}'),
                              kHalfSizedBox,
                              StudentYear(
                                  studentYear:
                                      studentDetails!['academic_year']),
                            ],
                          ),
                          kHalfSizedBox,
                          StudentPicture(
                            picAddress: studentDetails!['gender'] == 'male'
                                ? 'assets/images/male_student.jpg'
                                : 'assets/images/female_student.png',
                            onPress: () {
                              Navigator.pushNamed(
                                  context, MyProfileScreen.routeName);
                            },
                          ),
                        ],
                      ),
                      sizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StudentDataCard(
                            title: 'Attendence',
                            value: 'assets/icons/attendance-check.svg',
                            onPress: () {
                              Navigator.pushNamed(
                                  context, AttendanceScreen.routeName);
                            },
                          ),
                          StudentDataCard(
                            title: 'Fees Due',
                            value: 'assets/icons/fee.svg',
                            onPress: () {
                              Navigator.pushNamed(context, FeeScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: kOtherColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kDefaultPadding * 3),
                    topRight: Radius.circular(kDefaultPadding * 3),
                  ),
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, HolidayScreen.routeName);
                          },
                          icon: 'assets/icons/holiday-vacation-icon.svg',
                          title: 'Holidays',
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, TimeTableScreen.routeName);
                          },
                          icon: 'assets/icons/timetable-icon.svg',
                          title: 'Time Table',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, ResultScreen.routeName);
                          },
                          icon: 'assets/icons/result-search-icon.svg',
                          title: 'Result',
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, DateSheetScreen.routeName);
                          },
                          icon: 'assets/icons/exam-icon.svg',
                          title: 'DateSheet',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, NotesScreen.routeName);
                          },
                          icon: 'assets/icons/book-icon.svg',
                          title: 'Read Notes',
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(
                                context, ResetPasswordPage.routeName);
                          },
                          icon: 'assets/icons/change-password-icon.svg',
                          title: 'Change\nPassword',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
    super.key,
    required this.onPress,
    required this.icon,
    required this.title,
  });

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
