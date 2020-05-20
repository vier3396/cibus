import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';

class MySpinKitRipple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      color: kDarkerkBackgroundColor,
      size: 90.0,
      duration: Duration(milliseconds: 2000),
    );
  }
}