import 'package:cibus/services/models/colors.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/uploaded_recipe_alert.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/login/user.dart';

/*
class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
      ),
      onTap: () async {
        User user = Provider.of<User>(context, listen: false);
        DatabaseService database = DatabaseService(uid: user.uid);
        String username = await database.getUsername();
        Provider.of<Recipe>(context, listen: false)
            .addUserIdAndUsername(uid: user.uid, username: username);
        database.uploadRecipe(Provider.of<Recipe>(context, listen: false));
        showDialog(
          context: context,
          builder: (context) {
            return UploadedRecipeAlert();
          },
        );
      },
    );

 */
class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: RaisedButton(
        color: kCoral,
        splashColor: kWarmOrange,
        shape: kButtonShape,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Submit',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0),
          ),
        ),
        onPressed: () async {
          User user = Provider.of<User>(context, listen: false);
          DatabaseService database = DatabaseService(uid: user.uid);
          String username = await database.getUsername();
          Provider.of<Recipe>(context, listen: false)
              .addUserIdAndUsername(uid: user.uid, username: username);
          database.uploadRecipe(Provider.of<Recipe>(context, listen: false));
          showDialog(
            context: context,
            builder: (context) {
              return UploadedRecipeAlert();
            },
          );
        },
      ),
    );


  }



}
