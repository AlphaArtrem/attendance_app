import 'package:firebase_auth/firebase_auth.dart';

class User{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<String> get account{
    return _auth.onAuthStateChanged.map(uid);
  }

  Future<String> anonymous() async{
    try {
      AuthResult account = await _auth.signInAnonymously();
      FirebaseUser user = account.user;
      return user.uid;
    }
    catch (e) {
      return null;
    }
  }

  String uid(FirebaseUser account){
    try{
      return account.uid;
    }
    catch(e){
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