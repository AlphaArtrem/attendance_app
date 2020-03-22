import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final User _account = User();
  final _formKey = GlobalKey<FormState>();

  String email;
  String pass;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: textInputFormatting.copyWith(helperText: "Enter Email"),
                validator: _account.validateId,
                onChanged: (val){
                  email = val;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: textInputFormatting.copyWith(helperText: "Enter Password"),
                validator: _account.validateLoginPass,
                obscureText: true,
                onChanged: (val){
                  pass = val;
                },
              ),
              SizedBox(height: 25,),
              RaisedButton.icon(
                onPressed: () async{
                  if(_formKey.currentState.validate())
                    {
                      dynamic user = await _account.login(email, pass);
                      if(user != null)
                      {
                        Navigator.of(context).pushReplacementNamed('/student');
                      }
                      else
                        {
                          setState(() {
                            error = 'Email and/or password is incorrect';
                          });
                        }
                    }
                },
                icon: Icon(Icons.person),
                label: Text('Log In'),
                elevation: 0,
              ),
              SizedBox(height: 50,),
              Text(error, style: TextStyle(color: Colors.red),)
            ],
          ),
        ),
      ),
    );
  }
}
