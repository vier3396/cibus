import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:flutter/material.dart';

import 'horizontal_list_view.dart';

class RecipesHomePage extends StatelessWidget {
  final List<dynamic> recipes;
  final String title;
  RecipesHomePage({this.recipes, this.title});

  Future<List<Recipe>> getRecipes() async {
    return await DatabaseService().findFavoriteRecipes(recipes);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRecipes(),
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
              if (futureSnapshot.hasData) {
                List<Recipe> _topRecipes = futureSnapshot.data;
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: HorizontalListView(
                    title: title,
                    recipes: _topRecipes,
                    myFavorites: false,
                  ),
                );
              } else {
                return Center(
                  child: Text(
                      'Something went wrong'),
                );
              }
          }
          return Text('There\'s no available data.');
        });
  }
}
