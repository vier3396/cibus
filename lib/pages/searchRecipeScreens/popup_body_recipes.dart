import 'package:flutter/material.dart';
import '../../services/models/recipe.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/ingredient_chooser_tile.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/services/models/ingredients.dart';
import 'package:cibus/services/models/ingredient_list.dart';
import 'package:cibus/widgets/ingredient_tile_without_quantity.dart';
import 'package:cibus/services/models/recipe_list.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:cibus/widgets/show_rating.dart';

class PopupBodyRecipes extends StatefulWidget {
  @override
  _PopupBodyRecipesState createState() => _PopupBodyRecipesState();
}

class _PopupBodyRecipesState extends State<PopupBodyRecipes> {
  String ingredientName = ' ';
  String ingredientSearch;
  Map ingredientMap = Map();
  String ingredientId = '';
  WhatToShow whatToShow = WhatToShow.foundIngredient;
  List<Ingredient> ingredientList = [];
  List<Map> recipeList = [];
  List<Recipe> recipeClassList = [];
  final TextEditingController searchController = TextEditingController();

  Widget foundIngredient({whatToShowenum, ingredientMap}) {
    if (whatToShowenum == WhatToShow.none) {
      return Text('Could not find a matching ingredient, please try again');
    } else if (whatToShowenum == WhatToShow.foundIngredient) {
      return Container();
    }
    return IngredientChooserTile(
        ingredientName: ingredientMap['ingredientName'],
        ingredientId: ingredientMap['ingredientId']);
  }

  @override
  void dispose() {
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
              controller: searchController,
              decoration: InputDecoration(
                  hintText: 'Search for your ingredients to find recipes !'),
              onChanged: (toSearch) {
                ingredientSearch = toSearch.toLowerCase();
                print(ingredientSearch);
              },
              onSubmitted: (toSearch) async {
                Map ingredientMapFromDatabase =
                    await database.getIngredient(ingredientSearch);

                if (ingredientMapFromDatabase != null) {
                  Provider.of<IngredientList>(context, listen: false)
                      .addIngredient(Ingredient(
                          ingredientId:
                              ingredientMapFromDatabase['ingredientId'],
                          ingredientName:
                              ingredientMapFromDatabase['ingredientName']));
                  List<Map> recipeListFromDatabase = await database.findRecipes(
                      Provider.of<IngredientList>(context, listen: false)
                          .ingredientList);

                  setState(() {
                    Provider.of<RecipeList>(context, listen: false)
                        .addEntireRecipeList(recipeListFromDatabase);
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

                    setState(() {
                      Provider.of<RecipeList>(context, listen: false)
                          .addEntireRecipeList(recipeListFromDatabase);
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
                child: Text('Search', style: TextStyle(fontSize: 16),)),
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
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image(
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.spaceBetween,
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
                              Column(
                                children: <Widget>[
                                  Text(context
                                          .read<RecipeList>()
                                          .recipeList[index]['time']
                                          .toString() ??
                                      '??'),
                                  Text("min"),
                                ],
                              ),
                            ],
                          ),
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
