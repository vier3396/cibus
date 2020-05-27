import 'package:cibus/pages/userScreens/user_page.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorWidget extends StatelessWidget {
  final String userId;
  AuthorWidget({this.userId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        UserData userData = await DatabaseService().getUserData(userId);
        List<Recipe> recipes = await DatabaseService().findUserRecipes(userId);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserPage(
                      recipes: recipes,
                      userData: userData,
                    )));
      },
      child: Text(
        Provider.of<Recipe>(context).username ?? 'username',
        style: TextStyle(
            fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
