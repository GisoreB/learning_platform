import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);
  static String routeName = 'TimeTableScreen';

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class TimeTable {
  final String day;
  final String subject;
  final String time;

  TimeTable({
    required this.day,
    required this.subject,
    required this.time
  });
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  List<TimeTable> _timetable = [];

  @override
  void initState() {
    super.initState();
    fetchTimeTable();
  }

  Future<void> fetchTimeTable() async {
    List<Map<String, dynamic>> data = await fetchTimeTableFromServer();
    setState(() {
      _timetable = data.map((TimeTableData) => TimeTable(
          day: TimeTableData['day'],
          subject: TimeTableData['subject'],
          time: TimeTableData['time']
      )).toList();
    });
  }

  Future<List<Map<String, dynamic>>> fetchTimeTableFromServer() async {
    final response = await http.get(
      Uri.parse('${baseURL}timetable'),
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
      throw Exception('Failed to load date sheet');
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
        title: const Text('Class Timetable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: ListView.builder(
          itemCount: _timetable.length,
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
                children: [
                  const Icon(Icons.timelapse),
                  kWidthSizedBox,
                  Expanded(
                    flex: 1,
                    child: Text(
                      _timetable[index].day,
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
                      _timetable[index].subject,
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
                      _timetable[index].time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
