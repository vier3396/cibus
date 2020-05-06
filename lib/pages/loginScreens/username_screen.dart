import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/firstScreen.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cibus/services/colors.dart';

OutlineInputBorder textInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25.0),
);

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentUsername;
  //bool checkUsername;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          return Scaffold(
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 60.0),
                  Text(
                    'Check your email and verify it',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    children: <Widget>[
                      Text(
                          'Press button to check if email is verified. \n you might have to press it twice hehe:))'),
                      SizedBox(width: 10.0),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'verified?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          //AuthService.isEmailVerified();
                          FirebaseUser _firebaseUser =
                              await FirebaseAuth.instance.currentUser();
                          AuthService().isEmailVerified(_firebaseUser);
                          await _firebaseUser.reload();
                          setState(() {
                            user.isEmail = _firebaseUser.isEmailVerified;
                          });
                          //user.isEmail = _firebaseUser.isEmailVerified;
                          print(_firebaseUser.isEmailVerified);
                          //print(AuthService().isEmailVerified(_firebaseUser));
                        },
                      ),
                      SizedBox(width: 10.0),
                      Text(user.isEmail.toString()),
                    ],
                  ),
                  SizedBox(height: 60.0),
                  Row(
                    children: <Widget>[
                      Text('Press to resend verification email'),
                      SizedBox(width: 20.0),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'resend?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          FirebaseUser _firebaseUser =
                              await FirebaseAuth.instance.currentUser();
                          await _firebaseUser.sendEmailVerification();

                          Text('Verification email resent');
                          _verificationDialog();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 60.0),
                  Text(
                    'Update your Cibus username',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  Text('Name'),
                  TextFormField(
                      initialValue: '',
                      decoration: textInputDecoration,
                      validator: (val) {
                        if (val.length < 3)
                          return 'Name must be more than 2 character';
                        else if (user.isEmail == false)
                          return 'Please verify email first';
                        /*else if (checkUsername == false)
                          return 'Username is allready taken';*/
                        return null; //Vi säger aldrig till om att username är taken???
                      },
                      onChanged: (val) {
                        setState(() {
                          _currentUsername = val;
                          print(_currentUsername);
                        });
                      }),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        bool checkUsername = await DatabaseService()
                            .isUsernameTaken(username: _currentUsername);
                        print(' checkUsername: $checkUsername');
                        if (!checkUsername) {
                          /* await DatabaseService(uid: user.uid).updateUsername(
                            username: _currentUsername,
                          ); */
                          print('Creating usernamse');
                          /*Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPageView();
                              },
                            ),
                          );*/
                        } else {
                          _usernameDialog();
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _verificationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The Verification email has been sent'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aight bruh'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _usernameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Username is already taken'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Unfortunately it seems like your username is allready taken. Please try another one'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aight bruh'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
