import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  Future updateUserData({String name, String description, int age}) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'description': description,
      'age': age,
    }, merge: true);
  }

  Future updateUserPicture({String pictureURL}) async {
    return await userCollection.document(uid).setData({
      'profilePic': pictureURL,
    }, merge: true);
  }

  Future updateUsername({String username}) async {
    return await userCollection.document(uid).setData({
      'username': username,
    }, merge: true);
  }

  Future<bool> isUsernameTaken({String username}) async {
//    final _query = await userCollection
//        .where('username', isEqualTo: username)
//        .limit(1).snapshots();
//    print(_query.toString());

    final result = await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
    print(result.documents.isEmpty);
    return result.documents.isEmpty;
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        description: snapshot.data['description'],
        age: snapshot.data['age'],
        username: snapshot.data['username'],
        profilePic: snapshot.data['profilePic']);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
