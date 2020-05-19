import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeList extends ChangeNotifier {
  List<Map> recipeList = [];

  void addEntireRecipeList(List<Map> recipeList) {
    this.recipeList = recipeList;
    notifyListeners();
  }

  void removeRecipeInList(int index) {
    recipeList.removeAt(index);
    notifyListeners();
  }
}
