import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeList extends ChangeNotifier {
  List<DocumentSnapshot> recipeList = [];

  void addEntireRecipeList(List<DocumentSnapshot> recipeList) {
    this.recipeList = recipeList;
    notifyListeners();
  }

  void removeRecipeInList(int index) {
    recipeList.removeAt(index);
    notifyListeners();
  }
}
