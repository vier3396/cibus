import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/services/my_page_view.dart';
import 'package:cibus/services/colors.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          return loading
              ? LoadingScreen()
              : Scaffold(
                  body: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      SafeArea(
                        child: Text(
                          'Check your email and verify it.',
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'An email has been sent to your inbox, please check it and click the link to verify. \n'
                          'Click the verify button when finished',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 160,
                                  child: RaisedButton(
                                    color: kCoral,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Resend verification \n email',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    onPressed: () async {
                                      loading = true;
                                      FirebaseUser _firebaseUser =
                                          await FirebaseAuth.instance
                                              .currentUser();
                                      await _firebaseUser
                                          .sendEmailVerification();

                                      Text('Verification email resent');
                                    },
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Container(
                                  width: 160,
                                  child: RaisedButton(
                                    color: kCoral,
                                    child: Text(
                                      "I've verified \n my email",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      //AuthService.isEmailVerified();
                                      loading = true;
                                      FirebaseUser _firebaseUser =
                                          await FirebaseAuth.instance
                                              .currentUser();
                                      AuthService()
                                          .isEmailVerified(_firebaseUser);
                                      setState(() {
                                        user.isEmail =
                                            _firebaseUser.isEmailVerified;
                                        _firebaseUser.reload();
                                      });
                                      //user.isEmail = _firebaseUser.isEmailVerified;
                                      if (_firebaseUser.isEmailVerified) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MyPageView();
                                            },
                                          ),
                                        );
                                      } else {
                                        Timer(Duration(seconds: 3), () {
                                          print(
                                              "Yeah, this line is printed after 3 second");
                                          _verifyDialog();
                                        });
                                      }
                                      print(_firebaseUser.isEmailVerified);
                                      _firebaseUser
                                          .reload(); //LÖS DET HÄR MED ATT MAN MÅSTE KLICKA TVÅ GÅNGER!!
                                      //print(AuthService().isEmailVerified(_firebaseUser));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.0),
                    ],
                  ),
                );
        });
  }

  Future<void> _verifyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not quite yet!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Sorry the servers are still working on your verification, try again! :)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  loading = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resendDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The Verification email has been resent'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                loading = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
