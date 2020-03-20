import 'package:flutter/material.dart';
import 'package:attendanceapp/logged_out/authentication.dart';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance AsupportedLocales: ',
      home: Authentication(),
    );
  }
}

