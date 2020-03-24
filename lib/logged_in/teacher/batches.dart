import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Batches extends StatefulWidget {
  @override
  _BatchesState createState() => _BatchesState();
}

class _BatchesState extends State<Batches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home - Teacher'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async{
              dynamic result = await User().signOut();
              if(result == null)
              {

                Navigator.of(context).pushReplacementNamed('/authentication');
              }
              else
              {
                print(result);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Text('${Provider.of<String>(context)}'),
      ),
    );
  }
}

