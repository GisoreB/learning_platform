import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({Key? key}) : super(key: key);
  static String routeName = 'HolidayScreen';

  @override
  _HolidayScreenState createState() => _HolidayScreenState();
}

class HolidayList {
  final String date;
  final String day;
  final String holidayName;

  HolidayList({
    required this.date,
    required this.day,
    required this.holidayName,
  });
}

class _HolidayScreenState extends State<HolidayScreen> {
  List<HolidayList> _holidayList = [];

  @override
  void initState() {
    super.initState();
    fetchHolidayList();
  }

  Future<void> fetchHolidayList() async {
    List<Map<String, dynamic>> data = await fetchHolidaysDataFromServer();
    setState(() {
      _holidayList = data.map((holidayData) => HolidayList(
        date: holidayData['date'],
        day: holidayData['day'],
        holidayName: holidayData['name'],
      )).toList();
    });
  }

  Future<List<Map<String, dynamic>>> fetchHolidaysDataFromServer() async {
    final response = await http.get(
      Uri.parse('${baseURL}holidays'),
      headers: {
        'Content-Type': 'application/json',
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
        title: const Text('List of Holidays'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: ListView.builder(
          itemCount: _holidayList.length,
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
                  const Icon(Icons.holiday_village_rounded),
                  kWidthSizedBox,
                  Expanded(
                    flex: 3,
                    child: Text(
                      _holidayList[index].date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  Expanded(
                    flex: 3,
                    child: Text(
                      _holidayList[index].day,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kWidthSizedBox,
                  Expanded(
                    flex: 3,
                    child: Text(
                      _holidayList[index].holidayName,
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
