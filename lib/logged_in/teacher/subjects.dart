import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Subjects extends StatefulWidget {
  final String uid;
  Subjects(this.uid);
  @override
  _SubjectsState createState() => _SubjectsState(uid);
}

class _SubjectsState extends State<Subjects> {
  final String uid;
  _SubjectsState(this.uid);
  Map subjectsResult;
  List subjects;
  bool add = false;
  final _formKey = GlobalKey<FormState>();
  String subject;
  String error = ' ';
  TeacherSubjectsAndBatches _tSAB;
  bool loading = false;

  setup() async{
    _tSAB = TeacherSubjectsAndBatches(uid);
    subjectsResult = await _tSAB.getSubjectsAndBatches();
    subjects = subjectsResult.keys.toList();
    print(subjects);
  }

  @override
  void initState()
  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? LoadingScreen() : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: add == false ? addSubjectButton() : addSubjectForm(),
          ),
          SizedBox(height: 10,),
          subjectsResult == null? Text('You Need To Add Subjects', style: TextStyle(color: Colors.red),) : Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    onTap: (){
                      add = true;
                    },
                    title: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('${subjects[index]}'),
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
          add = true;
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
                onChanged: (val) => subject = val,
              ),
            ),
            IconButton(
              onPressed: () async{
                setState(() {
                  loading = true;
                });
                if(_formKey.currentState.validate())
                {
                  if(subjects == null)
                  {
                    dynamic result = await _tSAB.addSubject(subject);
                    if(result ==  null)
                    {
                      setState(() {
                        loading = false;
                        error = "Something Went Wrong, Couldn't Add Subject";
                      });
                    }
                    else
                    {
                      await setup();
                      setState((){
                        loading = false;
                        add = false;
                      });
                    }
                  }
                  else if(subjects.contains(subject))
                  {
                    setState(() {
                      loading = false;
                      error = "Subject Alredy Present";
                    });
                  }
                  else
                  {
                    dynamic result = await _tSAB.addSubject(subject);
                    if(result ==  null)
                    {
                      setState(() {
                        loading = false;
                        error = "Something Went Wrong, Couldn't Add Subject";
                      });
                    }
                    else
                    {
                      await setup();
                      setState((){
                        loading = false;
                        add = false;
                      });
                    }
                  }
                }
              },
              icon: Icon(Icons.add_box),
            ),
            Text('$error', style: TextStyle(color: Colors.red),)
          ],
        )
    );
  }
}







