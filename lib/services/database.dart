import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cibus/services/login/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference userCollection = Firestore.instance.collection('Users');


  Future updateUserData(String name, String description, int age) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'description': description,
      'age': age,
    });
  }


  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      description: snapshot.data['description'],
      age: snapshot.data['age'],
    );
  }
}