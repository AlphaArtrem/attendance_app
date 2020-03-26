import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
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
      body: Subjects(Provider.of<String>(context)),
    );
  }
}

class Subjects extends StatefulWidget {
  final String uid;
  Subjects(this.uid);
  @override
  _SubjectsState createState() => _SubjectsState(uid);
}

class _SubjectsState extends State<Subjects> {
  final String uid;
  _SubjectsState(this.uid);
  dynamic subjects;

  setup() async{
    TeacherSubjectsAndBatches tSAB = TeacherSubjectsAndBatches(uid);
    subjects = await tSAB.getSubjectsAndBatches();
  }

  @override
  void initState()
  {
    super.initState();
    setup();
    print("B : $subjects");
  }
  @override
  Widget build(BuildContext context) {
    print(subjects);
    return Center(
      child: subjects == null? Text('No subjects added') : ListView.builder(
        itemCount: subjects.keys.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              onTap: (){

              },
              title: Padding(
                padding: EdgeInsets.all(10),
                child: Text('${subjects.keys[index].toUpperCase()}'),
              ),
            ),
          );
        },
      ),
    );
  }
}


