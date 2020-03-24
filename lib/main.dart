import 'package:attendanceapp/logged_in/home.dart';
import 'package:attendanceapp/logged_in/student/student.dart';
import 'package:attendanceapp/logged_out/methods/register.dart';
import 'package:flutter/material.dart';
import 'package:attendanceapp/logged_out/authentication.dart';
import 'package:attendanceapp/logged_out/methods/log_in.dart';
import 'package:provider/provider.dart';
import 'package:attendanceapp/classes/account.dart';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<String>.value(
      value: User().account,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance App ',
        home: Authentication(),
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/student' : (context) => Student(),
          '/home' : (context) => Home(),
          '/authentication': (context) => Authentication(),
        },
      ),
    );
  }
}

