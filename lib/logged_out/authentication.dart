import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                icon: Icon(Icons.account_circle),
                label: Text('  Log In  '),
                elevation: 0,
              ),
              RaisedButton.icon(
                onPressed: (){},
                icon: Icon(Icons.person_add),
                label: Text('Register'),
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
