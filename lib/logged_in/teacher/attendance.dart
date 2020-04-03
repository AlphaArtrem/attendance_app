import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class UpdateAttendance extends StatefulWidget {
  @override
  _UpdateAttendanceState createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  bool chooseClass = true;
  DateTime current = DateTime.now();
  String date = '';
  String start = '';
  String end = '';
  List<String> enrolledStudents = [];
  Map attendance = {};
  @override
  Widget build(BuildContext context) {
    enrolledStudents = ModalRoute.of(context).settings.arguments;
    attendance = attendance.isEmpty ? Map.fromIterable(enrolledStudents, key: (student) => student, value: (student) => false ) : attendance;
    return Scaffold(
      appBar: AppBar(
        title: chooseClass ? Text('Class Duration') : Text('Update Attendance'),
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
      body: chooseClass ? chooseClassDuration() : updateAttendance(),
    );
  }

  Widget chooseClassDuration(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.calendar_today,),
                  SizedBox(width: 20,),
                  Expanded(child: date.isEmpty ? Text('Choose Class Date') : Text('$date')),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue,),
                    onPressed: (){
                        DatePicker.showDatePicker(
                        context,
                        theme: DatePickerTheme(containerHeight: 200, backgroundColor: Colors.white,),
                        showTitleActions: true,
                        minTime: DateTime(current.year, current.month - 1, current.day),
                        maxTime: DateTime(current.year, current.month, current.day),
                        onConfirm: (dt) {
                          setState(() {
                            date =dt.toString().substring(0,10);
                          });
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time,),
                  SizedBox(width: 20,),
                  Expanded(child: start.isEmpty ? Text('Choose Start Time') : Text('$start')),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue,),
                    onPressed: (){
                      DatePicker.showTime12hPicker(
                        context,
                        theme: DatePickerTheme(containerHeight: 200, backgroundColor: Colors.white,),
                        showTitleActions: true,
                        onConfirm: (time) {
                          setState(() {
                            start = DateFormat.jm().format(time);
                          });
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time,),
                  SizedBox(width: 20,),
                  Expanded(child: end.isEmpty ? Text('Choose Stop Time') : Text('$end')),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue,),
                    onPressed: (){
                      DatePicker.showTime12hPicker(
                        context,
                        theme: DatePickerTheme(containerHeight: 200, backgroundColor: Colors.white,),
                        showTitleActions: true,
                        onConfirm: (time) {
                          setState(() {
                            end = DateFormat.jm().format(time);
                          });
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          RaisedButton(
            color: Colors.blue,
            onPressed: (){
                setState(() {
                  chooseClass = false;
                });
            },
            child: Text('Submit', style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }

  Widget updateAttendance(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: enrolledStudents.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text('${enrolledStudents[index]}'),
                        ),
                        IconButton(
                          icon: attendance[enrolledStudents[index]] ? Icon(Icons.check_circle_outline, color: Colors.blue,) : Icon(Icons.check_circle_outline, color: Colors.grey,),
                          onPressed: () {
                            setState(() {
                              attendance[enrolledStudents[index]] = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: (){
            },
            child: Text('Update Attendance', style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }

}
