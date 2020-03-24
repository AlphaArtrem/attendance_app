import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataBase{

  final String uid;
  UserDataBase(this.uid);

  final CollectionReference _userData = Firestore.instance.collection('users');

  Future<String> newUserData(firstName, lastName, type) async{
    try{
      Map<String, dynamic> data = {
        'fistName' : firstName,
        'lastName' : lastName,
        'type' : type
      };
      await _userData.document(uid).setData(data);
      return 'Success';
    }
    catch(e){
      return null;
    }
  }

  Future userType() async{
    DocumentSnapshot data;
    await _userData.document(uid).get().then((DocumentSnapshot ds){
      data = ds;
    });
    return data.data['type'];
  }

}