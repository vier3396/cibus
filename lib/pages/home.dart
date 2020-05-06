import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Home page'),
          ),
        ),
        body: Center(
          child: Text('This is the home page'),
        ),
      );
  }
}