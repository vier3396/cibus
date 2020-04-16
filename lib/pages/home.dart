import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Home page'),
          ),
        ),
        body: Center(
          child: Text('This is the home page'),
        ),
      ),
    );
  }
}
