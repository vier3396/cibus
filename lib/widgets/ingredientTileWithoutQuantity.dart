import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/ingredientList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/recipeList.dart';

//TODO ändra så att ingredientTile går att använda för båda istället för att ha två

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
              icon: Icon(Icons.clear),
              onPressed: () async {
                //When remove ingredient update to another query and update the recipelist, if empty clear the list
                Provider.of<IngredientList>(parentContext, listen: false)
                    .removeIngredient(index);
                List<DocumentSnapshot> recipeListFromDatabase = await database
                    .findRecipes(Provider.of<IngredientList>(parentContext,
                            listen: false)
                        .ingredientList);
                if (recipeListFromDatabase == null) {
                  Provider.of<RecipeList>(parentContext, listen: false)
                      .addEntireRecipeList([]);
                } else {
                  //print(recipeListFromDatabase[0].data['title']);

                  Provider.of<RecipeList>(parentContext, listen: false)
                      .addEntireRecipeList(recipeListFromDatabase);
                  //recipeList = recipeListFromDatabase;
                  FocusScope.of(parentContext).requestFocus(FocusNode());
                }
              })
        ],
      ),
    );
  }
}
