import 'package:cibus/pages/loginScreens/username_screen.dart';
import 'package:cibus/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/loginScreens/e-sign_in_screen.dart';

const registerButtonColor = kTurquoise;
const formSizedBox = SizedBox(height: 20.0);
const EdgeInsets formPadding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0);
const TextStyle textStyleErrorMessage = TextStyle(color: Colors.red, fontSize: 14.0);
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

  //text field state
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String description = '';
  int age = 0;
  int dropdownValue = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text('Sign up'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign in'),
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
                    decoration: InputDecoration(
                      enabledBorder: textInputBorder,
                      border: textInputBorder,
                      labelText: 'Email',
                    ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
                    validator: (val) => val.length < 6
                        ? 'Enter a password at least 6 chars long'
                        : null,
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
                    validator: (val) => val.isEmpty ? 'Enter your name' : null,
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
                  RaisedButton(
                    color: registerButtonColor,
                    child:
                    Text('Register', style: textStyleRegisterButton),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result =
                        await _auth.registerWithEmailAndPassword(
                            email, password, name, description, age);
                        if (result == null) {
                          setState(() {
                            error = 'Please supply valid email';
                            loading = false;
                          });
                        } else if (result != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return UsernameScreen();
                              },
                            ),
                          );
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
}
