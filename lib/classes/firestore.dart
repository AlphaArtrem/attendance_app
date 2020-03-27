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
      print(e.toString());
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

  final CollectionReference _teachers = Firestore.instance.collection('/teachers-data');

  Future<String> addSubject(String subject) async{
    try{
      //Creating an map with subjects as keys and weather to show it or not as an boolean value
      await _teachers.document(uid).setData({subject : true}, merge: true);
      return 'Success';
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<String> addBatch(String subject, String batch) async{
    try{
      await _teachers.document(uid).collection(subject).document(batch).setData({}, merge: true);
      return 'Success';
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> getSubjects() async {
    try {
      List<String> subjects = [];
      await _teachers.document(uid).get().then((DocumentSnapshot ds){
        if(ds.exists){
          subjects.addAll(ds.data.keys);
        }
        else{
          subjects = ['Empty'];
        }
      });
      return subjects.isEmpty || subjects == null ? [] : subjects;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> getBatches(String subject) async{
    try{
      List<String> batches = [];
      QuerySnapshot qs = await _teachers.document(uid).collection(subject).getDocuments();
      qs.documents.forEach((DocumentSnapshot ds) => batches.add(ds.documentID));
      return batches.isEmpty || batches == null ? [] : batches;
    }

    catch(e){
      print(e.toString());
      return null;
    }
  }
}