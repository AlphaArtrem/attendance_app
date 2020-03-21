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
      body: Form(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                onChanged: (id){

                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                onChanged: (pass){

                },
              ),
              SizedBox(height: 25,),
              RaisedButton.icon(
                onPressed: () async{
                  dynamic user = _account.anonymous();
                  if(user != null)
                    {
                      Navigator.of(context).pushReplacementNamed('/student');
                    }
                },
                icon: Icon(Icons.person),
                label: Text('Log In'),
                elevation: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
