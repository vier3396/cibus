import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// final halfMedianWidth = MediaQuery.of(context).size.width / 2.0; //(for different screens)

TextStyle cibusLogoTextStyle = TextStyle(
  fontSize: 50.0,
  letterSpacing: 3.0,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kCoral,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: 150.0), //TODO: have to work for multiple screens
                child: Image.asset(
                  'assets/pink_lemon.png',
                  width: 250.0,
                  height: 250.0,
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: 150.0),
                child: Text(
                  'CIBUS',
                  style: cibusLogoTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinKitRipple(
                  color: kDarkerkBackgroundColor,
                  size: 90.0,
                  duration: Duration(milliseconds: 2000),
                ),
              ),
            ],
          ),
        ));
  }
}
