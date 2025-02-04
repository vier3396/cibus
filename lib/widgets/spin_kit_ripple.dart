import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/colors.dart';

class MySpinKitRipple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      color: kSpinKitColor,
      size: 90.0,
      duration: Duration(milliseconds: 2000),
    );
  }
}
