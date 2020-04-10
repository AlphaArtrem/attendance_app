import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  bool loading = false;
  StudentEnrollmentAndAttendance _sEAA;
  Map enrollmentDetails = {};
  List keys = [];

  Future setup(FirebaseUser user) async{
    _sEAA = StudentEnrollmentAndAttendance(user);
    enrollmentDetails = await _sEAA.enrollmentList();
    if(enrollmentDetails == null){
      enrollmentDetails = {'error' : {'subject' : "Couldn't load subject list", 'batch' : 'Try Again', 'teacherEmail' : ' '}};
    }
    keys = enrollmentDetails.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                child: Container(
                  padding: EdgeInsets.fromLTRB(45,70, 30, 50),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)
                    )
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text('Subjects', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)),
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
              )
            ],
          ),
          Expanded(
            child: Container(
              child: EnhancedFutureBuilder(
                future: setup(Provider.of<FirebaseUser>(context)),
                rememberFutureResult: false,
                whenNotDone: LoadingScreen(),
                whenDone: (arg) => enrollmentList(),
              ),
            ),
          ),
        ],
      )
    );
  }
  Widget enrollmentList(){
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/attendanceList', arguments: {
                'teacherEmail' :enrollmentDetails[keys[index]]['teacherEmail'] ,
                'subject': enrollmentDetails[keys[index]]['subject'],
                'batch' : enrollmentDetails[keys[index]]['batch'],
                'studentEmail' : Provider.of<FirebaseUser>(context, listen: false).email,
              });
            },
            title: Column(
              children: <Widget>[
                Text('${enrollmentDetails[keys[index]]['subject']} (${enrollmentDetails[keys[index]]['batch']})'),
                SizedBox(height: 5,),
                Text('${enrollmentDetails[keys[index]]['teacherEmail']}', style: TextStyle(fontSize: 10, color: Colors.grey[700]),),
              ],
            ),
          ),
        );
      },
    );
  }
}
