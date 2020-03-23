import 'package:attendanceapp/classes/account.dart';
import 'package:attendanceapp/shared/formatting.dart';
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
    return loading ? LoadingScreen() : Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 100),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                SizedBox(height: 25,),
                RaisedButton.icon(
                  onPressed: () async{
                    if(_formKey.currentState.validate())
                      {
                        setState(() => loading = true);
                        dynamic user = await _account.register(email, pass);
                        print(user);
                        if(user != null)
                          {
                            Navigator.of(context).pushReplacementNamed('/student');
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
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  elevation: 0,
                ),
                SizedBox(height: 50,),
                Text(error, style: TextStyle(color: Colors.red),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
