import 'package:flutter/cupertino.dart';

import 'ingredients.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class Recipe extends ChangeNotifier {
  String title;
  String description;
  List<Ingredient> ingredients = [];
  List<String> listOfSteps = [];
  //TODO: NetworkImage? imageFile;
  String imageURL; //just to view temporary Recipe objects images
  int time;
  double rating;
  String userId;

  void addIngredient(
      {String ingredientId,
      String ingredientName,
      int ingredientQuantity,
      String quantityType}) {
    this.ingredients.add(Ingredient(
        ingredientId: ingredientId,
        ingredientName: ingredientName,
        quantityType: quantityType,
        quantity: ingredientQuantity));
    notifyListeners();
    print(ingredients);
  }

  void addDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  void addTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void addSteps(String stepText, int index) {
    this.listOfSteps.add(stepText);
    notifyListeners();
  }

  void addImage(String imageLink) {
    this.imageURL = imageLink;
    notifyListeners();
  }

  void addTime(int time) {
    this.time = time;
    notifyListeners();
  }

  void addRating(double newRating) {
    this.rating = newRating;
  }

  void addUserId(String uId) {
    this.userId = uId;
  }

  Map<String, dynamic> toMap() => {
        'title': this.title,
        'desctiption': this.description,
        //'ingredients' : this.ingredients,
        'listOfSteps': this.listOfSteps,
        'imageURL': this.imageURL,
        'time': this.time,
        'rating': this.rating,
        'userId': this.userId
      };

  int get ingredientCount {
    return ingredients.length;
  }
}
