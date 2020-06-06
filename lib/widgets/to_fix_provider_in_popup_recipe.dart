import 'package:cibus/pages/searchRecipeScreens/popup_body_recipes.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/recipe_list.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/ingredient_list.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:cibus/pages/adminScreens/admin_page.dart';

class WidgetToFixProvider extends StatelessWidget {
  final bool admin;

  WidgetToFixProvider({
    this.admin,
  });

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
