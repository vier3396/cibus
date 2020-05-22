import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  bool isEmail;

  User({this.uid, this.isEmail});
}

class UserData {
  final String uid;
  final String name;
  final String description;
  final String username;
  final String profilePic;
  bool isEmail;
  final List<dynamic> favoriteList;

  UserData(
      {this.uid,
      this.name,
      this.description,
      this.username,
      this.profilePic,
      this.isEmail,
      this.favoriteList});
}
