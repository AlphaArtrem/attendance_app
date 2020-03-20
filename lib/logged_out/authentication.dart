import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Authentication'
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              onPressed: (){},
              icon: Icon(Icons.account_circle),
              label: Text('Login'),
              elevation: 0,
            ),
            RaisedButton.icon(
              onPressed: (){},
              icon: Icon(Icons.person_add),
              label: Text('Register'),
              elevation: 0,
            )
          ],
        ),
      ),
    );
  }
}
