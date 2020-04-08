import 'package:attendanceapp/logged_out/methods/log_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [
                  Colors.blue[800],
                  Colors.blue[400],
                  Colors.blue[200]
                ]
            )
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Login(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}