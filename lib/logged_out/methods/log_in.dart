import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/logged_out/methods/register.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final User _account = User();
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _pass;
  String _error = '';
  bool _loading = false;
  bool _toLogin = true;

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        _toLogin ? loginForm() : Register(),
      ],
    );
  }

  Widget loginForm(){
    return _loading ? AuthLoading(135, 20) : Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 45, 0, 5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                  color: Color.fromRGBO(51, 204, 255, 0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200]))
                    ),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(hintText: "Enter Email"),
                      validator: _account.validateId,
                      onChanged: (val){
                        _email = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200]))
                    ),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(hintText: "Enter Password"),
                      validator: _account.validateLoginPass,
                      obscureText: true,
                      onChanged: (val){
                        _pass = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text(_error, style: TextStyle(color: Colors.red),),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () async{
                if(_formKey.currentState.validate())
                {
                  setState(() => _loading = true);
                  FirebaseUser user = await _account.login(_email, _pass);
                  if(user != null)
                  {
                    dynamic type = await UserDataBase(user).userType();
                    Navigator.of(context).pushReplacementNamed('/home', arguments: type);
                  }
                  else
                  {
                    setState(() {
                      _loading = false;
                      _error = 'Email and/or password is incorrect';
                    });
                  }
                }
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromRGBO(51, 204, 255, 1),
                ),
                child: Center(
                  child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 17),),
                ),
              ),
            ),
            SizedBox(height : 30),
          ],
        ),
      ),
    );
  }
}
