import 'package:cibus/pages/searchRecipeScreens/popup_body_recipes.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/recipe_list.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/ingredient_tile.dart';
import 'package:cibus/widgets/ingredient_chooser_tile.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/services/models/ingredients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cibus/services/models/ingredient_list.dart';
import 'package:cibus/widgets/ingredient_tile_without_quantity.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:cibus/pages/adminScreens/admin_page.dart';

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
