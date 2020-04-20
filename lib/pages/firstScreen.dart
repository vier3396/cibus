import 'package:flutter/material.dart';
import 'package:cibus/services/sign_in.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.blue[100],
        child: Center(
          child: RaisedButton(
            color: Colors.orange[600],
            hoverColor: Colors.orange,
            child: Text('Sign Out'),
            onPressed: () {
              signOutGoogle();
            },
          ),
        )),
    );
  }
}