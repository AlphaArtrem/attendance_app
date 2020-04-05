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

  Future setup(String teacherEmail, String subject, String batch, String studentEmail) async{
    _attendanceList = await _attendance.getAttendance(teacherEmail, subject, batch, studentEmail);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
      ),
      body: EnhancedFutureBuilder(
        future: setup(data['teacherEmail'], data['subject'], data['batch'], data['studentEmail']),
        rememberFutureResult: true,
        whenNotDone: LoadingScreen(),
        whenDone: (arg) => showAttendance(),
      ),
    );
  }

  Widget showAttendance(){
    if(_attendanceList == null) {
      return Center(
        child: Text('No Attendance Found'),
      );
    }
    else{
      List<String> time = _attendanceList.keys.toList();
      return Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  children: <Widget>[
                    Expanded(flex : 3, child: Text('Date')),
                    Expanded(flex : 3, child: Text('Time')),
                    Expanded(flex : 2, child: Text('Attendance'),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: time.length,
                itemBuilder: (context, index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex : 2,child: Text('${time[index].substring(0,10)}')),
                          Expanded(flex : 3,child: Text('${time[index].substring(12,(time[index].length))}')),
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
