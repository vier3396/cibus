import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import '../../services/recipe.dart';
import 'popup_body_recipe_individual.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/widgets/ingredientTile.dart';
import 'package:cibus/widgets/ingredientChooserTile.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/services/ingredients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cibus/services/ingredientList.dart';
import 'package:cibus/widgets/ingredientTileWithoutQuantity.dart';

const topMarginPopupIndividualRecipe = 0.0;

class PopupBodyRecipes extends StatefulWidget {
  @override
  _PopupBodyRecipesState createState() => _PopupBodyRecipesState();
}

class _PopupBodyRecipesState extends State<PopupBodyRecipes> {
  String ingredientName = ' ';
  String ingredientSearch;
  Map ingredientMap = Map();
  String ingredientId = '';
  List<String> quantityTypeList = ['gram', 'kg', 'liters'];
  String dropDownValue = 'kg';
  int quantityValue = 5;
  WhatToShow whatToShow = WhatToShow.foundIngredient;
  List<Ingredient> ingredientList = [];
  List<DocumentSnapshot> recipeList = [];

  Widget foundIngredient({whatToShowenum, ingredientMap}) {
    if (whatToShowenum == WhatToShow.none) {
      return Text('We could not find a matching ingredient, please try again');
    } else if (whatToShowenum == WhatToShow.foundIngredient) {
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

    return ChangeNotifierProvider<IngredientList>(
        create: (context) => IngredientList(),
        child:
            Consumer<IngredientList>(builder: (context, ingredientList, child) {
          return Scaffold(
            body: Container(
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
                          Map ingredientMapFromDatabase =
                              await database.getIngredient(ingredientSearch);

                          if (ingredientMapFromDatabase != null) {
                            ingredientList.addIngredient(Ingredient(
                                ingredientId:
                                    ingredientMapFromDatabase['ingredientId'],
                                ingredientName: ingredientMapFromDatabase[
                                    'ingredientName']));
                            List<DocumentSnapshot> recipeListFromDatabase =
                                await database
                                    .findRecipes(ingredientList.ingredientList);
                            print(recipeListFromDatabase[0].data['title']);

                            setState(() {
                              recipeList = recipeListFromDatabase;
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
                        whatToShowenum: whatToShow,
                        ingredientMap: ingredientMap),
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
                                child:
                                    IngredientTileWithoutQuantity(index: index),
                              ),
                            ),
                          );
                        },
                        itemCount: (Provider.of<IngredientList>(context)
                            .ingredientCount),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: InkWell(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image(
                                    image: NetworkImage(
                                        recipeList[index].data['imageURL']),
                                  ),
                                  title: Text(recipeList[index].data['title']),
                                  subtitle: Text(
                                      recipeList[index].data['desctiption']),
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    Text(recipeList[index]
                                        .data['time']
                                        .toString()),
                                    FlatButton(
                                      child: Text(recipeList[index]
                                          .data['rating']
                                          .toString()),
                                      onPressed: () {/* ... */},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: recipeList.length,
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
