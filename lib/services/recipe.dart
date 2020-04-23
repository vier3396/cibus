import 'ingredients.dart';
import 'dart:io';

class Recipe {
  String title;
  String description;
  List<Ingredient> ingredients;
  var listOfSteps;
  File imageFile;

  Recipe({
    this.description,
    this.ingredients,
    this.listOfSteps,
    this.title,
    this.imageFile,
});
}