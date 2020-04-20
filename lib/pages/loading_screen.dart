import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 120.0,
              ),
              Text(
                'CIBUS',
                style: TextStyle(
                  fontSize: 50.0,
                  letterSpacing: 3.0,
                  color: cibusTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/peach.jpg'),
                radius: 80.0,
              ),
              SizedBox(
                height: 80.0,
              ),
              SpinKitRipple(
                color: darkerBackgroundColor,
                size: 90.0,
                duration: Duration(milliseconds: 2000),
              ),
              SizedBox(
                height: 30.0
              ),
              // Text("vi löser mat"), // KLATCHIG fras
            ],
          ),
        ),
      )
    );
  }
}
