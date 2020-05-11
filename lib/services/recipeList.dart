import 'package:flutter/material.dart';

class RecipeList extends ChangeNotifier {
  List<Map> recipeList = [];

  void addEntireRecipeList(List<Map> recipeList) {
    this.recipeList = recipeList;
    notifyListeners();
  }
}
