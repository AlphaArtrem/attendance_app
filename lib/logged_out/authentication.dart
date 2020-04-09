import 'package:attendanceapp/logged_out/methods/log_in.dart';
import 'package:attendanceapp/logged_out/methods/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> with SingleTickerProviderStateMixin{
  bool _login = true;

  _updateTitle(bool login){
    setState(() => _login = login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [
                  Colors.blue[900],
                  Colors.blue[400],
                  Colors.blue[200]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 70, 15, 0),
              child: Text('${_login ? 'Login.' : 'Register.'}', style: TextStyle(color: Colors.white, fontSize: 50, letterSpacing: 2, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 0, 15, 0),
              child: Text('${_login ? 'Welcome Back.' : 'Good to see you here.'}', style: TextStyle(color: Colors.white, fontSize: 22,),),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50), topRight: Radius.circular(50))
                ),
                child: ListView(
                  children: <Widget>[
                    _login ? Login(_updateTitle) : Register(_updateTitle),
                    SizedBox(height: 50,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}