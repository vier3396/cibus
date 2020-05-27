import 'package:cibus/services/database.dart';
import 'package:cibus/services/recipe.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:provider/provider.dart';

const kStarIconSize = 35.0;

class AddStarButtons extends StatelessWidget {
  final String recipeID;
  final User user;
  int myRating;
  AddStarButtons({this.user, this.myRating, this.recipeID});

  Widget build(BuildContext context) {
    myRating = myRating ?? 0;
    return ButtonBar(
      // stars for rating, the _currentRating should be linked to each recipe's rating
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.star,
            size: kStarIconSize,
            color: myRating >= 1 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            print(recipeID);
            myRating = 1;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating, userId: user.uid);
            DatabaseService().updateRatings(
              recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
              rating: myRating,
              userId: user.uid,
            );
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            size: kStarIconSize,
            color: myRating >= 2 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 2;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);

            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            size: kStarIconSize,
            color: myRating >= 3 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 3;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);
            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            size: kStarIconSize,
            color: myRating >= 4 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 4;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);

            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            size: kStarIconSize,
            color: myRating >= 5 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 5;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);

            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
      ],
    );
  }
}