import 'package:flutter/material.dart';
import '../../services/recipe.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/widgets/ingredientChooserTile.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/services/ingredients.dart';
import 'package:cibus/services/ingredientList.dart';
import 'package:cibus/widgets/ingredientTileWithoutQuantity.dart';
import 'package:cibus/services/recipeList.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:cibus/widgets/show_rating.dart';

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
  int quantityValue = 5;
  WhatToShow whatToShow = WhatToShow.foundIngredient;
  List<Ingredient> ingredientList = [];
  List<Map> recipeList = [];
  List<Recipe> recipeClassList = [];

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
  void dispose() {
    print('nu disposas');
    // TODO: implement dispose
    super.dispose();
  }

  void updateRecipe() {}
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText:
                      'Enter your ingredient to find the best recipes in the bizz'),
              onChanged: (toSearch) {
                ingredientSearch = toSearch.toLowerCase();
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
                    List<Map> recipeListFromDatabase =
                        await database.findRecipes(
                            Provider.of<IngredientList>(context, listen: false)
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
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () async {
                      print(Provider.of<RecipeList>(context, listen: false)
                          .recipeList[index]['title']);

                      Provider.of<Recipe>(context, listen: false)
                          .addAllPropertiesFromDocument(
                              recipe: Provider.of<RecipeList>(context,
                                      listen: false)
                                  .recipeList[index],
                              recipeID: Provider.of<RecipeList>(context,
                                      listen: false)
                                  .recipeList[index]['recipeId']);

                      User user = Provider.of<User>(context, listen: false);
                      DatabaseService database = DatabaseService(uid: user.uid);

                      int myRating = await database.getYourRating(
                          recipeId:
                              Provider.of<RecipeList>(context, listen: false)
                                  .recipeList[index]['recipeId'],
                          userId: user.uid);
                      Provider.of<Recipe>(context, listen: false)
                          .addYourRating(rating: myRating);
                      print(Provider.of<Recipe>(context, listen: false)
                          .yourRating);

                      final popProvider =
                          Provider.of<Recipe>(context, listen: false);
                      final recipeListProvider =
                          Provider.of<RecipeList>(context, listen: false);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            //TODO fixa navigator till något bättre?
                            return ChangeNotifierProvider.value(
                              value: recipeListProvider,
                              child: ChangeNotifierProvider.value(
                                  value: popProvider,
                                  child: RecipePreview(
                                    preview: false,
                                    index: index,
                                  )),
                            );
                          },
                        ),
                      );
                      //ta rätt recept från recipeList och hämta ingredienserna
                      // skapa ett recipeobjekt och skicka till nästa sida
                      //skicka in recipeList[index] i en funktion och där göra ett nytt recipe
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image(
                            image: NetworkImage(context
                                    .read<RecipeList>()
                                    .recipeList[index]['imageURL'] ??
                                kDefaultRecipePic),
                          ),
                          title: Text(context
                                  .read<RecipeList>()
                                  .recipeList[index]['title'] ??
                              '??'),
                          subtitle: Text(context
                                  .read<RecipeList>()
                                  .recipeList[index]['description'] ??
                              '??'),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ShowRating(
                                    rating: context
                                                .read<RecipeList>()
                                                .recipeList[index]
                                            ['averageRating'] ??
                                        0,
                                    imageHeight: 20.0),
                                Text(context
                                        .read<RecipeList>()
                                        .recipeList[index]['averageRating']
                                        .toStringAsPrecision(2)
                                        .toString() ??
                                    '??'),
                              ],
                            ),
                            SizedBox(width: 50),
                            Column(
                              children: <Widget>[
                                Text(context
                                        .read<RecipeList>()
                                        .recipeList[index]['time']
                                        .toString() ??
                                    '??'),
                                Text("minutes"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: Provider.of<RecipeList>(context).recipeCount,
            ),
          ],
        ),
      ),
    );
  }
}
