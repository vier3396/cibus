import 'package:cibus/services/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';
import 'ingredients.dart';

class Recipe extends ChangeNotifier {
  String recipeId;
  String title;
  String description;
  List<Ingredient> ingredients = [];
  List<dynamic> listOfSteps = [];
  String imageURL;
  int time;
  double rating;
  String userId;
  List<String> ingredientList = [];
  String username;
  int yourRating;
  Map ratings;

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

  void addRecipeProperties(Recipe recipe) {
    this.recipeId = recipe.recipeId;
    this.title = recipe.title;
    this.description = recipe.description;
    this.ingredients = recipe.ingredients;
    this.listOfSteps = recipe.listOfSteps;
    this.imageURL = recipe.imageURL;
    this.time = recipe.time;
    this.rating = recipe.rating;
    this.userId = recipe.userId;
    this.ingredientList = recipe.ingredientList;
    notifyListeners();
  }

  void setRecipeId(String documentId) {
    recipeId = documentId;
    notifyListeners();
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
    notifyListeners();
  }

  void addUserIdAndUsername({String uid, String username}) {
    this.userId = uid;
    this.username = username;
    notifyListeners();
  }

  void removeIngredient(int index) {
    this.ingredients.removeAt(index);
    this.ingredientList.removeAt(index);
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
        'title': this.title,
        'description': this.description,
        //'ingredients' : this.ingredients,
        'listOfSteps': this.listOfSteps,
        'imageURL': this.imageURL ??
            kDefaultRecipePic,
        'time': this.time,
        'userId': this.userId,
        'ingredientsArray': this.ingredientList,
        'username': this.username,
        'recipeId': this.recipeId,
        'ratings': this.ratings,
      };

  int get ingredientCount {
    return ingredients.length;
  }

  void addAllPropertiesFromDocument(
      {Map<String, dynamic> recipe, String recipeID}) async {
    this.title = recipe['title'];
    this.ingredients =
        await DatabaseService().getIngredientCollectionFromRecipe(recipeID);
    this.imageURL = recipe['imageURL'];
    this.userId = recipe['userId'];
    this.time = recipe['time'];
    this.listOfSteps = recipe['listOfSteps'];
    this.description = recipe['description'];
    this.recipeId = recipeID;
    this.ratings = recipe['ratings'];
    notifyListeners();
  }

  void setListOfStepsToZero() {
    this.listOfSteps = [];
    notifyListeners();
  }

  void rateRecipe({String userId, int rating}) {
    ratings[userId] = rating;
    notifyListeners();
  }

  void addYourRating({int rating, String userId}) {
    this.yourRating = rating;
    //this.ratings[userId] = rating;
    notifyListeners();
  }
}
