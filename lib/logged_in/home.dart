import 'package:attendanceapp/logged_in/student/home.dart';
import 'package:attendanceapp/logged_in/teacher/home.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    String type = ModalRoute.of(context).settings.arguments;
    Widget homeScreen;
    homeScreen = type == 'Student' ? StudentHome() : TeacherHome();
    return homeScreen;
  }
}
