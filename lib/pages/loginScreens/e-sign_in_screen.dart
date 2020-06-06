import 'file:///C:/cibus/lib/widgets/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/pages/loadingScreens/loading_screen.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/pages/loginScreens/register_screen.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

const TextStyle textStyleErrorMessage =
    TextStyle(color: Colors.red, fontSize: 14.0);

OutlineInputBorder textInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25.0),
);

class EmailSignIn extends StatefulWidget {
  final Function toggleView;
  EmailSignIn({this.toggleView});

  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  //text field state
  String email = '';
  String password = '';
  String error = '';
  String forgotEmail = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: Text('Register new user'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: kFormPadding,
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Sign in with email',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: textInputBorder,
                          labelText: 'Email',
                        ),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: textInputBorder,
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (val) => val.length < 8
                            ? 'Enter a password at least 8 characters long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: kButtonPadding,
                            child: RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                  await _auth.signInWithEmailAndPassword(
                                      email, password);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                      'Could not sign in with those credentials';
                                      loading = false;
                                    });
                                  } else {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => MyPageView()),
                                            (Route<dynamic> route) => false);
                                  }
                                }
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
                                  'Forgot password?',
                                  style: TextStyle(
                                      fontSize: 15.0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                _forgotDialog();
                              },
                              color: Colors.grey[300],
                              splashColor: kWarmOrange,
                              shape: kButtonShape,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: textStyleErrorMessage,
                      ),
                    ])),
              ),
            ));
  }

  Future<void> _forgotDialog() async {
    String errorMessage = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot your password?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                        'Enter your email and we will send you a link to change your password'),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        border: textInputBorder,
                        labelText: 'Email',
                      ),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => forgotEmail = val);
                      },
                    ),
                    SizedBox(height: 30.0),
                    Text(errorMessage),
                    SizedBox(height: 20.0),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: kCoral,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          loading = false;
                        });
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          color: kCoral,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = false;
                        });
                        try {
                          await _authInstance.sendPasswordResetEmail(
                              email: forgotEmail);
                          Navigator.of(context).pop();
                        } catch (e) {
                          print(e.message);
                          setState(() {
                            errorMessage = e.message;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
