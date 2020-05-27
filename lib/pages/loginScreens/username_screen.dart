import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      Text(
                        'Update your Cibus username',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      SizedBox(height: 200.0),
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
                            /*else if (checkUsername == false)
                              return 'Username is allready taken';*/
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              _currentUsername = val;
                              print(_currentUsername);
                            });
                          }),
                      RaisedButton(
                        color: kCoral,
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
                              await DatabaseService(uid: user.uid)
                                  .updateUsername(
                                username: _currentUsername,
                              );
                              print('Creating usernamse');
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
                      )
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
}
