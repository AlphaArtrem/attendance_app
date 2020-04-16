import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Batches extends StatefulWidget {
  @override
  _BatchesState createState() => _BatchesState();
}

class _BatchesState extends State<Batches> {
  TeacherSubjectsAndBatches _tSAB;
  String _subject = '';
  String _error  = '';
  List<String> _batches = [];
  List<String> _batchesVisible = [];
  final _formKey = GlobalKey<FormState>();
  bool _add = false;
  String _batch = '';
  bool _delete = false;
  FirebaseUser _user;

  Future setup(FirebaseUser userCurrent, String sub) async{
    _user = userCurrent;
    _tSAB = TeacherSubjectsAndBatches(_user);
    _batches = await _tSAB.getBatches(sub);
    if(_batches == null){
      _batches = ["Couldn't get batches, try again"];
    }
    _batchesVisible = _batches;
  }

  @override
  Widget build(BuildContext context) {
    _subject = ModalRoute.of(context).settings.arguments;
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
                      Expanded(child: Text('Batches', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)),
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
                        setState(() {
                          _batchesVisible = _batches.where((batch) => batch.toLowerCase().startsWith(val.toLowerCase())).toList();
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
                future: setup(Provider.of<FirebaseUser>(context), ModalRoute.of(context).settings.arguments),
                rememberFutureResult: true,
                whenNotDone: LoadingData(),
                whenDone: (arg) => batchList(),
              ),
            ),
          ),
        ],
      )
  );
  }

  Widget batchList(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _add == false ? addBatchButton() : addBatchForm(),
          ),
          _batches[0] == 'Empty' ? Text('\n\nYou Need To Add Batches', style: TextStyle(color: Colors.red),) : Expanded(
            child: ListView.builder(
              itemCount: _batchesVisible.length,
              itemBuilder: (context, index){
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async{
                        if(!_delete){
                          Navigator.of(context).pushNamed('/enrolledStudents', arguments: {'subject' : _subject, 'batch' : _batchesVisible[index]});
                        }
                        else{
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text('Are you sure you want to delete ${_batchesVisible[index]} ? This action can\'t be reverted.', textAlign: TextAlign.justify,),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Delete'),
                                      onPressed: () async{
                                        dynamic result = await _tSAB.deleteBatch(_subject, _batchesVisible[index]);
                                        String deleted = _batchesVisible[index];
                                        if(result == 'Success')
                                        {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _error = '';
                                            _batchesVisible.remove(deleted);
                                            _batches.remove(deleted);
                                          });
                                          if(_batches.isEmpty){
                                            _batches.add('Empty');
                                          }
                                        }
                                        else{
                                          setState(() {
                                            _error = "Couldn't delete ${_batchesVisible[index]}";
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                      },
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text('${_batchesVisible[index]}', style: TextStyle(color: Colors.cyan),)),
                          _delete ? Icon(Icons.delete, color: Colors.grey[700],) : Icon(Icons.forward, color: Colors.grey[700],),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget addBatchButton()
  {
    if(!_delete){
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
          _batches[0] != 'Empty' ? Expanded(
            child: GestureDetector(
              onTap:(){
                setState(() {
                  _delete = true;
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
                    Text('Remove', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                  ],
                ),
              ),
            ),
          ) : Container(),
        ],
      );
    }
    else{
      return Column(
        children: <Widget>[
          _error == '' ? Container() : Center(child: Text('$_error', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),),
          _error == '' ? Container() : SizedBox(height: 15,),
          GestureDetector(
            onTap:(){
              setState(() {
                _delete = false;
                _error = '';
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
  }

  Widget addBatchForm()
  {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _error == ' ' ? Container() : Center(child: Text('$_error', style: TextStyle(color: Colors.red),)),
            _error == ' ' ? Container() : SizedBox(height: 15,),
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
                      decoration: authInputFormatting.copyWith(hintText: 'Add Batch Name'),
                      validator: (val) => val.isEmpty ? 'Batch Name Can\'t Be Empty' : null,
                      onChanged: (val) => _batch = val,
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
                        if(_batches.contains(_batch))
                        {
                          setState(() {
                            _error = "Batch Already Present";
                          });
                        }
                        else
                        {
                          dynamic result = await _tSAB.addBatch(_subject, _batch);
                          if(result ==  null)
                          {
                            setState(() {
                              _error = "Something Went Wrong, Couldn't Add Batch";
                            });
                          }
                          else
                          {
                            if(_batches[0] == 'EMPTY'){
                              setState((){
                                _batches.clear();
                                _batches.add(_batch);
                                _error = ' ';
                                _add = false;
                              });
                            }
                            else{
                              setState((){
                                _batches.add(_batch);
                                _error = ' ';
                                _add = false;
                              });
                            }
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
