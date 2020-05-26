import 'package:flutter/material.dart';
import 'package:cibus/services/models/ingredients.dart';

class IngredientList extends ChangeNotifier {
  List<Ingredient> ingredientList = [];

  void addIngredient(Ingredient ingredient) {
    this.ingredientList.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(int index) {
    this.ingredientList.removeAt(index);
    notifyListeners();
  }

  int get ingredientCount {
    return ingredientList.length;
  }
}
