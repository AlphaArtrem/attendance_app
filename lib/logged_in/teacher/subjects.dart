import 'dart:ui';
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
  bool _delete = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _subject = ' ';
  String _error = ' ';
  String _userName = '';
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

    _userName = await UserDataBase(_user).userName();
    if(_userName == null){
      _userName = 'Can\'t Get Name';
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
                      padding: EdgeInsets.fromLTRB(18, 95, 0, 20),
                      color: Colors.cyan,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_userName, style: TextStyle(color: Colors.white, fontSize: 20),),
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
                      title: Text('Add Subject'),
                      onTap: () async{
                        Navigator.of(context).pop();
                        addSubjectForm().then((onValue){
                          setState(() {});
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Remove Subject'),
                      onTap: (){
                        Navigator.of(context).pop();
                        if(_subjects[0] != 'Empty'){
                          setState(() {
                            _delete = true;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Account Settings'),
                      onTap: (){
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(6.5),
                            child: TextFormField(
                              decoration: authInputFormatting.copyWith(hintText: "Search By Subject"),
                              onChanged: (val){
                                setState(() {
                                  _subjectsVisible = _subjects.where((subject) => subject.toLowerCase().contains(val.toLowerCase())).toList();
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.cyan),
                          onPressed: () async{
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                        ),
                        SizedBox(width: 5,),
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
        children: <Widget>[
          _subjects[0] == 'Empty' ? addSubjectButton() : Container(),
          _delete && _subjects[0] != 'Empty' ? deleteButton() : Container(),
          _subjects[0] == 'Empty' ? SizedBox(height: 15,) : Container(),
          _subjects[0] == 'Empty' ? Text('You Need To Add Subjects', style: TextStyle(color: Colors.red),) : Expanded(
            child: ListView.builder(
              itemCount: _subjectsVisible.length,
              itemBuilder: (context, index){
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async{
                        if(!_delete){
                          Navigator.of(context).pushNamed('/batches', arguments: {'subject' : _subjectsVisible[index], 'userName' : _userName});
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (context){
                              return Dialog(
                                shape:  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: 30,),
                                      Text('Are you sure you want to delete ${_subjectsVisible[index]} ? This action can\'t be reverted.', textAlign: TextAlign.justify,),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: FlatButton(
                                              child: Text('Cancel', style: TextStyle(color: Colors.cyan),),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: FlatButton(
                                              child: Text('Delete', style: TextStyle(color: Colors.cyan),),
                                              onPressed: () async{
                                                String deleted = _subjectsVisible[index];
                                                dynamic result = await _tSAB.deleteSubject(_subjectsVisible[index]);
                                                if(result == 'Success')
                                                {
                                                  setState(() {
                                                    _error = ' ';
                                                    _subjectsVisible.remove(deleted);
                                                    _subjects.remove(deleted);
                                                  });
                                                  if(_subjects.isEmpty){
                                                    setState(() {
                                                      _subjects.add('Empty');
                                                      _delete = false;
                                                    });
                                                  }
                                                  Navigator.of(context).pop();
                                                }
                                                else{
                                                  setState(() {
                                                    _error = "Couldn't delete ${_subjectsVisible[index]}";
                                                  });
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          );
                        }
                      },
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text('${_subjectsVisible[index]}', style: TextStyle(color: Colors.cyan),)),
                          _delete ? Icon(Icons.delete, color: Colors.grey[700],) : Icon(Icons.forward, color: Colors.grey[700],)
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
            onTap:() async{
              addSubjectForm().then((onValue){
                setState(() {});
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
      ],
    );
  }

  Widget deleteButton() {
    return Column(
      children: <Widget>[
        _error == ' ' ? Container() : Center(child: Text('$_error', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),),
        _error == ' ' ? Container() : SizedBox(height: 15,),
        GestureDetector(
          onTap:(){
            setState(() {
              _delete = false;
              _error = ' ';
            }
            );
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
                Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future addSubjectForm(){
    bool adding = false;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _error == ' ' ? Container() : Center(child: Text('$_error', style: TextStyle(color: Colors.red),)),
                            _error == ' ' ? Container() : SizedBox(height: 15,),
                            Container(
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
                            SizedBox(height: 15,),
                            adding ? Center(child: Text("Adding ..."),) : Row(
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Center(child: Text("Add", style: TextStyle(color: Colors.white),)),
                                    ),
                                    onTap: () async{
                                      if(_formKey.currentState.validate())
                                      {
                                        setState(() {
                                          adding = true;
                                        });
                                        if(_subjects.contains(_subject))
                                        {
                                          setState(() {
                                            _error = "Subject Already Present";
                                            adding = false;
                                          });
                                        }
                                        else
                                        {
                                          dynamic result = await _tSAB.addSubject(_subject);
                                          if(result ==  null)
                                          {
                                            setState(() {
                                              _error = "Something Went Wrong, Couldn't Add Subject";
                                              adding = false;
                                            });
                                          }
                                          else
                                          {
                                            if(_subjects[0] == 'Empty'){
                                              setState((){
                                                _subjects.clear();
                                                _subjects.add(_subject);
                                                _error = ' ';
                                                adding = false;
                                              });
                                            }
                                            else{
                                              setState((){
                                                _subjects.add(_subject);
                                                _error = ' ';
                                                adding = false;
                                              });
                                            }
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Center(child: Text("Done", style: TextStyle(color: Colors.white),)),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _error = ' ';
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              );
            },
          );
      });
  }
}







