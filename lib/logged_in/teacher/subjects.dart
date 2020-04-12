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
                            //_attendanceListVisible = Map.from(_attendanceList)..removeWhere((k, v) => !k.toString().contains(val));
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
          Card(
            child: _add == false ? addSubjectButton() : addSubjectForm(),
          ),
          SizedBox(height: 10,),
          _subjects[0] == 'Empty' ? Text('You Need To Add Subjects', style: TextStyle(color: Colors.red),) : Expanded(
            child: ListView.builder(
              itemCount: _subjects.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    onTap: () async{
                      Navigator.of(context).pushNamed('/batches', arguments: _subjects[index]);
                    },
                    title: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('${_subjects[index]}'),
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
    return ListTile(
      onTap: (){
        setState(() {
          _add = true;
        });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.add),SizedBox(width: 10,) ,Text('Add A Subject')],
      ),
    );
  }

  Widget addSubjectForm()
  {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 2),
              child: TextFormField(
                decoration: textInputFormatting.copyWith(hintText: 'Add Subject Name'),
                validator: (val) => val.isEmpty ? 'Subject Name Can\'t Be Empty' : null,
                onChanged: (val) => _subject = val,
              ),
            ),
            IconButton(
              onPressed: () async{
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
                        _error = ' ';
                        _add = false;
                      });
                    }
                  }
                }
              },
              icon: Icon(Icons.add_box),
            ),
            Text('$_error', style: TextStyle(color: Colors.red),)
          ],
        )
    );
  }
}







