import 'dart:ui';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStudents extends StatefulWidget {
  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  List<String> _filteredStudents, _enrolledStudents;
  List<String> _allStudents = [];
  String _message = ' ';
  String _batch, _subject;
  final StudentsList _allStudentsInstance = StudentsList();
  TeacherSubjectsAndBatches _tSAB;

  Future setup(FirebaseUser user) async{
    _tSAB = TeacherSubjectsAndBatches(user);
    _allStudents = await _allStudentsInstance.getAllStudents();
    _allStudents = _allStudents.where((student) => !_enrolledStudents.contains(student)).toList();
    _filteredStudents = _allStudents;
  }

  @override
  Widget build(BuildContext context){
    Map data = ModalRoute.of(context).settings.arguments;
    _enrolledStudents = data['enrolledStudents'];
    _batch = data['batch'];
    _subject = data['subject'];
    return EnhancedFutureBuilder(
      future: setup(Provider.of<FirebaseUser>(context)),
      rememberFutureResult: true,
      whenNotDone: LoadingScreen(),
      whenDone: (arg) => addStudents(),
    );
  }
  Widget addStudents(){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                  color: Color.fromRGBO(51, 204, 255, 0.3),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )],
              ),
              child: Container(
                padding: EdgeInsets.all(6.5),
                child: Row(
                  children: <Widget>[
                    BackButton(color: Colors.grey[700],),
                    Expanded(
                      child: TextFormField(
                        decoration: authInputFormatting.copyWith(hintText: "Search Student By Email"),
                        onChanged: (val){
                          setState(() {
                            _filteredStudents = _allStudents.where((student) => student.toLowerCase().contains(val.toLowerCase())).toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: Text(_message, style: TextStyle(color: Colors.red),)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: ListView.builder(
                  itemBuilder: (context, index){
                    return Card(
                      elevation: 1,
                      child: Container(
                        padding: EdgeInsets.all(6.5),
                        child: ListTile(
                          onTap: () async{
                            String added = _filteredStudents[index];
                            dynamic result = await _tSAB.addStudent(_subject, _batch, added);
                            if(result == 'Success'){
                              setState(() {
                                _enrolledStudents.add(added);
                                _filteredStudents.remove(added);
                                Navigator.pop(context, {'studentAdded' : added,});
                              });
                            }
                            else{
                              setState(() {
                                _message = "Something Went Wrong Couldn't Add Student";
                              });
                            }
                          },
                          title: Row(
                            children: <Widget>[
                              Expanded(child: Text('${_filteredStudents[index]}', style: TextStyle(color: Colors.cyan),)),
                              Icon(Icons.add_circle_outline, color: Colors.blueGrey,)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _filteredStudents.length,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
