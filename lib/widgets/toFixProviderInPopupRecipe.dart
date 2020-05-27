import 'package:cibus/pages/searchRecipeScreens/popup_body_recipes.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/recipeList.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
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
import 'package:cibus/services/recipe.dart';
import 'package:cibus/pages/adminPage.dart';

class WidgetToFixProvider extends StatelessWidget {
  final bool admin;

  WidgetToFixProvider({
    this.admin,
  });

  //TODO byt till multiprovider och byt namn
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeList>(
      create: (context) => RecipeList(),
      child: ChangeNotifierProvider<Recipe>(
        create: (context) => Recipe(),
        child: ChangeNotifierProvider<IngredientList>(
          create: (context) => IngredientList(),
          child: admin ? AdminPage() : PopupBodyRecipes(),
        ),
      ),
    );
  }
}
