import 'package:firebase_auth/firebase_auth.dart';

class User{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<String> get account{
    return _auth.onAuthStateChanged.map(uid);
  }

  String validateId(String id)
  {
    if(id.isEmpty)
    {
      return "Email can't be blank";
    }
    else
    {
      return null;
    }
  }

  String validateRegisterPass(String pass)
  {
    if(pass.length < 6)
    {
      return "Password can't be less than 6 characters";
    }
    else
    {
      return null;
    }
  }

  String validateLoginPass(String pass)
  {
    if(pass.isEmpty)
    {
      return "Password can't be empty";
    }
    else
    {
      return null;
    }
  }

  String uid(FirebaseUser user){
    try{
      return user.uid;
    }
    catch(e){
      return null;
    }
  }

  Future register(email, pass) async{
    try
    {
      AuthResult account = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      return uid(account.user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }


  Future<String> login(email, pass) async{
    try {
      AuthResult account = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return uid(account.user);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      return null;
    }
  }
}