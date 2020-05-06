import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/loginScreens/register_screen.dart';
import 'package:cibus/services/colors.dart';

const TextStyle textStyleErrorMessage = TextStyle(color: Colors.red, fontSize: 14.0);

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

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Sign in to Cibus'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
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
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
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
                      RaisedButton(
                        color: kTurquoise,
                        child: Text('Sign In',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
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
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: textStyleErrorMessage,
                      ),
                    ]))));
  }
}
