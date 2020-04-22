import 'ingredients.dart';
import 'dart:io';

class Recipe {
  String title;
  String description;
  List<Ingredient> ingredients;
  List<String> steps;
  File imageFile;

  Recipe({
    this.description,
    this.ingredients,
    this.steps,
    this.title,
    this.imageFile,
});
}