import 'package:cibus/services/recipeList.dart';
import 'package:cibus/widgets/recipe_preview.dart';
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
                      Provider.of<IngredientList>(context, listen: false)
                          .addIngredient(Ingredient(
                              ingredientId:
                                  ingredientMapFromDatabase['ingredientId'],
                              ingredientName:
                                  ingredientMapFromDatabase['ingredientName']));
                      List<DocumentSnapshot> recipeListFromDatabase =
                          await database.findRecipes(
                              Provider.of<IngredientList>(context,
                                      listen: false)
                                  .ingredientList);
                      //print(recipeListFromDatabase[0].data['title']);

                      setState(() {
                        Provider.of<RecipeList>(context, listen: false)
                            .addEntireRecipeList(recipeListFromDatabase);
                        //recipeList = recipeListFromDatabase;
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
                          child: IngredientTileWithoutQuantity(
                              index: index, parentContext: context),
                        ),
                      ),
                    );
                  },
                  itemCount:
                      (Provider.of<IngredientList>(context).ingredientCount),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        print(Provider.of<RecipeList>(context, listen: false)
                            .recipeList[index]
                            .data['title']);
                        Provider.of<Recipe>(context, listen: false)
                            .addAllIngredientsFromDocument(
                                recipe: Provider.of<RecipeList>(context,
                                        listen: false)
                                    .recipeList[index]
                                    .data,
                                recipeID: Provider.of<RecipeList>(context,
                                        listen: false)
                                    .recipeList[index]
                                    .documentID);
                        print(Provider.of<Recipe>(context, listen: false)
                            .recipeID);

                        final popProvider =
                            Provider.of<Recipe>(context, listen: false);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              //TODO fixa navigator till något bättre?
                              return ChangeNotifierProvider.value(
                                  value: popProvider,
                                  child: RecipePreview(
                                    preview: false,
                                  ));
                              ;
                            },
                          ),
                        );
                        //ta rätt recept från recipeList och hämta ingredienserna
                        // skapa ett recipe objekt och skicka till nästa sida
                        //skicka in recipeList[index] i en funktion och där göra ett nytt recipe
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Image(
                              image: NetworkImage(context
                                      .read<RecipeList>()
                                      .recipeList[index]
                                      .data['imageURL'] ??
                                  'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/images%2F2020-05-08%2011%3A32%3A16.330607.png?alt=media&token=1e4bff1d-c08b-4afa-a1f3-a975e46e89c5'),
                            ),
                            title: Text(context
                                    .read<RecipeList>()
                                    .recipeList[index]
                                    .data['title'] ??
                                '??'),
                            subtitle: Text(context
                                    .read<RecipeList>()
                                    .recipeList[index]
                                    .data['desctription'] ??
                                '??'),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              Text(context
                                      .read<RecipeList>()
                                      .recipeList[index]
                                      .data['time']
                                      .toString() ??
                                  '??'),
                              FlatButton(
                                child: Text(context
                                        .read<RecipeList>()
                                        .recipeList[index]
                                        .data['rating']
                                        .toString() ??
                                    '??'),
                                onPressed: () {
                                  /* ... */
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: Provider.of<RecipeList>(context).recipeList.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
