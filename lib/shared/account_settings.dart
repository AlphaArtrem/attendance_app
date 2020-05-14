import 'package:attendanceapp/classes/account.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  Map _status = {
    'index': null,
    'action' : null,
  };

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
                        Expanded(child: Text('Account Settings', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)),
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40,),
                    Card(
                      child: ListTile(
                        title: Text("Update Name"),
                        trailing: Icon(Icons.edit),
                        subtitle: _status['index'] == 0 ? Text(_status['status'], style: TextStyle(color: _status['error'] ? Colors.red : Colors.green),) : Text("Update Your Display Name"),
                        onTap: (){},
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Update Email"),
                        trailing: Icon(Icons.email),
                        subtitle: _status['index'] == 1 ? Text(_status['status'], style: TextStyle(color: _status['error'] ? Colors.red : Colors.green),) : Text("Update Your Current Email"),
                        onTap: (){
                        },
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Update Password"),
                        trailing: Icon(Icons.lock_outline),
                        subtitle: _status['index'] == 2 ? Text(_status['status'], style: TextStyle(color: _status['error'] ? Colors.red : Colors.green),) : Text("Update Your Password"),
                        onTap: () {
                          setState(() {
                            _status['action'] = 2;
                          });
                        },
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
