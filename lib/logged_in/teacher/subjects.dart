import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  List<String> _subjects = [];
  List<String> _subjectsVisible = [];
  bool _add = false;
  final _formKey = GlobalKey<FormState>();
  String _subject = ' ';
  String _error = ' ';
  TeacherSubjectsAndBatches _tSAB;
  FirebaseUser _user;

  Future setup(FirebaseUser userCurrent) async{
    _user = userCurrent;
    _tSAB = TeacherSubjectsAndBatches(_user);
    _subjects = await _tSAB.getSubjects();
    if(_subjects == null){
      _subjects = ["Couldn't get subjects, try logging in again"];
    }
    _subjectsVisible = _subjects;
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
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      )],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(6.5),
                      child: TextFormField(
                        decoration: authInputFormatting.copyWith(hintText: "Search By Subject"),
                        onChanged: (val){
                          setState(() {
                            _subjectsVisible = _subjects.where((subject) => subject.toLowerCase().contains(val.toLowerCase()));
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
                  future: setup(Provider.of<FirebaseUser>(context)),
                  rememberFutureResult: true,
                  whenNotDone: LoadingData(),
                  whenDone: (arg) => subjectsList(),
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget subjectsList(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _add == false ? addSubjectButton() : addSubjectForm(),
          ),
          _subjectsVisible[0] == 'Empty' ? Text('You Need To Add Subjects', style: TextStyle(color: Colors.red),) : Expanded(
            child: ListView.builder(
              itemCount: _subjects.length,
              itemBuilder: (context, index){
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async{
                        Navigator.of(context).pushNamed('/batches', arguments: _subjectsVisible[index]);
                      },
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text('${_subjectsVisible[index]}', style: TextStyle(color: Colors.cyan),)),
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

  Widget addSubjectButton()
  {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap:(){
              setState(() {
                _add = true;
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
                  Icon(Icons.add, color: Colors.white, size: 25,),
                  SizedBox(width: 10,) ,
                  Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 15,),
        Expanded(
          child: GestureDetector(
            onTap:(){},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 25,),
                  SizedBox(width: 10,) ,
                  Text('Remove', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget addSubjectForm()
  {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Center(child: Text('$_error', style: TextStyle(color: Colors.red),)),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [BoxShadow(
                        color: Color.fromRGBO(51, 204, 255, 0.3),
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      )],
                    ),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(hintText: 'Add Subject Name'),
                      validator: (val) => val.isEmpty ? 'Subject Name Can\'t Be Empty' : null,
                      onChanged: (val) => _subject = val,
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 25,),
                    ),
                    onTap: () async{
                      if(_formKey.currentState.validate())
                      {
                        if(_subjects.contains(_subject))
                        {
                          setState(() {
                            _error = "Subject Already Present";
                          });
                        }
                        else
                        {
                          dynamic result = await _tSAB.addSubject(_subject);
                          if(result ==  null)
                          {
                            setState(() {
                              _error = "Something Went Wrong, Couldn't Add Subject";
                            });
                          }
                          else
                          {
                            setState((){
                              _subjects.add(_subject);
                              _subjectsVisible.add(_subject);
                              _error = ' ';
                              _add = false;
                            });
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}







