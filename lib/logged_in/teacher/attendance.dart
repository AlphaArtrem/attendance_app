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
  String date = 'Choose Class Date';
  String start = 'Choose Start Time';
  String end = 'Choose Stop Time';
  @override
  Widget build(BuildContext context) {
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
                  Expanded(child: Text('$date')),
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
                  Icon(Icons.calendar_today,),
                  SizedBox(width: 20,),
                  Expanded(child: Text('$start')),
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
                  Icon(Icons.calendar_today,),
                  SizedBox(width: 20,),
                  Expanded(child: Text('$end')),
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
          )
        ],
      ),
    );
  }

  Widget updateAttendance(){
    return Container();
  }

}
