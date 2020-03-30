import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrolledStudents extends StatefulWidget {
  @override
  _EnrolledStudentsState createState() => _EnrolledStudentsState();
}

class _EnrolledStudentsState extends State<EnrolledStudents> {
  TeacherSubjectsAndBatches _tSAB;
  List<String> students = [];
  String subject = '';
  String batch = '';
  final _formKey = GlobalKey<FormState>();
  bool add = false;
  UserDataBase _users;
  List<String> allStudents = [];

  Future setup(FirebaseUser user, String sub, String batchCopy) async {
    _tSAB = TeacherSubjectsAndBatches(user);
    _users = UserDataBase(user);
    allStudents = await _users.getAllStudents();
    print(allStudents);
    students = await _tSAB.getStudents(sub, batchCopy);
    if (students == null) {
      students = ["Couldn't get students, try again"];
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute
        .of(context)
        .settings
        .arguments;
    subject = data['subject'];
    batch = data['batch'];
    return Scaffold(
      appBar: AppBar(
        title: batch.isEmpty && subject.isEmpty ? Text('Students',) : Text(
          '$subject - $batch',),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              dynamic result = await User().signOut();
              if (result == null) {
                Navigator.of(context).pushReplacementNamed('/authentication');
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: setup(Provider.of<FirebaseUser>(context), subject, batch),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return students.isEmpty ? LoadingData() : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  add == true ? Expanded(flex : 1, child: Card(child: addStudentForm(),)) : Card(child: addStudentButton(),),
                  SizedBox(height: 10,),
                  students[0] == 'Empty' ? Text('You Need To Add Students',
                    style: TextStyle(color: Colors.red),) : Expanded(
                    flex : 1,
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                              onTap: () {},
                              title: Text('${students[index]}'),
                            )
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }

  Widget addStudentButton() {
    return ListTile(
      onTap: () {
        setState(() {
          add = true;
        });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add),
          SizedBox(width: 10,),
          Text('Add A Student')
        ],
      ),
    );
  }

  Widget addStudentForm(){
    List<String> filteredStudents = allStudents;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 2),
              child: TextFormField(
                decoration: textInputFormatting.copyWith(hintText: 'Search Student By Email'),
                onChanged: (val) => filteredStudents = allStudents.where((student) => student.toLowerCase().contains(val.toLowerCase())),
              ),
            ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  onTap: (){},
                  title: Text('${filteredStudents[index]}'),
                ),
              );
            },
            itemCount: filteredStudents.length,),
        )
      ],
    );
  }
}