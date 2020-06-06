import 'package:cibus/services/database/database.dart';
import 'file:///C:/cibus/lib/services/models/user.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:flutter/material.dart';

import 'horizontal_list_view.dart';

class FutureBuilderFavorites extends StatelessWidget {
  FutureBuilderFavorites({@required this.userData});
  final UserData userData;

  Future<List<Recipe>> getFavoriteRecipes(UserData userData) async {
    return await DatabaseService().findFavoriteRecipes(userData.favoriteList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFavoriteRecipes(userData),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.hasError)
          return Text('Error: ${futureSnapshot.error}');
        switch (futureSnapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            {
              if (futureSnapshot.hasData) {
                List<Recipe> favorites = futureSnapshot.data;
                if (favorites.isNotEmpty) {
                  return HorizontalListView(
                    title: 'Your favorites',
                    recipes: favorites,
                    myFavorites: true,
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Check out our large database of recipes',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        //letterSpacing: 1.1,
                      ),
                    ),
                  );
                }
              }
              return Text('There\'s no available data.');
            }
        }
        return null;
      },
    );
  }
}
