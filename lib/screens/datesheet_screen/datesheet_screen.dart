import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DateSheetScreen extends StatefulWidget {
  const DateSheetScreen({Key? key}) : super(key: key);
  static String routeName = 'DateSheetScreen';

  @override
  _DateSheetScreenState createState() => _DateSheetScreenState();
}

class DateSheet {
  final String date;
  final String day;
  final String subject;
  final String time;

  DateSheet({
    required this.date,
    required this.day,
    required this.subject,
    required this.time,
  });
}

class _DateSheetScreenState extends State<DateSheetScreen> {
  List<DateSheet> _datesheet = [];

  @override
  void initState() {
    super.initState();
    fetchDateSheet();
  }

  Future<void> fetchDateSheet() async {
    List<Map<String, dynamic>> data = await fetchDateSheetFromServer();
    setState(() {
      _datesheet = data
          .map((DateSheetData) => DateSheet(
        date: DateSheetData['date_of_exam'] ?? '',
        day: DateSheetData['day_of_exam'] ?? '',
        subject: DateSheetData['subject'] ?? '',
        time: DateSheetData['time'] ?? '',
      ))
          .toList();
    });
  }

  Future<List<Map<String, dynamic>>> fetchDateSheetFromServer() async {
    final response = await http.get(
      Uri.parse('${baseURL}datesheet'),
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
        title: const Text('DateSheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: ListView.builder(
          itemCount: _datesheet.length,
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
                  const Icon(Icons.pending_actions_outlined),
                  kHalfWidthSizedBox,
                  Expanded(
                    flex: 1,
                    child: Text(
                      _datesheet[index].date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kHalfWidthSizedBox,
                  Expanded(
                    flex: 2,
                    child: Text(
                      _datesheet[index].day,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kHalfWidthSizedBox,
                  Expanded(
                    flex: 2,
                    child: Text(
                      _datesheet[index].subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kHalfWidthSizedBox,
                  Expanded(
                    flex: 1,
                    child: Text(
                      _datesheet[index].time,
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