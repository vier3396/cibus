import 'package:cibus/pages/user_page.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/recipe.dart';
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
      child: Text(Provider.of<Recipe>(context).username ?? 'userName',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}