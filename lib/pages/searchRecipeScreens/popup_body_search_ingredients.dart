import 'package:cibus/services/models/colors.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:cibus/widgets/ingredient_chooser_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/database/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/user.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/widgets/ingredient_tile.dart';

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
  int quantityValue = 5;
  WhatToShow whatToShow = WhatToShow.notYetSea;
  final TextEditingController searchController = TextEditingController();

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
              controller: searchController,
              onChanged: (toSearch) {
                ingredientSearch = toSearch.toLowerCase();
              },
              onSubmitted: (toSearch) async {
                ingredientMap = await database.getIngredient(ingredientSearch);
                if (ingredientMap != null) {
                  setState(() {
                    ingredientName = ingredientMap['ingredientName'];
                    ingredientId = ingredientMap['ingredientId'];
                    whatToShow = WhatToShow.foundIngredient;
                    FocusScope.of(context).requestFocus(FocusNode());
                    searchController.clear();
                  });
                } else if (ingredientMap == null) {
                  setState(() {
                    whatToShow = WhatToShow.none;
                  });
                }
              },
            ),
            FlatButton(
                onPressed: () async {
                  ingredientMap =
                      await database.getIngredient(ingredientSearch);
                  if (ingredientMap != null) {
                    setState(() {
                      ingredientName = ingredientMap['ingredientName'];
                      ingredientId = ingredientMap['ingredientId'];
                      whatToShow = WhatToShow.foundIngredient;
                      FocusScope.of(context).requestFocus(FocusNode());
                      searchController.clear();
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
                    duration: Duration(milliseconds: 500),
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
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: RaisedButton(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: kCoral,
                splashColor: kWarmOrange,
                shape: kButtonShape,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
