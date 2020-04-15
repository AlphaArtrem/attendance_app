import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';

class AttendanceList extends StatefulWidget {
  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final GetAttendance _attendance = GetAttendance();

  Map _attendanceList = {};
  Map _attendanceListVisible ={};

  Future setup(String teacherEmail, String subject, String batch, String studentEmail) async{
    _attendanceList = await _attendance.getAttendance(teacherEmail, subject, batch, studentEmail);
    _attendanceListVisible = _attendanceList;
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 60, 30, 50),
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)
                        )
                    ),
                    child: Row(
                      children: <Widget>[
                        BackButton(color: Colors.white70,),
                        Expanded(child: Text('Attendance', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)),
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
                        decoration: authInputFormatting.copyWith(hintText: "Search By Date or Time"),
                        onChanged: (val){
                          setState(() {
                            _attendanceListVisible = Map.from(_attendanceList)..removeWhere((k, v) => !k.toString().contains(val));
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
                child: EnhancedFutureBuilder(
                  future: setup(data['teacherEmail'], data['subject'], data['batch'], data['studentEmail']),
                  rememberFutureResult: true,
                  whenNotDone: LoadingScreen(),
                  whenDone: (arg) => showAttendance(),
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget showAttendance(){
    if(_attendanceList == null) {
      return Center(
        child: Text('No Attendance Found !', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 20),),
      );
    }
    else{
      List time = _attendanceListVisible.keys.toList();
      return Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Row(
                  children: <Widget>[
                    Expanded(flex : 3, child: Text('Date', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 16),),),
                    Expanded(flex : 3, child: Text('Time', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 16))),
                    Expanded(flex : 1, child: Text('A/P', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: time.length,
                itemBuilder: (context, index){
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex : 3,child: Text('${time[index].substring(0,10)}', style: TextStyle(color: Colors.cyan,))),
                          Expanded(flex : 3,child: Text('${time[index].substring(12,21)} \n ${time[index].substring(24,(time[index].length))}', style: TextStyle(color: Colors.grey[500]))),
                          Expanded(flex : 1,child: _attendanceList[time[index]] ? Icon(Icons.check_circle_outline, color: Colors.green,) : Icon(Icons.check_circle_outline, color: Colors.red,),),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
