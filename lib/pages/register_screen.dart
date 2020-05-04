import 'package:flutter/material.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/services/login/e-sign_in.dart';



class RegisterScreen extends StatefulWidget {

  final Function toggleView;
  RegisterScreen({ this.toggleView });

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
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: Text('Sign up to Cibus'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign in'),
              onPressed: () {
                //widget.toggleView();
                Navigator.of(context).push(
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
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.length < 6 ? 'Enter a password at least 6 chars long' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Name'),
                        validator: (val) => val.isEmpty ? 'Enter your name' : null,
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Description'),
                        validator: (val) => val.isEmpty ? 'Enter your description' : null,
                        onChanged: (val) {
                          setState(() => description = val);
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Age'),
                        value: dropdownValue,
                        onChanged: (newAge) {
                          setState(() {
                            dropdownValue = newAge;
                            age = newAge;
                        });},
                          items: <int>[0, 1, 2, 3, 4]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          })
                              .toList(),
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, description, age);
                            if(result == null) {
                              setState(() {
                                error = 'Please supply valid email';
                                loading = false;
                              });
                            }
                          }
                        },

                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ]
                )
            ))
    );
  }
}

