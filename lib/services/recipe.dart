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
  List<String> ingredientList = [];
  String recipeId;
  Map ratings = Map();

  void rateRecipe({String userId, int rating}) {
    ratings[userId] = rating;
    notifyListeners();
  }

  double getAverageRating() {
    double totalRating = 0;
    ratings.forEach((uid, rating) => totalRating += rating);
    return totalRating / ratings.length;
  }

  void addIngredient(
      {String ingredientId,
      String ingredientName,
      int ingredientQuantity,
      String quantityType}) {
    this.ingredientList.add(ingredientId);
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

  void removeIngredient(int index) {
    this.ingredients.removeAt(index);
    this.ingredientList.removeAt(index);
    notifyListeners();
  }

  void setRecipeId(String documentId) {
    recipeId = documentId;
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
        'title': this.title,
        'description': this.description,
        //'ingredients' : this.ingredients,
        'listOfSteps': this.listOfSteps,
        'imageURL': this.imageURL,
        'time': this.time,
        'rating': this.rating,
        'userId': this.userId,
        'ingredientsArray': this.ingredientList,
        'recipeId': this.recipeId,
        'ratings': this.ratings,
      };

  int get ingredientCount {
    return ingredients.length;
  }
}
