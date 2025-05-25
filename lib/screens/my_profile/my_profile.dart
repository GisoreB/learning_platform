import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'package:learning_platform/screens/choose_your_role_screen/choose_role_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  static String routeName = 'MyProfileScreen';

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Logout') {
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
                              context, ChooseRoleScreen.routeName);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding / 2),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Logout',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                    color: Colors.grey[200],
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: kDefaultPadding / 2, horizontal: 12),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: kOtherColor,
        child: SingleChildScrollView(
          child: studentDetails == null
              ? const Center(child: CircularProgressIndicator())
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
                          CircleAvatar(
                            maxRadius: 50.0,
                            minRadius: 50.0,
                            backgroundColor: kSecondaryColor,
                            backgroundImage: AssetImage(
                              studentDetails!['gender'] == 'male'
                                  ? 'assets/images/male_student.jpg'
                                  : 'assets/images/female_student.png',
                            ),
                          ),
                          kWidthSizedBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    studentDetails!['first_name'],
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    width: kDefaultPadding / 4,
                                  ),
                                  Text(
                                    studentDetails!['second_name'],
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              Text(
                                '${studentDetails!['branch_name']} | Roll no. ${studentDetails!['roll_number']}',
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
                            title: 'Registration Number',
                            value: studentDetails!['roll_number']),
                        ProfileDetailRow(
                            title: 'Academic Year',
                            value: studentDetails!['academic_year']),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProfileDetailRow(
                            title: 'Admission Class',
                            value: studentDetails!['admission_class']),
                        ProfileDetailRow(
                            title: 'Admission Number',
                            value: studentDetails!['roll_number']),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProfileDetailRow(
                            title: 'Date of Admission',
                            value: studentDetails!['date_of_admission']),
                        ProfileDetailRow(
                            title: 'Date of Birth',
                            value: studentDetails!['date_of_birth']),
                      ],
                    ),
                    ProfileDetailColumn(
                        title: 'Father Name',
                        value: studentDetails!['father_name']),
                    ProfileDetailColumn(
                        title: 'Mother Name',
                        value: studentDetails!['mother_name']),
                    ProfileDetailColumn(
                        title: 'Gender', value: studentDetails!['gender']),
                    ProfileDetailColumn(
                        title: 'Email', value: studentDetails!['email']),
                    ProfileDetailColumn(
                        title: 'Phone Number',
                        value: studentDetails!['phone_number']),
                  ],
                ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({super.key, required this.title, required this.value});

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

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn(
      {super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 15.0,
                      color: kTextLightColor,
                    ),
              ),
              kHalfSizedBox,
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 15.0,
                      color: kTextBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              kHalfSizedBox,
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
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
