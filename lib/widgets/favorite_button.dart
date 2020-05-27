import 'package:cibus/services/colors.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter/material.dart';
import '../services/database/database.dart';
import '../services/models/recipe.dart';
import 'package:provider/provider.dart';

const kFavoriteIconSize = 35.0;

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  Icon favoriteBorderIcon = Icon(
    Icons.favorite_border,
    color: kCoral,
    size: kFavoriteIconSize,
  );
  Icon favoriteFilledIcon = Icon(
    Icons.favorite,
    color: kCoral,
    size: kFavoriteIconSize,
  );
  String snackBarFavoritesContent;

  void removeFromFavorites(String id, UserData userData, Recipe recipe) async {
    await DatabaseService(uid: id).removeFromUserFavorites(
        currentFavorites: userData.favoriteList, recipeId: recipe.recipeId);
  }

  addToFavorites(String id, UserData userData, Recipe recipe) async {
    await DatabaseService(uid: id).addToUserFavorites(
        currentFavorites: userData.favoriteList, recipeId: recipe.recipeId);
  }

  bool isFavorite(Recipe recipe, UserData userData) {
    if (userData.favoriteList.contains(recipe.recipeId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    Stream<UserData> _userDataStream = DatabaseService(uid: _user.uid).userData;

    return Consumer<Recipe>(builder: (context, recipe, child) {
      return StreamBuilder<UserData>(
          stream: _userDataStream,
          builder: (context, snapshot) {
            UserData userData = snapshot.data;
            return IconButton(
              icon: isFavorite(recipe, userData)
                  ? favoriteFilledIcon
                  : favoriteBorderIcon,
              onPressed: () async {
                final recipeProvider =
                    Provider.of<Recipe>(context, listen: false);

                isFavorite(recipeProvider, userData)
                    ? removeFromFavorites(_user.uid, userData, recipeProvider)
                    : addToFavorites(_user.uid, userData, recipeProvider);

                setState(() {
                  isFavorite(recipeProvider, userData)
                      ? snackBarFavoritesContent = "Added to favorites"
                      : snackBarFavoritesContent = "Removed from favorites";
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snackBarFavoritesContent),
                      duration: Duration(seconds: 3),
                    ),
                  );
                });
              },
            );
          });
    });
  }
}
