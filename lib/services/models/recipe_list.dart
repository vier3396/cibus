import 'package:flutter/material.dart';

class RecipeList extends ChangeNotifier {
  List<Map> recipeList = [];

  void addEntireRecipeList(List<Map> recipeList) {
    if (recipeList != null) {
      this.recipeList = recipeList;
      notifyListeners();
    }
  }

  void removeRecipeInList(int index) {
    recipeList.removeAt(index);
    notifyListeners();
  }

  int get recipeCount {
    return recipeList.length;
  }
}
