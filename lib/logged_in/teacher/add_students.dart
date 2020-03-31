import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStudents extends StatefulWidget {
  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  final _formKey = GlobalKey<FormState>();
  List<String> filteredStudents, enrolledStudents;
  List<String> allStudents = [];
  String message = ' ';
  String batch, subject;
  MaterialColor messageColor;
  final StudentsList _allStudents = StudentsList();
  TeacherSubjectsAndBatches _tSAB;

  Future setup(FirebaseUser user) async{
    _tSAB = TeacherSubjectsAndBatches(user);
    allStudents = await _allStudents.getAllStudents();
  }

  @override
  Widget build(BuildContext context){
    Map data = ModalRoute.of(context).settings.arguments;
    enrolledStudents = data['enrolledStudents'];
    allStudents = allStudents.where((student) => !enrolledStudents.contains(student)).toList();
    filteredStudents = allStudents;
    batch = data['batch'];
    subject = data['subject'];
    return FutureBuilder(
      future: setup(Provider.of<FirebaseUser>(context)),
      builder: (context, snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Students',),
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
          body: allStudents.isEmpty ? LoadingScreen() : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(message, style: TextStyle(color: messageColor),),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 2),
                  child: TextFormField(
                    decoration: textInputFormatting.copyWith(hintText: 'Search Student By Email'),
                    onChanged: (val){
                      setState(() {
                        filteredStudents = allStudents.where((student) => student.toLowerCase().contains(val.toLowerCase())).toList();
                        print(filteredStudents);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
                  child: ListView.builder(
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          onTap: () async{
                            if(enrolledStudents.contains(filteredStudents[index])){
                              setState(() {
                                message = 'Student Already Present';
                                messageColor = Colors.red;
                              });
                            }
                            else{
                              dynamic result = await _tSAB.addStudent(subject, batch, filteredStudents[index]);
                              if(result == 'Success'){
                                setState(() {
                                  enrolledStudents.add(filteredStudents[index]);
                                  filteredStudents.remove(filteredStudents[index]);
                                  message = "Student Added Succesfully";
                                  messageColor = Colors.green;
                                });
                              }
                              else{
                                setState(() {
                                  message = "Something Went Wrong Couldn't Add Student";
                                  messageColor = Colors.red;
                                });
                              }
                            }
                          },
                          title: Text('${filteredStudents[index]}'),
                        ),
                      );
                    },
                    itemCount: filteredStudents.length,),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
