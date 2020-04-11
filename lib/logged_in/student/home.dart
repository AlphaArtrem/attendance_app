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
  Map enrollmentDetailsVisible = {};
  List keys = [];

  Future setup(FirebaseUser user) async{
    _sEAA = StudentEnrollmentAndAttendance(user);
    enrollmentDetails = await _sEAA.enrollmentList();
    if(enrollmentDetails == null){
      enrollmentDetails = {'error' : {'subject' : "Couldn't load subject list", 'batch' : 'Try Again', 'teacherEmail' : ' '}};
    }
    enrollmentDetailsVisible = enrollmentDetails;
    keys = enrollmentDetailsVisible.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  margin: EdgeInsets.fromLTRB(40, 130, 40, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      color: Color.fromRGBO(51, 204, 255, 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(6.5),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(hintText: "Search...."),
                      onChanged: (val){
                        setState(() {
                          enrollmentDetailsVisible = Map.from(enrollmentDetails)..removeWhere((k, v) => !(
                              v['subject'].toString().toLowerCase().startsWith(val.toLowerCase()) ||
                                  v['teacherEmail'].toString().toLowerCase().startsWith(val.toLowerCase()) ||
                                  v['batch'].toString().toLowerCase().startsWith(val.toLowerCase())));
                          keys = enrollmentDetailsVisible.keys.toList();
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
              color: Colors.white,
              child: EnhancedFutureBuilder(
                future: setup(Provider.of<FirebaseUser>(context)),
                rememberFutureResult: true,
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
          elevation: 2,
          child: ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/attendanceList', arguments: {
                'teacherEmail' :enrollmentDetailsVisible[keys[index]]['teacherEmail'] ,
                'subject': enrollmentDetailsVisible[keys[index]]['subject'],
                'batch' : enrollmentDetailsVisible[keys[index]]['batch'],
                'studentEmail' : Provider.of<FirebaseUser>(context, listen: false).email,
              });
            },
            title: Column(
              children: <Widget>[
                Text('${enrollmentDetailsVisible[keys[index]]['subject']} (${enrollmentDetailsVisible[keys[index]]['batch']})'),
                SizedBox(height: 5,),
                Text('${enrollmentDetailsVisible[keys[index]]['teacherEmail']}', style: TextStyle(fontSize: 10, color: Colors.grey[700]),),
              ],
            ),
          ),
        );
      },
    );
  }
}
