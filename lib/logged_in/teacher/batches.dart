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
  FirebaseUser _user;
  String _subject = '';
  String _error  = '';
  String _userName = "";
  String _batch = '';
  List<String> _batches = [];
  List<String> _batchesVisible = [];
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _delete = false;

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
    Map data = ModalRoute.of(context).settings.arguments;
    _subject = data['subject'];
    _userName = data['userName'];
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
                    title: Text('Add Batch'),
                    onTap: () async{
                      Navigator.of(context).pop();
                      addBatchForm().then((onValue){
                        setState(() {});
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Remove Batch'),
                    onTap: (){
                      Navigator.of(context).pop();
                      if(_batches[0] != 'Empty'){
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
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
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.cyan),
                        onPressed: () async{
                          _scaffoldKey.currentState.openEndDrawer();
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
                future: setup(Provider.of<FirebaseUser>(context), _subject),
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
          _batches[0] == "Empty" ? addBatchButton() : Container(),
          _delete && _batches[0] != 'Empty' ? deleteButton() : Container(),
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
                          Navigator.of(context).pushNamed('/enrolledStudents', arguments: {'subject' : _subject, 'batch' : _batchesVisible[index], 'userName' : _userName});
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
                                        Text('Are you sure you want to delete ${_batchesVisible[index]} ? This action can\'t be reverted.', textAlign: TextAlign.justify,),
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
                                                      setState(() {
                                                        _batches.add('Empty');
                                                        _delete = false;
                                                      });
                                                    }
                                                  }
                                                  else{
                                                    setState(() {
                                                      _error = "Couldn't delete ${_batchesVisible[index]}";
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
    return GestureDetector(
      onTap:() async{
        addBatchForm().then((onValue){
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

  Future addBatchForm()
  {
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
                              decoration: authInputFormatting.copyWith(hintText: 'Add Batch Name'),
                              validator: (val) => val.isEmpty ? 'Batch Name Can\'t Be Empty' : null,
                              onChanged: (val) => _batch = val,
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
                                      if(_batches.contains(_batch))
                                      {
                                        setState(() {
                                          _error = "Batch Already Present";
                                          adding = false;
                                        });
                                      }
                                      else
                                      {
                                        dynamic result = await _tSAB.addBatch(_subject, _batch);
                                        if(result ==  null)
                                        {
                                          setState(() {
                                            _error = "Something Went Wrong, Couldn't Add Batch";
                                            adding = false;
                                          });
                                        }
                                        else
                                        {
                                          if(_batches[0] == 'Empty'){
                                            setState((){
                                              _batches.clear();
                                              _batches.add(_batch);
                                              _error = ' ';
                                              adding = false;
                                            });
                                          }
                                          else{
                                            setState((){
                                              _batches.add(_batch);
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
