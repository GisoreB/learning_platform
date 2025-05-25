import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);
  static String routeName = 'AttendanceScreen';

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class AttendanceDetailCard{
  final String subject;
  final int totalDays;
  final int presentDays;
  final double percentageAttendance;

  const AttendanceDetailCard({
    Key? key,
    required this.subject,
    required this.totalDays,
    required this.presentDays,
    required this.percentageAttendance,
  });
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceDetailCard> _attendancedetails = [];

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    List<Map<String, dynamic>> data = await getAttendanceDataFromServer();
    setState(() {
      _attendancedetails = data
          .map((AttendanceData) => AttendanceDetailCard(
        subject: AttendanceData['subject'] ?? '',
        totalDays: AttendanceData['total_days'] ?? '',
        presentDays: AttendanceData['present_days'] ?? '',
        percentageAttendance: AttendanceData['percentage_attendance'] ?? '',
      ))
          .toList();
    });
  }

  Future<List<Map<String, dynamic>>> getAttendanceDataFromServer() async {
    final response = await http.get(
      Uri.parse('${baseURL}student-attendance'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessVerificationToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    else {
      throw Exception('Failed to load Attendance data');
    }
  }

  final List<Color> rowColors = [
    Colors.grey[200]!,
    Colors.blue[50]!,
    Colors.green[50]!,
    Colors.orange[50]!,
    Colors.pink[50]!,
    Colors.purple[50]!,
    Colors.yellow[50]!,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: ListView.builder(
          itemCount: _attendancedetails.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final Random random = Random();
            final Color color = rowColors[random.nextInt(rowColors.length)];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(kDefaultPadding / 1.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: kTextBlackColor,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _attendancedetails[index].subject,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: kTextBlackColor, fontWeight: FontWeight.w400),
                    ),
                    sizedBox,
                    Text(
                      'Total Days: ${_attendancedetails[index].totalDays},',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kTextBlackColor, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Present Days: ${_attendancedetails[index].presentDays}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kTextBlackColor, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Attendance Percentage: ${_attendancedetails[index].percentageAttendance}%',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: kTextBlackColor, fontWeight: FontWeight.w400),
                    ),
                  ],
                )
            );
          },
        ),
      ),
    );
  }
}