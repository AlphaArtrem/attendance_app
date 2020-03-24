import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/logged_in/student/student.dart';
import 'package:attendanceapp/logged_in/teacher/batches.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    dynamic type = ModalRoute.of(context).settings.arguments;
    Widget homeScreen = type == "Student" ? Student() : Batches();
    return StreamProvider<QuerySnapshot>.value(
        value: UserDataBase(Provider.of<String>(context)).userData,
        child: homeScreen,
    );
  }
}
