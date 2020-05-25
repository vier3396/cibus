import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/pages/addRecipeScreens/add_recipe_form.dart';

class AddRecipeFormProviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Recipe>(
      create: (context) => Recipe(),
      child: AddRecipeForm(),
    );
  }
}
