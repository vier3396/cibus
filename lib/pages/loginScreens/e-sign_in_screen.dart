import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/loginScreens/register_screen.dart';
import 'package:cibus/services/colors.dart';
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
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                'Sign in to Cibus',
                style: TextStyle(color: kCoral),
              ),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: kCoral,
                  ),
                  label: Text('Register', style: TextStyle(color: kCoral)),
                  onPressed: () {
                    //widget.toggleView();
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
            body: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: textInputBorder,
                          labelText: 'Email',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
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
                        validator: (val) => val.length < 6
                            ? 'Enter a password at least 6 chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            color: kCoral,
                            child: Text('Forgot password',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              _forgotDialog();
                            },
                          ),
                          SizedBox(width: 40.0),
                          RaisedButton(
                            color: kCoral,
                            child: Text('Sign In',
                                style: TextStyle(color: Colors.white)),
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
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: textStyleErrorMessage,
                      ),
                    ]))));
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
                FlatButton(
                  child: Text('Reset Password'),
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
                      //print('runtimeType: $e.runtimeType');
                      setState(() {
                        errorMessage = e.message;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
