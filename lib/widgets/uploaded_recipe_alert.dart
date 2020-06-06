import 'package:cibus/services/models/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/widgets/my_page_view.dart';

class UploadedRecipeAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Your recipe is now uploaded!'),
      content: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.favorite_border, color: kCoral,),
            Text('Back to home page', style: TextStyle(color: kCoral),),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyPageView()),
              (Route<dynamic> route) => false);
        },
      ),
    );
  }
}
