import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
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

  String email;
  String pass;
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context){
    return loading ? LoadingScreen() : Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          children: <Widget>[
            Text(error, style: TextStyle(color: Colors.red),),
            SizedBox(height: 30,),
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
            SizedBox(height: 30,),
            RaisedButton.icon(
              onPressed: () async{
                if(_formKey.currentState.validate())
                {
                  setState(() => loading = true);
                  FirebaseUser user = await _account.login(email, pass);
                  if(user != null)
                  {
                    dynamic type = await UserDataBase(user).userType();
                    Navigator.of(context).pushReplacementNamed('/home', arguments: type);
                  }
                  else
                  {
                    setState(() {
                      loading = false;
                      error = 'Email and/or password is incorrect';
                    });
                  }
                }
              },
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text(
                'Log In',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
              elevation: 0,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
