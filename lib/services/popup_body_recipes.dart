import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import 'recipe.dart';
import 'popup.dart';
import 'popup_body_recipe_individual.dart';

const topMarginPopupIndividualRecipe = 0.0;

class PopupBodyRecipes extends StatefulWidget {
  @override
  _PopupBodyRecipesState createState() => _PopupBodyRecipesState();
}

class _PopupBodyRecipesState extends State<PopupBodyRecipes> {
  List<Recipe> recipes = [
    Recipe(
      title: "Recipe 1",
      description: description1,
      listOfSteps: listOfStepsRecipe1,
      imageFile: "assets/recipe1.jpg",
      time: 30,
      rating: 3.5,
    ),
    Recipe(
      title: "Recipe 2",
      description: description2,
      listOfSteps: listOfStepsRecipe2,
      imageFile: "assets/recipe2.jpg",
      time: 120,
      rating: 4,
    ),
    Recipe(
      title: "Kladdkaka med annansgrädde",
      description: description3,
      listOfSteps: listOfStepsRecipe3,
      imageFile: "assets/recipe3.jpg",
      time: 90,
      rating: 5,
    ),
    Recipe(
      title: "Recipe 4",
      description: description4,
      listOfSteps: listOfStepsRecipe4,
      imageFile: "assets/recipe4.jpg",
      time: 40,
      rating: 5,
    ),
    Recipe(
      title: "Recipe 5",
      description: description5,
      listOfSteps: listOfStepsRecipe5,
      imageFile: "assets/recipe5.jpg",
      time: 50,
      rating: 1,
    )
  ];

  static String description1 = "This recipe is awsome";
  static String description2 = "My moms recipe";
  static String description3 = "Homemade and crazy good!";
  static String description4 = "OK recipe";
  static String description5 = "Hello I'm a recipe. Blabla Blabla Blabla Blab";

  static List<String> listOfStepsRecipe1;
  static List<String> listOfStepsRecipe2;
  static List<String> listOfStepsRecipe3;
  static List<String> listOfStepsRecipe4;
  static List<String> listOfStepsRecipe5;

  static bool isFavorite = false;

  Icon snackBarFavoritesIcon = favoritesIcon;
  String favoritesToolTip = snackBarFavoritesContent;

  static Icon favoritesIcon = Icon(Icons.favorite_border);
  static Icon favoritesIconFilled = Icon(Icons.favorite);

  static String snackBarFavoritesContent = "Added to favorites";

  SnackBar snackBarFavorites = SnackBar(
    content: Text(snackBarFavoritesContent),
  );

  //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            onTap: () {
              print(recipes[index].title + " got pressed");
              PopupLayout(
                top: topMarginPopupIndividualRecipe,
                appBarActions: [
                  IconButton(
                    icon: favoritesIcon,
                    tooltip: favoritesToolTip,
                    onPressed: () {
                      setState(() {
                        //funkar
                        //isFavorite = !isFavorite;

                        /*
                        //change icon when pressing favorites icon
                        snackBarFavoritesIcon = isFavorite
                            ? favoritesIconFilled
                            : favoritesIcon;

                            //change tooltip
                            favoritesToolTip =
                            isFavorite ? "Remove from favorites" : "Add to favorites";

                            //change snackbar content text when pressing favorites icon
                            snackBarFavoritesContent = isFavorite ? "Removed from favorites" :
                            "Added to favorites";

                            //show snackbar when pressing favorites icon
                            Scaffold.of(context).showSnackBar(snackBarFavorites);

                            //show snackbar using scaffold key
                            //scaffoldKey.currentState.showSnackBar(snackBarFavorites);
                             */
                        //TODO: Add recipe to user favorites
                      });
                    },
                  ),
                ],
              ).showPopup(
                  context,
                  PopupBodyIndividualRecipe(recipe: recipes[index]),
                  recipes[index].title);
            },
            title: Text(
              recipes[index].title,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            leading: GFAvatar(
              shape: GFAvatarShape.square,
              size: GFSize.LARGE,
              backgroundImage: AssetImage(recipes[index].imageFile),
            ),
            subtitle: Text(recipes[index].description),
            trailing: Column(
              children: <Widget>[
                Text((recipes[index].time).toString() + " min"),
                Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                ),
                Text((recipes[index].rating).toString()),
              ],
            ),
          ));
        });
  }
}
