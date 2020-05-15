import 'package:flutter/material.dart';
import '../../services/recipe.dart';

const TextStyle ingredientsTitleStyle = TextStyle(
  fontSize: 18.0,
);
const Divider divider = Divider(
  thickness: 1.0,
);

class PopupBodyIndividualRecipe extends StatefulWidget {
  Recipe recipe;
  PopupBodyIndividualRecipe({
    @required this.recipe,
  });

  @override
  _PopupBodyIndividualRecipeState createState() =>
      _PopupBodyIndividualRecipeState();
}

class _PopupBodyIndividualRecipeState extends State<PopupBodyIndividualRecipe> {
  Icon favoriteBorderIcon = Icon(Icons.favorite_border);
  Icon favoriteFilledIcon = Icon(Icons.favorite);

  //initial favorites icon is heart icon with boarder, and isFavorite = false,
  //tooltip showing "Add to favorites"
  bool isFavorite = false;
  String favoritesToolTip = "Add to favorites";

  //Snackbar is the popup message on bottom of screen showing when added/removed from favorites
  String snackBarFavoritesContent;

  Widget getTextWidgets(List<String> strings) //services?
  {
    print(strings.length);
    List<Text> list = new List<Text>();
    for (var i = 0; i < strings.length; i++) {
      if (strings[i] != null) {
        list.add(new Text(strings[i]));
      }
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              try {
                Navigator.pop(context); //close the popup
              } catch (e) {}
            },
          );
        }),
        actions: [
          //add/remove from favorites button
          Builder(builder: (context) {
            return IconButton(
              icon: isFavorite ? favoriteFilledIcon : favoriteBorderIcon,
              //tooltip: isFavorite ? "Add to favorites" : "Remove from favorites",
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;

                  snackBarFavoritesContent = isFavorite
                      ? "Added to favorites"
                      : "Removed from favorites";

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
        ],
        //brightness: Brightness.light,
      ),
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          Image.asset(
            widget.recipe.imageURL,
            width: MediaQuery.of(context).size.width,
            //TODO: image size problem
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                ),
              ),
              //TODO: add the number of ratings
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.recipe.description),
          ),
          divider,
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Ingredients",
              style: ingredientsTitleStyle,
            ),
          ),
          //getTextWidgets(widget.recipe.listOfSteps),
          //TODO: View recipe ingredients
          getTextWidgets(widget.recipe.listOfSteps),
        ],
      ),
    );
  }
}
