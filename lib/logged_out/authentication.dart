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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: (){
                  Navigator.of(context).pushNamed('/login');
                },
                icon: Icon(Icons.account_circle, color: Colors.blue, size: 35),
                label: Text(
                  '   Log In   ',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                elevation: 0,
                color: Colors.white,
              ),
              RaisedButton.icon(
                icon: Icon(Icons.person_add, color: Colors.blue, size: 35),
                label: Text(
                  '  Register',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                elevation: 0,
                color: Colors.white,
                onPressed: (){
                  Navigator.of(context).pushNamed('/register');
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
