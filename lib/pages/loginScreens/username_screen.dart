import 'package:cibus/pages/loadingScreens/loading_screen.dart';
import 'package:cibus/services/models/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/services/models/colors.dart';

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
                  resizeToAvoidBottomInset: false,
                  body: Form(
                    key: _formKey,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Choose your CIBUS username',
                              style: TextStyle(fontSize: 25.0),
                            ),
                            SizedBox(height: 30.0),
                            TextFormField(
                                initialValue: '',
                                decoration: InputDecoration(
                                  enabledBorder: textInputBorder,
                                  border: textInputBorder,
                                  labelText: 'Name',
                                ),
                                validator: (val) {
                                  if (val.length < 3)
                                    return 'Name must be more than 2 characters';
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    _currentUsername = val;
                                    print(_currentUsername);
                                  });
                                }),
                            SizedBox(height: 40.0),
                            /*
                            RaisedButton(
                              color: kCoral,
                              child: Text(
                                'Done',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                loading = true;
                                if (_formKey.currentState.validate()) {
                                  bool checkUsername = await DatabaseService()
                                      .isUsernameTaken(
                                          username: _currentUsername);
                                  if (!checkUsername) {
                                    await DatabaseService(uid: user.uid)
                                        .updateUsername(
                                      username: _currentUsername,
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MyPageView();
                                        },
                                      ),
                                    );
                                  } else {
                                    _usernameDialog();
                                  }
                                }
                              },
                            ),

                             */
                            ButtonTheme(
                              height: 52.0,
                              minWidth: 200.0,
                              child: FlatButton(
                                child: Text(
                                  'Done',
                                  style: kTextStyleRegisterButton,
                                  /* TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.1),
                                      */
                                ),
                                color: kCoral,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                                onPressed: () async {
                                  loading = true;
                                  if (_formKey.currentState.validate()) {
                                    bool checkUsername = await DatabaseService()
                                        .isUsernameTaken(
                                            username: _currentUsername);
                                    if (!checkUsername) {
                                      await DatabaseService(uid: user.uid)
                                          .updateUsername(
                                        username: _currentUsername,
                                      );
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyPageView();
                                          },
                                        ),
                                      );
                                    } else {
                                      _usernameDialog();
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                          ],
                        ),
                      ),
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
              child: Text('OK'),
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
          title: Text('Username already taken'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Unfortunately the username is already taken. Please try another one'),
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
}
