import 'package:cibus/services/login/user.dart';
import 'package:flutter/material.dart';
import '../services/database/database.dart';
import '../services/models/recipe.dart';
import 'package:provider/provider.dart';

//TODO make it work

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  Icon favoriteBorderIcon = Icon(Icons.favorite_border);
  Icon favoriteFilledIcon = Icon(Icons.favorite);
  String snackBarFavoritesContent;

  void removeFromFavorites(String id, UserData userData, Recipe recipe) async {
    print(
        'innan removeFromUserFavorites: userData.favoriteList = ${userData.favoriteList}');
    print('recipe.recipeId = ${recipe.recipeId}');
    await DatabaseService(uid: id).removeFromUserFavorites(
        currentFavorites: userData.favoriteList, recipeId: recipe.recipeId);
  }

  addToFavorites(String id, UserData userData, Recipe recipe) async {
    print(
        'innan addToUserFavorites: userData.favoriteList = ${userData.favoriteList}');
    print('recipe.recipeId = ${recipe.recipeId}');
    await DatabaseService(uid: id).addToUserFavorites(
        currentFavorites: userData.favoriteList, recipeId: recipe.recipeId);
  }

  bool isFavorite(Recipe recipe, UserData userData) {
    print('Provider.of<Recipe>(context, listen: false) = $recipe');
    print('userData.favoriteList = ${userData.favoriteList}');
    if (userData.favoriteList.contains(recipe.recipeId)) {
      print('true');
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    Stream<UserData> _userDataStream = DatabaseService(uid: _user.uid).userData;

    return ChangeNotifierProvider<Recipe>(
      create: (context) => Recipe(),
      child: StreamBuilder<UserData>(
          stream: _userDataStream,
          builder: (context, snapshot) {
            UserData userData = snapshot.data;
            return IconButton(
              icon: isFavorite(
                      Provider.of<Recipe>(context, listen: false), userData)
                  ? favoriteFilledIcon
                  : favoriteBorderIcon,
              onPressed: () {
                final recipeProvider =
                    Provider.of<Recipe>(context, listen: false);

                setState(() {
                  if (isFavorite(recipeProvider, userData)) {
                    removeFromFavorites(_user.uid, userData, recipeProvider);
                    snackBarFavoritesContent = "Removed from favorites";
                  } else {
                    addToFavorites(_user.uid, userData, recipeProvider);
                    snackBarFavoritesContent = "Added to favorites";
                  }

                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snackBarFavoritesContent),
                      duration: Duration(seconds: 3),
                    ),
                  );
                });
              },
            );
          }),
    );
  }
}
