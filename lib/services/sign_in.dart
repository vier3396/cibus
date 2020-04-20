import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();




Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';

}

Future<String> signInWithFacebook() async {
  FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
  final accessToken = facebookLoginResult.accessToken.token;
  if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
    final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: accessToken);
    final AuthResult authResult = await _auth.signInWithCredential(facebookAuthCred);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signIn With Facebook succeeded: $user';
    }

}

Future<FacebookLoginResult> _handleFBSignIn() async {
  FacebookLogin facebookLogin = FacebookLogin();
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

void signOutGoogle() async{
  await googleSignIn.signOut();


  print("User Sign Out");
}