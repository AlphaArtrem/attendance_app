import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Batches extends StatefulWidget {
  @override
  _BatchesState createState() => _BatchesState();
}

class _BatchesState extends State<Batches> {
  TeacherSubjectsAndBatches _tSAB;
  String subject = '';
  String error  = '';
  List<String> batches = [];
  final _formKey = GlobalKey<FormState>();
  bool add = false;
  String batch = '';
  FirebaseUser user;

  Future setup(FirebaseUser userCurrent, String sub) async{
    user = userCurrent;
    _tSAB = TeacherSubjectsAndBatches(user);
    batches = await _tSAB.getBatches(sub);
    if(batches == null){
      batches = ["Couldn't get batches, try again"];
    }
  }

  @override
  Widget build(BuildContext context) {
    subject = ModalRoute.of(context).settings.arguments;
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
                        decoration: authInputFormatting.copyWith(hintText: "Search By Batch"),
                        onChanged: (val){
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
                child: FutureBuilder(
                    future: setup(Provider.of<FirebaseUser>(context), ModalRoute.of(context).settings.arguments),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return batches.isEmpty ? LoadingData() : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              child: add == true ? addBatchForm() : addBatchButton(),
                            ),
                            SizedBox(height: 10,),
                            batches[0] == 'Empty' ? Text('You Need To Add Batches', style: TextStyle(color: Colors.red),) : Expanded(
                              child: ListView.builder(
                                itemCount: batches.length,
                                itemBuilder: (context, index){
                                  return Card(
                                      child : ListTile(
                                        onTap: () async{
                                          Navigator.of(context).pushNamed('/enrolledStudents', arguments: {'subject' : subject, 'batch' : batches[index]});
                                        },
                                        title: Text('${batches[index]}'),
                                      )
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget addBatchButton()
  {
    return ListTile(
      onTap: (){
        setState(() {
          add = true;
        });
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.add),SizedBox(width: 10,) ,Text('Add A Batch')],
      ),
    );
  }

  Widget addBatchForm()
  {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 2),
              child: TextFormField(
                decoration: textInputFormatting.copyWith(hintText: 'Add Batch Name'),
                validator: (val) => val.isEmpty ? 'Batch Name Can\'t Be Empty' : null,
                onChanged: (val) => batch = val,
              ),
            ),
            IconButton(
              onPressed: () async{
                if(_formKey.currentState.validate())
                {
                  if(batches.contains(batch))
                  {
                    setState(() {
                      error = "Batch Already Present";
                    });
                  }
                  else
                  {
                    dynamic result = await _tSAB.addBatch(subject, batch);
                    if(result ==  null)
                    {
                      setState(() {
                        error = "Something Went Wrong, Couldn't Add Batch";
                      });
                    }
                    else
                    {
                      await setup(user, subject);
                      setState((){
                        error = ' ';
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
