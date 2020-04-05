import 'package:attendanceapp/logged_out/methods/log_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _login = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 140),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Login(),
              otherMethod(),
            ],
          ),
        ),
      ),
    );
  }
  Widget otherMethod()
  {
    if(_login)
      {
        return RaisedButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white, size: 25),
            label: Text(
              '  Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            elevation: 0,
            color: Colors.blue,
            onPressed: (){
              setState(() {
                _login = false;
              });
            }
        );
      }
    else
      {
        return RaisedButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white, size: 25),
            label: Text(
              '  Register',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            elevation: 0,
            color: Colors.blue,
            onPressed: (){
              Navigator.pushNamed(context, '/register');
            }
        );
      }
  }
}
