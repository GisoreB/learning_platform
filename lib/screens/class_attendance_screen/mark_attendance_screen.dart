import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MarkAttendanceScreen extends StatelessWidget {
  const MarkAttendanceScreen({super.key});

  static String routeName = 'MarkAttendanceScreen';

  @override
  Widget build(BuildContext context) {
    return const AttendancePage();
  }
}

class Student {
  final String name;
  final String rollNumber;
  bool isPresent;

  Student({
    required this.name,
    required this.rollNumber,
    this.isPresent = false,
  });
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceList();
  }

  void fetchAttendanceList() async {
    List<Map<String, dynamic>> data = await fetchAttendanceDataFromServer();
    setState(() {
      students = data.map((studentData) => Student(
        name: studentData['name'],
        rollNumber: studentData['roll_number'],
        isPresent: studentData['present'],
      )).toList();
    });
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceDataFromServer() async {
    final response = await http.get(
      Uri.parse('${baseURL}attendance-list'),
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
      throw Exception('Failed to Attendance sheet');
    }
  }

  void toggleAttendance(int index) {
    setState(() {
      students[index].isPresent = !students[index].isPresent;
    });
  }

  void submitAttendance() {
    List<Map<String, dynamic>> attendanceData = students.map((student) => {
      "roll_number": student.rollNumber,
      "present": student.isPresent,
    }).toList();
    submitAttendanceToServer(attendanceData);
  }

  Future<void> submitAttendanceToServer(List<Map<String, dynamic>> data) async {
    print(data);
    try {
      final response = await http.post(
        Uri.parse('${baseURL}submit-attendance'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessVerificationToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        final responseData = jsonDecode(response.body);
        final message = responseData['message'] as String;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Submit Attendance'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Submit Attendance'),
          duration: Duration(seconds: 3),
        ),
      );
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
        title: const Text('Student Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: ListView.builder(
          itemCount: students.length,
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
                    color: kTextLightColor,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.account_circle_outlined),
                  kWidthSizedBox,
                  Expanded(
                    flex: 1,
                    child: Text(
                      students[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  Expanded(
                    flex: 1,
                    child: Text(
                      students[index].rollNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  Checkbox(
                    value: students[index].isPresent,
                    onChanged: (value) {
                      toggleAttendance(index);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Submit Attendance'),
            content: const Text('Are You Sure to Submit the Attendance'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  submitAttendance();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ),
        child: const Icon(Icons.check),
      ),
    );
  }
}