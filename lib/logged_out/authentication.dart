import 'package:attendanceapp/logged_out/methods/log_in.dart';
import 'package:attendanceapp/logged_out/methods/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _register = false;
  double _height = 170;
  double _width = 20;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: _width, vertical: _height),
            child: Card(
              child: Column(
                children: <Widget>[
                  _register ? Register() : Login(),
                  otherMethod(),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget otherMethod()
  {
    if(_register)
      {
        return RaisedButton.icon(
            icon: Icon(Icons.person, color: Colors.white, size: 15,),
            label: Text(
              'Log In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            elevation: 0,
            color: Colors.lightBlue,
            onPressed: (){
              setState(() {
                _register = false;
                _height = 170;
                _width = 20;
              });
            }
        );
      }
    else
      {
        return RaisedButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white, size: 15),
            label: Text(
              ' Register',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            elevation: 0,
            color: Colors.lightBlue,
            onPressed: (){
              setState(() {
                _register = true;
                _height = 80;
                _width = 20;
              });
            }
        );
      }
  }
}
