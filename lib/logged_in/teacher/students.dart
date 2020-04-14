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
  List<String> allStudents = [];

  Future setup(FirebaseUser user, String sub, String batchCopy) async {
    _tSAB = TeacherSubjectsAndBatches(user);
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
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 60, 30, 50),
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)
                        )
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Students', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: FlatButton.icon(
                            label: Text('Log Out', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                            icon: Icon(Icons.exit_to_app, color: Colors.cyan, size: 15,),
                            onPressed: () async {
                              dynamic result = await User().signOut();
                              if (result == null) {
                                Navigator.of(context).pushReplacementNamed('/authentication');
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 130, 40, 20),
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
                      child: TextFormField(
                        decoration: authInputFormatting.copyWith(hintText: "Search By ID"),
                        onChanged: (val){
                          setState(() {
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: FutureBuilder(
                    future: setup(Provider.of<FirebaseUser>(context), subject, batch),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return students.isEmpty ? LoadingData() : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            addStudentButton(),
                            SizedBox(height: 10,),
                            students[0] == 'Empty' ? Expanded(
                              child: Text('You Need To Add Students',
                                style: TextStyle(color: Colors.red),),
                            ) : Expanded(
                              child: ListView.builder(
                                itemCount: students.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/attendanceList', arguments: {
                                            'teacherEmail' : Provider.of<FirebaseUser>(context, listen: false).email ,
                                            'subject': subject,
                                            'batch' : batch,
                                            'studentEmail' : students[index],
                                          });
                                        },
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
              ),
            ),
          ],
        )
    );
  }

  Widget addStudentButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap:() async{
              dynamic data = await Navigator.pushNamed(context, '/addStudents', arguments: {'enrolledStudents' : students, 'batch' : batch, 'subject': subject});
              if(data != null) {
                setState(() {
                  students = data['enrolledStudents'];
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 25,),
                  SizedBox(width: 5,) ,
                  Text('Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: GestureDetector(
            onTap:() async{
              await Navigator.pushNamed(context, '/updateAttendance', arguments: {'enrolledStudents' : students, 'subject' : subject, 'batch' : batch});
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 25,),
                  SizedBox(width: 5,) ,
                  Text('Attendance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}