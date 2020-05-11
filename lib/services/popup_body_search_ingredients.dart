import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/widgets/ingredientChooserTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_text_form_field.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'dart:convert';
import 'package:cibus/services/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/widgets/ingredientTile.dart';

class PopupBodySearchIngredients extends StatefulWidget {
  @override
  _PopupBodySearchIngredientsState createState() =>
      _PopupBodySearchIngredientsState();
}

class _PopupBodySearchIngredientsState
    extends State<PopupBodySearchIngredients> {
  String ingredientName = ' ';
  String ingredientSearch;
  Map ingredientMap = Map();
  String ingredientId = '';
  List<String> quantityTypeList = ['gram', 'kg', 'liters'];
  String dropDownValue = 'kg';
  int quantityValue = 5;
  WhatToShow whatToShow = WhatToShow.notYetSea;

  Widget foundIngredient({whatToShowenum, ingredientMap}) {
    if (whatToShowenum == WhatToShow.none) {
      return Text('We could not find a matching ingredient, please try again');
    } else if (whatToShowenum == WhatToShow.notYetSea) {
      return Container();
    }
    return IngredientChooserTile(
        ingredientName: ingredientMap['ingredientName'],
        ingredientId: ingredientMap['ingredientId']);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);

    return Container(
      decoration: BoxDecoration(
          color: Color(0xff757575),
          border: Border.all(color: Color(0xff757575))),
      height: 550.0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          children: <Widget>[
            TextField(
              onChanged: (toSearch) {
                ingredientSearch = toSearch;
                ingredientSearch =
                    "${ingredientSearch[0].toUpperCase()}${ingredientSearch.substring(1)}";
                print(ingredientSearch);
              },
            ),
            FlatButton(
                onPressed: () async {
                  ingredientMap =
                      await database.getIngredient(ingredientSearch);
                  print(ingredientMap);
                  if (ingredientMap != null) {
                    setState(() {
                      print(ingredientMap['ingredientName']);
                      ingredientName = ingredientMap['ingredientName'];
                      ingredientId = ingredientMap['ingredientId'];
                      whatToShow = WhatToShow.foundIngredient;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  } else if (ingredientMap == null) {
                    setState(() {
                      whatToShow = WhatToShow.none;
                    });
                  }
                },
                child: Text('Search')),
            foundIngredient(
                whatToShowenum: whatToShow, ingredientMap: ingredientMap),
            AnimationLimiter(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 3,
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: IngredientTile(index: index),
                      ),
                    ),
                  );
                },
                itemCount: (Provider.of<Recipe>(context).ingredientCount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Row(
//              children: <Widget>[
//                Text(Provider.of<Recipe>(context)
//                    .ingredients[index]
//                    .ingredientName),
//                Text(
//                    '${Provider.of<Recipe>(context).ingredients[index].quantity}'),
//                Text(Provider.of<Recipe>(context)
//                    .ingredients[index]
//                    .quantityType),
//              ],
//            );
