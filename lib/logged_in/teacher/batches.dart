import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
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
  String uid = '';
  String batch = '';

  Future setup(String id, String sub) async{
    _tSAB = TeacherSubjectsAndBatches(id);
    batches = await _tSAB.getBatches(sub);
    if(batches == null){
      batches = ["Couldn't get batches, try logging in again"];
    }
    setState(() {
      subject = sub;
      uid = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: subject.isEmpty ? Text('Batches') : Text('Batches - $subject'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async{
              dynamic result = await User().signOut();
              if(result == null)
              {

                Navigator.of(context).pushReplacementNamed('/authentication');
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: setup(Provider.of<String>(context), ModalRoute.of(context).settings.arguments),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  child: add == true ? addBatchForm() : addBatchButton(),
                )
              ],
            ),
          );
        }
      ),
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
                    dynamic result = await _tSAB.addSubject(batch);
                    if(result ==  null)
                    {
                      setState(() {
                        error = "Something Went Wrong, Couldn't Add Batch";
                      });
                    }
                    else
                    {
                      await setup(uid, subject);
                      setState((){
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
