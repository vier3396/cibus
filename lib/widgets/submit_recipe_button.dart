import 'package:cibus/widgets/uploaded_recipe_alert.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';

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
  }
}