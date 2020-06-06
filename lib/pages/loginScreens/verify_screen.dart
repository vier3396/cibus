import 'dart:async';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/my_page_view.dart';
import 'package:flutter/material.dart';
import 'file:///C:/cibus/lib/services/models/user.dart';
import 'package:cibus/services/database/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/pages/loadingScreens/loading_screen.dart';
import 'package:cibus/services/models/colors.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool loading = false;
  String resent = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          return loading
              ? LoadingScreen()
              : Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Text(
                            'Check and verify your email.',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 30.0, left: 20, right: 20),
                            child: Container(
                              child: Text(
                                'An email has been sent to your inbox, please click on the link to verify. \n'
                                'Then click on the verify button below when finished.',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: kButtonPadding,
                            child: RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 50),
                                child: Text(
                                  "I've verified my email",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                              onPressed: () async {
                                loading = true;
                                FirebaseUser _firebaseUser =
                                    await FirebaseAuth.instance.currentUser();
                                AuthService().isEmailVerified(_firebaseUser);
                                setState(() {
                                  user.isEmail = _firebaseUser.isEmailVerified;
                                  _firebaseUser.reload();
                                });
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
                                    _verifyDialog();
                                  });
                                }
                                _firebaseUser.reload();
                              },
                              color: kCoral,
                              splashColor: kWarmOrange,
                              shape: kButtonShape,
                            ),
                          ),
                          Padding(
                            padding: kButtonPadding,
                            child: RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Resend verification email',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              onPressed: () async {
                                loading = true;
                                FirebaseUser _firebaseUser =
                                    await FirebaseAuth.instance.currentUser();
                                await _firebaseUser.sendEmailVerification();
                                _resendDialog();
                              },
                              color: Colors.grey[300],
                              splashColor: kWarmOrange,
                              shape: kButtonShape,
                            ),
                          ),
                        ],
                      ),
                    ),
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
          title: Text('Not quite there yet!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Sorry the servers are still working on your verification, please try again! :)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
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
                Text('The verification email has been resent.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
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
