import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/my_text_form_field.dart';
import 'package:cibus/services/popup.dart';
import 'package:cibus/services/popup_body_search_ingredients.dart';
import 'package:cibus/services/popup_body_recipes.dart';

const circleAvatarRadius = 30.0;
const circleAvatarSize = 40.0;
const topMarginPopupRecipes = 0.0;

class SearchRecipe extends StatefulWidget {
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Search recipe'),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextFormField(
                maxLength: 20,
                labelText: "Add ingredient",
                onTap: () {
                  PopupLayout().showPopup(
                      context, popupBodySearchIngredients(), 'Add Ingredient');
                },
                //TODO:  onSaved: save ingredients to recipe object
                //TODO: validator: validate ingredients
              ),
            ),
            //TODO View chosen ingredients
            ListView(
              shrinkWrap: true,
              children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: circleAvatarRadius,
                          child: Icon(Icons.fastfood,
                            size: circleAvatarSize,
                          ),
                        ),
                        Text("Vegan"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: circleAvatarRadius,
                          child: Icon(Icons.adb,
                            size: circleAvatarSize,
                          ),
                        ),
                        Text("Robot"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: circleAvatarRadius,
                          child: Icon(Icons.airline_seat_recline_normal,
                            size: circleAvatarSize,
                          ),
                        ),
                        Text("Flygplan"),
                      ],
                    ),
                  ),
                ],
              )
            ],
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: MaterialButton(
                  color: Colors.purple,
                  height: 55.0,
                  child: Row(children: <Widget>[
                    Text("Number of recipes"),
                    Icon(Icons.arrow_forward_ios),
                  ],
                  ),
                  onPressed: () {
                    PopupLayout(top: topMarginPopupRecipes).showPopup(context,
                        PopupBodyRecipes(), 'Recipes');
                  },
                ),
              ),
            ),
            ],
          ),
        ),
    );
  }

}
