import 'ingredients.dart';
import 'dart:io';

class Recipe {
  String title;
  String description;
  List<Ingredient> ingredients;
  List<String> listOfSteps;
  //File imageFile;
  String imageFile;
  int time;
  double rating;

  Recipe({
    this.title,
    this.description,
    this.ingredients,
    this.listOfSteps,
    this.imageFile,
    this.time,
    this.rating,
  });
}