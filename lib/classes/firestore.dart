import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataBase{

  final String uid;
  UserDataBase(this.uid);

  final CollectionReference _userData = Firestore.instance.collection('users');

  Future<String> newUserData(String firstName, String lastName, String type) async{
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

class TeacherSubjectsAndBatches{

  final String uid;
  TeacherSubjectsAndBatches(this.uid);

  final CollectionReference _teachers = Firestore.instance.collection('/batches');

  Future<String> addSubject(String subject) async{
    try{
      await _teachers.document(uid).setData({'$subject' : List()}, merge: true);
      return 'Success';
    }
    catch(e){
      return null;
    }
  }

  Future<String> addBatch(String subject, String batch) async{
    try{
      List batches;
      await _teachers.document(uid).get().then((DocumentSnapshot ds) => batches = ds.data['$subject']);
      if(batches.contains(batch))
        {
          return "Two batches can't have same name";
        }
      else
        {
          batches.add(batch);
          return 'Success';
        }
    }
    catch(e){
      return null;
    }
  }

  Future<Map> getSubjectsAndBatches() async{
    try{
      Map subjects;
      await _teachers.document(uid).get().then((DocumentSnapshot ds) => subjects = ds.data);
      print(subjects);
      return subjects;
    }
    catch(e){
      return null;
    }
  }
}