import 'package:cibus/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:cibus/pages/loginScreens/login_screen.dart';
import 'package:cibus/services/constants.dart';

class SignIn {
  loginType whatLogin;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  bool isNewUser = false;
  bool isLoggedInFacebook = false;
  bool isLoggedInGoogle = false;

  Future<List> signInWithGoogle() async {
    isLoggedInGoogle = false;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    isNewUser = authResult.additionalUserInfo.isNewUser;
    final FirebaseUser user = authResult.user;
    print(isNewUser);
    if (isNewUser) {
      await DatabaseService(uid: user.uid).updateUserData(
          name: user.displayName, description: 'description', favoriteList: []);
      await DatabaseService(uid: user.uid).updateUserPicture(
          pictureURL:
              'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/blank_profile_picture.png?alt=media&token=49efb712-d543-40ca-8e33-8c0fdb029ea5');
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user.uid == currentUser.uid) {
      isLoggedInGoogle = true;
    }

    return [isNewUser, isLoggedInGoogle];
  }

  Future<List> signInWithFacebook() async {
    isLoggedInFacebook = false;
    FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
    final accessToken = facebookLoginResult.accessToken.token;
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      isLoggedInFacebook = true;
      final facebookAuthCred =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      final AuthResult authResult =
          await _auth.signInWithCredential(facebookAuthCred);

      isNewUser = authResult.additionalUserInfo.isNewUser;
      final FirebaseUser user = authResult.user;
      if (isNewUser) {
        await DatabaseService(uid: user.uid).updateUserData(
            name: user.displayName, description: 'description', favoriteList: []);
        await DatabaseService(uid: user.uid).updateUserPicture(
            pictureURL:
                'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/blank_profile_picture.png?alt=media&token=49efb712-d543-40ca-8e33-8c0fdb029ea5');
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return [isNewUser, isLoggedInFacebook];
    }
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  void signOut(context) async {
    if (whatLogin == loginType.google) {
      await googleSignIn.signOut();
    } else if (whatLogin == loginType.facebook) {
      await facebookLogin.logOut();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ),
    );
    print("User Sign Out");
  }
}
