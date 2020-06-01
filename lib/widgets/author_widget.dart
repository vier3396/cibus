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
    return RawMaterialButton(
      onPressed: () async {
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
      elevation: 0.0,
      fillColor: Colors.grey[500].withOpacity(0.3),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              Provider.of<Recipe>(context).username ?? 'username',
              style: TextStyle(
                  fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Icon(Icons.person, size: 25, color: Colors.white,),
          ],
        ),
      ),
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}

/*


InkWell(
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
      child: Row(
        children: <Widget>[
          Text(
            Provider.of<Recipe>(context).username ?? 'username',
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.person, size: 25,),
        ],
      ),
    )

 */
