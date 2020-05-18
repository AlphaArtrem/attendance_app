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
  StudentEnrollmentAndAttendance _sEAA;
  Map _enrollmentDetails = {};
  Map _enrollmentDetailsVisible = {};
  List _keys = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String userName = '';

  Future setup(FirebaseUser user) async{
    _sEAA = StudentEnrollmentAndAttendance(user);
    _enrollmentDetails = await _sEAA.enrollmentList();
    if(_enrollmentDetails == null){
      _enrollmentDetails = {'error' : {'subject' : "Couldn't load subject list", 'batch' : 'Try Again', 'teacherEmail' : ' '}};
    }
    _enrollmentDetailsVisible = Map.from(_enrollmentDetails)..removeWhere((key, value) => !value['active']);
    _keys = _enrollmentDetailsVisible.keys.toList();

    userName = await UserDataBase(user).userName();
    if(userName == null){
      userName = 'Can\'t Get Name';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(18, 80, 0, 20),
                    color: Colors.cyan,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(userName, style: TextStyle(color: Colors.white, fontSize: 20),),
                        SizedBox(height: 10,),
                        Text(Provider.of<FirebaseUser>(context).email, style: TextStyle(color: Colors.white, fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Enrollment Requests'),
                    onTap: ()  {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/accountSettings');
                    },
                  ),
                  ListTile(
                    title: Text('Account Settings'),
                    onTap: ()  {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/accountSettings');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    )],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(6.5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: authInputFormatting.copyWith(hintText: "Subject, Batch Or Teacher"),
                            onChanged: (val){
                              setState(() {
                                _enrollmentDetailsVisible = Map.from(_enrollmentDetails)..removeWhere((k, v) => !(
                                    (v['subject'].toString().toLowerCase().startsWith(val.toLowerCase()) ||
                                        v['teacherEmail'].toString().toLowerCase().startsWith(val.toLowerCase()) ||
                                        v['batch'].toString().toLowerCase().startsWith(val.toLowerCase())) && v['active']));
                                _keys = _enrollmentDetailsVisible.keys.toList();
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.cyan),
                          onPressed: (){
                            setState(() {
                              _scaffoldKey.currentState.openEndDrawer();
                            });
                          },
                        ),
                        SizedBox(width: 5,),
                      ],
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
      itemCount: _keys.length,
      itemBuilder: (context, index){
        return Card(
          margin: EdgeInsets.symmetric(vertical: 7),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/attendanceList', arguments: {
                  'teacherEmail' :_enrollmentDetailsVisible[_keys[index]]['teacherEmail'] ,
                  'subject': _enrollmentDetailsVisible[_keys[index]]['subject'],
                  'batch' : _enrollmentDetailsVisible[_keys[index]]['batch'],
                  'studentEmail' : Provider.of<FirebaseUser>(context, listen: false).email,
                });
              },
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${_enrollmentDetailsVisible[_keys[index]]['subject']} (${_enrollmentDetailsVisible[_keys[index]]['batch']})', style: TextStyle(color: Colors.cyan),),
                        SizedBox(height: 5,),
                        Text('${_enrollmentDetailsVisible[_keys[index]]['teacherEmail']}', style: TextStyle(fontSize: 10, color: Colors.grey[700]),),
                      ],
                    ),
                  ),
                  Icon(Icons.forward, color: Colors.grey[700],)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
