import 'package:cibus/pages/loginScreens/username_screen.dart';
import 'package:cibus/pages/loginScreens/verify_screen.dart';
import 'package:cibus/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/loginScreens/e-sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:cibus/services/my_page_view.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/pages/loading_screen.dart';

const registerButtonColor = kTurquoise;
const formSizedBox = SizedBox(height: 15.0);
const EdgeInsets formPadding =
    EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0);
const TextStyle textStyleErrorMessage =
    TextStyle(color: Colors.red, fontSize: 14.0);
const TextStyle textStyleRegisterButton = TextStyle(color: Colors.white);

OutlineInputBorder textInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25.0),
);

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  RegisterScreen({this.toggleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isVerified = false;
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //text field state
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String description = '';
  String _currentUsername;
  int age = 0;
  int dropdownValue = null;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0.0,
              title: Text('Sign up to Cibus', style: TextStyle(color: kCoral)),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person, color: kCoral),
                  label: Text('Sign in', style: TextStyle(color: kCoral)),
                  onPressed: () {
                    //widget.toggleView();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return EmailSignIn();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: formPadding,
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      formSizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: textInputBorder,
                          border: textInputBorder,
                          labelText: 'Email',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      formSizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: textInputBorder,
                          border: textInputBorder,
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        controller: _pass,
                        validator: (String val) {
                          Pattern pattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          RegExp regex = new RegExp(pattern);
                          print(val);
                          if (val.isEmpty) {
                            return 'Please enter password';
                          } else if (val.length < 8) {
                            return 'Minimum 8 characters required';
                          } else if (!val.contains(RegExp(r'[A-Z]'))) {
                            return 'One upper case letter required.';
                          } else if (!val.contains(RegExp(r'[a-z]'))) {
                            return 'One lower case letter required.';
                          } else if (!val.contains(RegExp(r'[0-9]'))) {
                            return 'One digit required.';
                          } else if (!val
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'One special character required.';
                          } /*

                          else {
                            if (!regex.hasMatch(val))
                              return 'Enter valid password: \n'
                                  'Password must contain at least one upper case letter. \n'
                                  'Password must contain at least one lower case letter. \n'
                                  'Password must contain at least one digit. \n'
                                  'Password must contain at least one special character.'; */
                          else
                            return null;
                          //}
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      formSizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: textInputBorder,
                          border: textInputBorder,
                          labelText: ' Re-enter Password',
                        ),
                        obscureText: true,
                        controller: _confirmPass,
                        validator: (String val) {
                          if (val.isEmpty)
                            return 'Re-enter password field is empty';
                          if (val != _pass.text)
                            return 'passwords do not match';
                          return null;
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      formSizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: textInputBorder,
                          border: textInputBorder,
                          labelText: 'Name',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter your name' : null,
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                      ),
                      formSizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: textInputBorder,
                          border: textInputBorder,
                          labelText: 'Description',
                        ),
                        minLines: 5,
                        maxLines: 10,
                        validator: (val) =>
                            val.isEmpty ? 'Enter your description' : null,
                        onChanged: (val) {
                          setState(() => description = val);
                        },
                      ),
                      formSizedBox,
                      TextFormField(
                          maxLength: 20,
                          decoration: InputDecoration(
                            enabledBorder: textInputBorder,
                            border: textInputBorder,
                            labelText: 'Username',
                          ),
                          validator: (val) {
                            if (val.length < 3)
                              return 'Username must be more than 2 characters';
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
                      formSizedBox,
                      RaisedButton(
                        color: kCoral,
                        child: Text('Register', style: textStyleRegisterButton),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            bool isUsernameFree = await DatabaseService()
                                .isUsernameTaken(username: _currentUsername);
                            print(' checkUsername: $isUsernameFree');
                            if (!isUsernameFree) {
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, name, description, age);
                              if (result == null) {
                                setState(() {
                                  error = 'Email is already registered';
                                  _verificationEmailDialog();
                                });
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return VerifyScreen();
                                    },
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                error = 'Username is already taken';
                              });
                              _usernameDialog();
                            }
                          }
                        },
                      ),
                      Text(
                        error,
                        style: textStyleErrorMessage,
                      ),
                    ])),
              ),
            ));
  }

  Future<void> _verificationDialog(User user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'The Verification email has been sent, please check your email and complete the registration. Press the verify button below when done.'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Verified?'),
              onPressed: () async {
                FirebaseUser _firebaseUser =
                    await FirebaseAuth.instance.currentUser();
                AuthService().isEmailVerified(_firebaseUser);
                setState(() {
                  user.isEmail = _firebaseUser.isEmailVerified;
                });
                //user.isEmail = _firebaseUser.isEmailVerified;
                print(_firebaseUser.isEmailVerified);
                _firebaseUser
                    .reload(); //LÖS DET HÄR MED ATT MAN MÅSTE KLICKA TVÅ GÅNGER!!
                //print(AuthService().isEmailVerified(_firebaseUser));
              },
            ),
            FlatButton(
              child: Text('Resend Verification email?'),
              onPressed: () {},
            ),
            FlatButton(
              child: Text('Click to continue when email is verified'),
              onPressed: () {
                //Navigator.of(context).pop();
                print('Klar med popup');
                setState(() {
                  if (isVerified) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return MyPageView();
                        },
                      ),
                    );
                  }
                });
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
                setState(() {
                  loading = false;
                });
                Navigator.of(context)
                    .pop(); //TODO: When popping try to keep text in forms
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _verificationEmailDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email is already in use'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Unfortunately it seems like the email is already in use. Please try another one'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aight bruh'),
              onPressed: () {
                setState(() {
                  loading = false;
                });
                Navigator.of(context)
                    .pop(); //TODO: When popping try to keep text in forms
              },
            ),
          ],
        );
      },
    );
  }
}
