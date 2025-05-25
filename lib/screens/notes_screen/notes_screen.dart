import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_platform/constants.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  static String routeName = 'NotesScreen';

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> notesData = {};

  @override
  void initState() {
    super.initState();
    getNotesById(1);
  }

  void getNotesById(int id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/find-notes/$id'));
    if (response.statusCode == 200) {
      setState(() {
        notesData = jsonDecode(response.body);
      });
    } else {
      setState(() {
        notesData = {
          "title1": "Error",
          "content1": "Failed to fetch notes.",
          "title2": "",
          "content2": ""
        };
      });
    }
  }

  void searchNotes(String query) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/find-notes?search=$query'));
    if (response.statusCode == 200) {
      setState(() {
        notesData = jsonDecode(response.body);
      });
    } else {
      setState(() {
        notesData = {
          "title1": "Error",
          "content1": "Notes not found.",
          "title2": "",
          "content2": ""
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: kOtherColor,
          borderRadius: kTopBorderRadius,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        onSubmitted: (value) => searchNotes(value),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      onPressed: () => searchNotes(searchController.text),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesData['title1'] ?? '',
                        style: const TextStyle(fontSize: kDefaultPadding, fontWeight: FontWeight.bold),
                      ),
                      kHalfSizedBox,
                      Text(notesData['content1'] ?? ''),
                      sizedBox,
                      Text(
                        notesData['title2'] ?? '',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      kHalfSizedBox,
                      Text(notesData['content2'] ?? ''),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}