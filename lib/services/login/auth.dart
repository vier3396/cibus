import 'package:cibus/services/models/user.dart';
import 'package:cibus/services/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cibus/services/models/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, isEmail: user.isEmailVerified)
        : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
    //.map((FirebaseUser user) => _userFromFirebaseUser(user)); Does the same thing as above
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String description, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      user.sendEmailVerification();
      user.isEmailVerified;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
          name: name, description: description, favoriteList: []);
      await DatabaseService(uid: user.uid)
          .updateUserPicture(pictureURL: kDefaultProfilePic);
      await DatabaseService(uid: user.uid).updateUsername(username: username);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //isEmailVerified

  Future<bool> isEmailVerified(FirebaseUser user) async {
    await user.reload();
    user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut().whenComplete(() {});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
