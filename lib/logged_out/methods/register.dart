import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final User _account = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                    Navigator.of(context).pushReplacementNamed('/attendance');
                  }
                },
                icon: Icon(Icons.person),
                label: Text('Register'),
                elevation: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
