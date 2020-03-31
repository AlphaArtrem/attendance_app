import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  bool loading = false;
  List<String> subjects = [];
  List<String> batches = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home - Student'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async{
              setState(() {
                loading = true;
              });
              dynamic result = await User().signOut();
              if(result == null)
              {
                Navigator.of(context).pushReplacementNamed('/authentication');
              }
            },
          )
        ],
      ),
      body: Center(
        child: subjects.isEmpty ? Text('You are not enrolled with any teacher') : ListView.builder(
        itemCount: subjects.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                onTap: (){},
                title: Text('${subjects[index]} ( ${batches[index]} )'),
              )
            );
          }
        ),
      ),
    );
  }
}
