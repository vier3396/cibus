import 'package:cibus/services/models/my_page_view.dart';
import 'package:flutter/material.dart';

class UploadedRecipeAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Your recipe is now uploaded!'),
      content: FlatButton(
        child: Text('Take me to home page'),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyPageView()),
              (Route<dynamic> route) => false);
        },
      ),
    );
  }
}
