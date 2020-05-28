import 'package:cibus/pages/loginScreens/username_screen.dart';
import 'package:cibus/pages/loginScreens/verify_screen.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/pages/loginScreens/e-sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:cibus/services/models/my_page_view.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/pages/loadingScreens/loading_screen.dart';

const registerButtonColor = kTurquoise;
const formSizedBox = SizedBox(height: 20.0);
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
  //int dropdownValue = null;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
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
                            _confirmPass.clear();
                            return 'Minimum 8 characters required';
                          } else if (!val.contains(RegExp(r'[A-Z]'))) {
                            _confirmPass.clear();
                            return 'One upper case letter required.';
                          } else if (!val.contains(RegExp(r'[a-z]'))) {
                            _confirmPass.clear();
                            return 'One lower case letter required.';
                          } else if (!val.contains(RegExp(r'[0-9]'))) {
                            _confirmPass.clear();
                            return 'One digit required.';
                          } else if (!val
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            _confirmPass.clear();
                            return "One special character required.\nSuch as !@#\\&\$*`~";
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
                          if (val.isEmpty) {
                            return 'Re-enter password field is empty';
                          }
                          if (val != _pass.text) {
                            _confirmPass.clear();
                            return 'passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      formSizedBox,
                      TextFormField(
                        controller: _nameController,
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
                        controller: _descriptionController,
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
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            bool isUsernameFree = await DatabaseService()
                                .isUsernameTaken(username: _currentUsername);
                            print(' checkUsername: $isUsernameFree');
                            if (!isUsernameFree) {
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email,
                                      password,
                                      name,
                                      description,
                                      _currentUsername);
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
              child: Text('Ok'),
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
              child: Text('OK'),
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
