import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrolledStudents extends StatefulWidget {
  @override
  _EnrolledStudentsState createState() => _EnrolledStudentsState();
}

class _EnrolledStudentsState extends State<EnrolledStudents> {
  TeacherSubjectsAndBatches _tSAB;
  List<String> _students = [];
  List<String> _studentsVisible = [];
  String _subject = '';
  String _batch = '';
  bool _moreOptions = false;
  bool _studentOptions = false;
  bool _removeStudents = false;

  Future setup(FirebaseUser user, String sub, String batchCopy) async {
    _tSAB = TeacherSubjectsAndBatches(user);
    _students = await _tSAB.getStudents(sub, batchCopy);
    if(_students[0] == 'Empty'){
      _moreOptions = true;
    }
    if (_students == null) {
      _students = ["Couldn't get students, try again"];
    }
    _studentsVisible = _students;
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute
        .of(context)
        .settings
        .arguments;
    _subject = data['subject'];
    _batch = data['batch'];
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
                      ),
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(6.5),
                          child: TextFormField(
                            decoration: authInputFormatting.copyWith(hintText: "Search By ID"),
                            onChanged: (val){
                              setState(() {
                                _studentsVisible = _students.where((student) => student.toLowerCase().startsWith(val.toLowerCase())).toList();
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.menu, color: _moreOptions ? Colors.cyan : Colors.grey[700]),
                        onPressed: (){
                          setState(() {
                            _moreOptions = !_moreOptions;
                          });
                        },
                      ),
                      SizedBox(width: 5,)
                    ],
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
                  future: setup(Provider.of<FirebaseUser>(context), _subject, _batch),
                  rememberFutureResult: true,
                  whenNotDone: LoadingData(),
                  whenDone: (arg) => studentList(),
              ),
            ),
          ),
        ],
      )
  );
  }

  Widget studentList(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: _moreOptions ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
            child: addStudentButton(),
          ),
          _students[0] == 'Empty' ? Expanded(child: Text('You Need To Add Students', style: TextStyle(color: Colors.red),),) : Expanded(
            child: ListView.builder(
              itemCount: _studentsVisible.length,
              itemBuilder: (context, index){
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async{
                        Navigator.pushNamed(context, '/attendanceList', arguments: {
                          'teacherEmail' : Provider.of<FirebaseUser>(context, listen: false).email ,
                          'subject': _subject,
                          'batch' : _batch,
                          'studentEmail' : _studentsVisible[index],
                        });
                      },
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text('${_studentsVisible[index]}', style: TextStyle(color: Colors.cyan),)),
                          Icon(Icons.forward, color: Colors.grey[700],)
                        ],
                      ),
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

  Widget addStudentButton() {
    if(_moreOptions){
      if(!_studentOptions){
        return Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap:() async{
                  await Navigator.pushNamed(context, '/updateAttendance', arguments: {'enrolledStudents' : _students, 'subject' : _subject, 'batch' : _batch});
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
                      Icon(Icons.edit, color: Colors.white, size: 20,),
                      SizedBox(width: 5,) ,
                      Text('Attendance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: GestureDetector(
                onTap:() {
                  setState(() {
                    _studentOptions = !_studentOptions;
                  });
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
                      Icon(Icons.edit, color: Colors.white, size: 20,),
                      SizedBox(width: 5,) ,
                      Text('Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
      else{
        if(!_removeStudents){
          return Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap:() {
                    setState(() {
                      _removeStudents = !_removeStudents;
                    });
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
                        Icon(Icons.clear, color: Colors.white, size: 20,),
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
                    dynamic data = await Navigator.pushNamed(context, '/addStudents', arguments: {'enrolledStudents' : _students, 'batch' : _batch, 'subject': _subject});
                    if(data != null) {
                      setState(() {
                        _students = data['enrolledStudents'];
                        _studentsVisible = data['enrolledStudents'];
                      });
                    }
                    setState(() {
                      _studentOptions = !_studentOptions;
                    });
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
                        Icon(Icons.add, color: Colors.white, size: 20,),
                        SizedBox(width: 5,) ,
                        Text('Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        else{
          return Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap:() {
                    setState(() {
                      _removeStudents = !_removeStudents;
                      _studentOptions = !_studentOptions;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Center(child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),
                  ),
                ),
              ),
            ],
          );
        }
      }
    }
    else{
      return Container();
    }
  }
}