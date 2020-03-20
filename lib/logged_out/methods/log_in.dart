import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final User _account = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton.icon(
          onPressed: () async{
            dynamic user = await _account.anonymous();
            if(user != null)
              {
                Navigator.of(context).pushReplacementNamed('/student');
              }
          },
          icon: Icon(Icons.account_circle),
          label: Text('Login'),
          elevation: 0,
        ),
      ),
    );
  }
}
