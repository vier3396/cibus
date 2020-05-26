import 'package:flutter/material.dart';

class NavigateBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => Navigator.pop(context),
      elevation: 0.0,
      fillColor: Colors.grey[500].withOpacity(0.3),
      child: Icon(
        Icons.arrow_back_ios,
        size: 35.0,
        color: Theme.of(context).backgroundColor,
      ),
      padding: EdgeInsets.all(8.0),
      shape: CircleBorder(),
    );
  }
}