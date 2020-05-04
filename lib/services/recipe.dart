import 'ingredients.dart';
import 'dart:io';

class Recipe {
  String title;
  String description;
  List<Ingredient> ingredients;
  List<String> listOfSteps;
  //TODO: NetworkImage? imageFile;
  String imageFile; //just to view temporary Recipe objects images
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