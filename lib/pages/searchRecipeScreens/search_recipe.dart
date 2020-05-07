import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/my_text_form_field.dart';
import 'package:cibus/services/popup_layout.dart';
import 'package:cibus/services/popup_body_search_ingredients.dart';
import 'package:cibus/pages/searchRecipeScreens/popup_body_recipes.dart';
import 'package:cibus/services/colors.dart';

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
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextFormField(
                  maxLength: 20,
                  labelText: "Add ingredient",
                  onTap: () {
                    PopupLayout().showPopup(context,
                        PopupBodySearchIngredients(), 'Add Ingredient');
                  },
                  //TODO:  onSaved: save ingredients to recipe object
                  //TODO: validator: validate ingredients
                ),
              ),
              //TODO View chosen ingredients
              ListView(
                shrinkWrap: true, //to solve overflow problem
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.teal[800],
                              radius: circleAvatarRadius,
                              child: Icon(
                                Icons.fastfood,
                                size: circleAvatarSize,
                                color: Colors.white,
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
                              backgroundColor: kPalePink,
                              radius: circleAvatarRadius,
                              child: Icon(
                                Icons.fastfood,
                                size: circleAvatarSize,
                                color: Colors.white,
                              ),
                            ),
                            Text("Lactose"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: kVibrantYellow,
                              radius: circleAvatarRadius,
                              child: Icon(
                                Icons.fastfood,
                                size: circleAvatarSize,
                                color: Colors.white,
                              ),
                            ),
                            Text("Gluten"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: kSkyBlue,
                              radius: circleAvatarRadius,
                              child: Icon(
                                Icons.fastfood,
                                size: circleAvatarSize,
                                color: Colors.white,
                              ),
                            ),
                            Text("Other"),
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
                    color: kWarmOrange,
                    height: 55.0,
                    child: Row(
                      children: <Widget>[
                        Text("Number of recipes"),
                        //TODO: Count number of recipes found
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onPressed: () {
                      PopupLayout(top: topMarginPopupRecipes)
                          .showPopup(context, PopupBodyRecipes(), 'Recipes');
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
