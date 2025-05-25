import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static String routeName = 'ResultScreen';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class ResultDetailCard{
  final String roll_no;
  final String subject_name;
  final double c1;
  final double c2;
  final double c3;
  final double total;
  final String gpa;
  final String credits;

  const ResultDetailCard({
    Key? key,
    required this.roll_no,
    required this.subject_name,
    required this.c1,
    required this.c2,
    required this.c3,
    required this.total,
    required this.gpa,
    required this.credits,
  });
}

class _ResultScreenState extends State<ResultScreen> {
  List<ResultDetailCard> _resultdetails = [];

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    List<Map<String, dynamic>> data = await getResultDataFromServer();
    setState(() {
      _resultdetails = data
          .map((ResultData) => ResultDetailCard(
        roll_no: ResultData['roll_no'] ?? '',
        subject_name: ResultData['subject_name'] ?? '',
        c1: double.parse(ResultData['c1'].toString()) ?? 0.0,
        c2: double.parse(ResultData['c2'].toString()) ?? 0.0,
        c3: double.parse(ResultData['c3'].toString()) ?? 0.0,
        total: double.parse(ResultData['total'].toString()) ?? 0.0,
        gpa: ResultData['gpa'] ?? '',
        credits: ResultData['credits'] ?? '',
      ))
          .toList();
    });
  }

  Future<List<Map<String, dynamic>>> getResultDataFromServer() async {
    final response = await http.get(
      Uri.parse('${baseURL}results'),
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
      throw Exception('Failed to load Result data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Score'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: kOtherColor,
                borderRadius: kTopBorderRadius,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(kDefaultPadding),
                itemCount: _resultdetails.length,
                itemBuilder: (context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                          color: kOtherColor,
                          boxShadow: const [
                            BoxShadow(
                              color: kTextLightColor,
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _resultdetails[index].subject_name,
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            kHalfSizedBox,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ResultDetailColumn(
                                  title: 'C1',
                                  statusValue: '${_resultdetails[index].c1}',
                                ),
                                kHalfSizedBox,
                                ResultDetailColumn(
                                  title: 'C2',
                                  statusValue: '${_resultdetails[index].c2}',
                                ),
                                kHalfSizedBox,
                                ResultDetailColumn(
                                  title: 'C3',
                                  statusValue: '${_resultdetails[index].c3}',
                                ),
                                kHalfSizedBox,
                                ResultDetailColumn(
                                  title: 'Total',
                                  statusValue: '${_resultdetails[index].total}',
                                ),
                              ],
                            ),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ResultDetailRow(
                                  title: 'GPA:',
                                  statusValue: _resultdetails[index].gpa,
                                ),
                                ResultDetailRow(
                                  title: 'Credits:',
                                  statusValue: _resultdetails[index].credits,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      sizedBox,
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultDetailColumn extends StatelessWidget {
  const ResultDetailColumn(
      {Key? key, required this.title, required this.statusValue})
      : super(key: key);

  final String title;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        Text(
          statusValue,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: kTextBlackColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class ResultDetailRow extends StatelessWidget {
  const ResultDetailRow(
      {Key? key, required this.title, required this.statusValue})
      : super(key: key);

  final String title;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.greenAccent, fontWeight: FontWeight.bold),
        ),
        kHalfWidthSizedBox,
        Text(
          statusValue,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: kTextBlackColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}