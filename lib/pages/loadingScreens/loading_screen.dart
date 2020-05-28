import 'package:cibus/services/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kCoral,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: 150.0),
                child: Image.asset(
                  'assets/coral_lemon.png',
                  width: 250.0,
                  height: 250.0,
                ),
              ),
              Center(child: kCibusLogoText),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: MySpinKitRipple(),
              ),
            ],
          ),
        ));
  }
}
