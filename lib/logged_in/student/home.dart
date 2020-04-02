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
      body: EnhancedFutureBuilder(
        future: setup(Provider.of<FirebaseUser>(context)),
        rememberFutureResult: false,
        whenNotDone: LoadingScreen(),
        whenDone: (arg) => enrollmentList(),
      )
    );
  }
  Widget enrollmentList(){
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            onTap: (){},
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
