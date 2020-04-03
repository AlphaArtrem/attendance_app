import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class UpdateAttendance extends StatefulWidget {
  @override
  _UpdateAttendanceState createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  bool chooseClass = true;
  String date ;
  DateTime current = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: chooseClass ? Text('Choose class') : Text('Update Attendance'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 5,
            onPressed: (){
              DatePicker.showDatePicker(context,
                theme: DatePickerTheme(
                  containerHeight: 200,
                  backgroundColor: Colors.transparent,
                ),
                showTitleActions: true,
                minTime: DateTime(current.year, current.month - 1, current.day),
                maxTime: DateTime(current.year, current.month, current.day),
                onConfirm: (date) {
                },
                currentTime: current,
              );
            },
          )
        ],
      ),
    );
  }

  Widget updateAttendance(){
    return Container();
  }

}
