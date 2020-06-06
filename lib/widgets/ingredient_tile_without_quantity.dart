import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/ingredient_list.dart';
import 'package:cibus/services/database/database.dart';
import 'file:///C:/cibus/lib/services/models/user.dart';
import 'package:cibus/services/models/recipe_list.dart';

class IngredientTileWithoutQuantity extends StatelessWidget {
  final int index;
  final double width = 50.0;
  final BuildContext parentContext;

  IngredientTileWithoutQuantity({this.index, this.parentContext});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);
    return Container(
      padding: EdgeInsets.all(7.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Text(Provider.of<IngredientList>(parentContext)
              .ingredientList[index]
              .ingredientName),
          IconButton(
              icon: Icon(Icons.delete, color: Colors.black38),
              onPressed: () async {
                //When remove ingredient update to another query and update the recipelist, if empty clear the list
                Provider.of<IngredientList>(parentContext, listen: false)
                    .removeIngredient(index);
                List<Map> recipeListFromDatabase = await database.findRecipes(
                    Provider.of<IngredientList>(parentContext, listen: false)
                        .ingredientList);
                if (recipeListFromDatabase == null) {
                  Provider.of<RecipeList>(parentContext, listen: false)
                      .addEntireRecipeList([]);
                } else {
                  Provider.of<RecipeList>(parentContext, listen: false)
                      .addEntireRecipeList(recipeListFromDatabase);
                  FocusScope.of(parentContext).requestFocus(FocusNode());
                }
              })
        ],
      ),
    );
  }
}
