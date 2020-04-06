import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/classes/firestore.dart';
import 'package:attendanceapp/shared/formatting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final User _account = User();
  final _formKey = GlobalKey<FormState>();

  String email, pass, firstName, lastName;
  String error = '';
  String type = '';
  List<String> _types = ['', 'Student', 'Teacher'];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingScreen() : Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 90, 15, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(error, style: TextStyle(color: Colors.red),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: TextFormField(
                      decoration: textInputFormatting.copyWith(helperText: "First Name"),
                      validator: (val) => val.isEmpty ? 'Can\'t Be Empty' : null,
                      onChanged: (val){
                        firstName = val;
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: TextFormField(
                      decoration: textInputFormatting.copyWith(helperText: "Last Name"),
                      validator: (val) => val.isEmpty ? 'Can\'t Be Empty' : null,
                      onChanged: (val){
                        lastName =val;
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: textInputFormatting.copyWith(helperText: "Enter Email"),
              validator: _account.validateId,
              onChanged: (val){
                email = val;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: textInputFormatting.copyWith(helperText: "Enter Password"),
              validator: _account.validateRegisterPass,
              obscureText: true,
              onChanged: (val){
                pass = val;
              },
            ),
            SizedBox(height: 10,),
            Container(
              height: 80,
              child: FormField<String>(
                validator: (val) => val.isEmpty ? "Choose A Category" : null,
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: textInputFormatting.copyWith(helperText: 'Choose Account Type'),
                    isEmpty: type == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: type,
                        isDense: true,
                        onChanged: (value) {
                          setState(() {
                            type = value;
                            state.didChange(value);
                          });
                        },
                        items: _types.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30,),
            RaisedButton.icon(
              onPressed: () async{
                if(_formKey.currentState.validate())
                {
                  setState(() => loading = true);
                  FirebaseUser user = await _account.register(email, pass);
                  if(user != null)
                  {
                    UserDataBase userData = UserDataBase(user) ;
                    dynamic userDataSet = await userData.newUserData(firstName, lastName, type);
                    if(userDataSet != null)
                    {
                      dynamic type = await userData.userType();
                      Navigator.of(context).pushReplacementNamed('/home', arguments: type);
                    }
                    else
                    {
                      await _account.deleteUser();
                      setState(() {
                        loading = false;
                        error = "Couldn't add user details to database";
                      });
                    }
                  }
                  else
                  {
                    setState(() {
                      loading = false;
                      error = "Please provide an valid E-mail";
                    });
                  }
                }
              },
              icon: Icon(Icons.person_add, color: Colors.white, size: 25),
              label: Text(
                '  Register',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              elevation: 0,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
