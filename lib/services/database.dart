import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/services/ingredients.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  final CollectionReference ingredientCollection =
      Firestore.instance.collection('Ingredients');

  final CollectionReference recipeCollection =
      Firestore.instance.collection('Recipes');

  final CollectionReference ingredientRecipeCollection =
      Firestore.instance.collection('IngredientRecipes');

  final CollectionReference reportedRecipesCollection =
      Firestore.instance.collection("ReportedRecipes");

  Future<List> returnReportedRecipes() async {
    var result = await reportedRecipesCollection.getDocuments();
    var documents = result.documents;
    List<DocumentSnapshot> recipeList = [];

    for (DocumentSnapshot document in documents) {
      var recipeResult =
          await recipeCollection.document(document.documentID).get();
      recipeList.add(recipeResult);
    }

    List<Map> mapList = [];
    for (DocumentSnapshot document in recipeList) {
      String id = document.documentID;
      var ratingResult = await recipeCollection
          .document(id)
          .collection('Ratings')
          .getDocuments();
      var ratingDocuments = ratingResult.documents;
      print(ratingDocuments.isEmpty);
      double rating = 0;
      for (DocumentSnapshot ratingDocument in ratingDocuments) {
        rating = rating + ratingDocument.data['rating'];
      }
      double averageRating = rating / ratingDocuments.length;
      if (averageRating.isNaN) {
        averageRating = 0.0;
      }
      print(averageRating);
      //document.data['averageRating'] = averageRating;
      //print(document.data['averageRating']);
      //recipeList[0].data['averageRating'] = averageRating;
      var map = document.data;
      map['averageRating'] = averageRating ?? 0;
      map['recipeId'] = document.documentID;
      mapList.add(map);
    }

    return mapList;
  }

  Future updateUserData({String name, String description, int age}) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'description': description,
      'age': age,
    }, merge: true);
  }

  Future updateUserPicture({String pictureURL}) async {
    return await userCollection.document(uid).setData({
      'profilePic': pictureURL,
    }, merge: true);
  }

  Future updateUsername({String username}) async {
    return await userCollection.document(uid).setData({
      'username': username,
    }, merge: true);
  }

  Future<String> getUsername() async {
    var result = await userCollection.document(uid).get();
    return result.data['username'];
  }

  Future<List<Recipe>> findUserRecipes(String uid) async {
    List<Recipe> userRecipes = [];
    var recipeResult = await recipeCollection
        .where('userId', isEqualTo: uid)
        .getDocuments();

    for (DocumentSnapshot document in recipeResult.documents) {
      List<Ingredient> ingredientList = [];
      var ingredientResult = await recipeCollection
          .document(document.documentID)
          .collection('Ingredients')
          .getDocuments();

      for (DocumentSnapshot ingredientDocument in ingredientResult.documents) {
        Ingredient ingredient = Ingredient(
            ingredientName: ingredientDocument.data['ingredientName'],
            ingredientId: ingredientDocument.data['ingredientId'],
            quantityType: ingredientDocument.data['quantityType'],
            quantity: ingredientDocument.data['quantity']);
        ingredientList.add(ingredient);
      }

      userRecipes.add(
        Recipe(
          recipeId: document.documentID,
          title: document.data['title'],
          description: document.data['description'],
          ingredients: ingredientList,
          listOfSteps: document.data['listOfSteps'],
          imageURL: document.data['imageURL'],
          time: document.data['time'],
          rating: document.data['rating'],
          userId: document.data['userId'],
        ),
      );
    }

    return userRecipes;
  }

  Future removeFromUserFavorites(
      {List<dynamic> currentFavorites, String recipeId}) async {

    //print('currentFavorites innan remove: $currentFavorites');
    currentFavorites.remove(recipeId);
    print('userData.favoriteList efter remove: $currentFavorites');
    return await userCollection.document(uid).setData({
      'favoriteList': currentFavorites,
    }, merge: true);
  }

  Future addToUserFavorites(
      {List<dynamic> currentFavorites, String recipeId}) async {
    //print('currentFavorites innan add: $currentFavorites');
    currentFavorites.add(recipeId);
    print('userData.favoriteList efter add: $currentFavorites');
    return await userCollection.document(uid).setData({
      'favoriteList': currentFavorites,
    }, merge: true);
  }

  Future<List<Recipe>> findFavoriteRecipes(List<dynamic> recipeList) async {
    //print('Running method findFavoriteRecipes, favorit recept : $recipeList');
    List<Recipe> favoriteRecipeList = [];

    for (dynamic id in recipeList) {
      List<Ingredient> ingredientList = [];
      var result = await recipeCollection.document(id).get();
      var ingredientResult = await recipeCollection
          .document(id)
          .collection('Ingredients')
          .getDocuments();

      for (DocumentSnapshot document in ingredientResult.documents) {
        Ingredient ingredient = Ingredient(
            ingredientName: document.data['ingredientName'],
            ingredientId: document.data['ingredientId'],
            quantityType: document.data['quantityType'],
            quantity: document.data['quantity']);
        ingredientList.add(ingredient);
      }

      favoriteRecipeList.add(
        Recipe(
          recipeId: result.documentID,
          title: result.data['title'],
          description: result.data['description'],
          ingredients: ingredientList,
          listOfSteps: result.data['listOfSteps'],
          imageURL: result.data['imageURL'],
          time: result.data['time'],
          rating: result.data['rating'],
          userId: result.data['userId'],
        ),
      );
    }

    return favoriteRecipeList;
  }

  Future updateRatings({String recipeId, String userId, int rating}) async {
    print(recipeId);
    Map<String, dynamic> ratingsMap = {'userId': userId, 'rating': rating};
    return await recipeCollection
        .document(recipeId)
        .collection('Ratings')
        .document(userId)
        .setData(ratingsMap);
  }

  Future<int> getYourRating({
    String recipeId,
    String userId,
  }) async {
    print('recipeid: $recipeId');
    print('userId: $userId');
    //HÄR PRINTAR VI JÄTTEMYCKET TODO: TA BORT PRINTS
    var querySnapshot = await recipeCollection
        .document(recipeId)
        .collection("Ratings")
        .where('userId', isEqualTo: userId)
        .getDocuments();
    final documents = querySnapshot.documents;
    if (documents.isEmpty) {
      print('document is empty');
      return 0;
    } else {
      return querySnapshot.documents[0].data['rating'];
    }
  }

  Future<bool> isUsernameTaken({String username}) async {
//    final _query = await userCollection
//        .where('username', isEqualTo: username)
//        .limit(1).snapshots();
//    print(_query.toString());
    //if (username != '' && username != ' ' && username != null) {
    final result = await Firestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .getDocuments();
    /*.then((value) {
      value.documents.forEach((result) {
        print(result.data);
      });
    });*/
    for (DocumentSnapshot document in result.documents) {
      print(document.data);
    }

    print(result.documents.isNotEmpty); //isEmpty
    return result.documents.isNotEmpty;
    //}
    return true;
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    print(snapshot.data['favoriteList']);
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        description: snapshot.data['description'],
        age: snapshot.data['age'],
        username: snapshot.data['username'],
        profilePic: snapshot.data['profilePic'],
        isEmail: snapshot.data['isEmail'],
        favoriteList: snapshot.data['favoriteList']);
  }

  //get user doc stream
  Stream<UserData> get userData {
    print(userCollection.document(uid).snapshots());
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<Map> getIngredient(String ingredient) async {
    Map mapWithNameAndId = {'ingredientName': ' ', 'ingredientId': ' '};
    if (ingredient != '' && ingredient != null && ingredient != ' ') {
      final result = await ingredientCollection
          .where('Livsmedelsnamn', isEqualTo: ingredient)
          .getDocuments();
      if (result.documents.isNotEmpty) {
        final documents = result.documents;
        for (DocumentSnapshot document in documents) {
          print(document.data['Livsmedelsnamn']);
          mapWithNameAndId['ingredientName'] = document.data['Livsmedelsnamn'];
          mapWithNameAndId['ingredientId'] = document.documentID;
          print(mapWithNameAndId);
        }
        return mapWithNameAndId;
      } else if (result.documents.isEmpty) {
        print('Finns inte');
        return null;
      }
    }
    return null;
  }

  Future<List> findRecipes(List<Ingredient> ingredientList) async {
    if (ingredientList.isNotEmpty && ingredientList != null) {
      List<String> ingredientIdList = [];
      for (Ingredient ingredient in ingredientList) {
        ingredientIdList.add(ingredient.ingredientId);
      }
      var result = await recipeCollection
          .where('ingredientsArray', arrayContainsAny: ingredientIdList)
          .getDocuments();
      final documents = result.documents;
      if (documents.isNotEmpty) {
        List<int> removeIndexList = [];
        for (String ingredient in ingredientIdList) {
          for (var index = 0; index < documents.length; index++) {
            if (!documents[index]
                .data['ingredientsArray']
                .contains(ingredient)) {
              removeIndexList.add(index);
            }
          }
        }
        if (removeIndexList.isNotEmpty) {
          for (var index = 0; index < removeIndexList.length; index++) {
            documents.removeAt(removeIndexList[index] - index);
          }
        }
        List<Map> mapList = [];
        for (DocumentSnapshot document in documents) {
          String id = document.documentID;
          var ratingResult = await recipeCollection
              .document(id)
              .collection('Ratings')
              .getDocuments();
          var ratingDocuments = ratingResult.documents;
          print(ratingDocuments.isEmpty);
          double rating = 0;
          for (DocumentSnapshot ratingDocument in ratingDocuments) {
            rating = rating + ratingDocument.data['rating'];
          }
          double averageRating = rating / ratingDocuments.length;
          if (averageRating.isNaN) {
            averageRating = 0.0;
          }
          print(averageRating);
          document.data['averageRating'] = averageRating;
          print(document.data['averageRating']);
          //documents[0].data['averageRating'] = averageRating;
          var map = document.data;
          map['averageRating'] = averageRating;
          map['recipeId'] = document.documentID;
          mapList.add(map);
        }

        return mapList;
      }

      return null;
    }
    return null;
  }

  void reportRecipe({String recipeId}) async {
    var result = await reportedRecipesCollection
        .document(recipeId)
        .setData({'recipeId': recipeId});
    print('Uploaded');
  }

  void uploadRecipe(Recipe recipe) async {
    Map recipeMap = recipe.toMap();
    print(recipe);
    print(recipeMap);

    var result = await recipeCollection.add(recipeMap);
    for (Ingredient ingredient in recipe.ingredients) {
      Map ingredientMap = ingredient.ingredientsToMap();
      var ingredientResult = await recipeCollection
          .document(result.documentID)
          .collection('Ingredients')
          .document(ingredientMap['ingredientName'])
          .setData(ingredientMap);
    }
    Map<String, int> eMap = {};
    var test = await recipeCollection
        .document(result.documentID)
        .collection("newRatings")
        .document("throwAwayId")
        .setData(eMap);

    recipe.setRecipeId(result.documentID);
    print('result');
    print(result);
  }

  Future<List<Ingredient>> getIngredientCollectionFromRecipe(
      String documentID) async {
    List<Ingredient> ingredientList = [];
    if (documentID != null && documentID != '') {
      var result = await recipeCollection
          .document(documentID)
          .collection('Ingredients')
          .getDocuments();
      if (result == null) {
        return null;
      }
      var documents = result.documents;
      if (documents.isEmpty) {
        return null;
      }
      for (DocumentSnapshot document in documents) {
        ingredientList.add(Ingredient(
            ingredientName: document.data['ingredientName'],
            quantity: document.data['quantity'],
            quantityType: document.data['quantityType'],
            ingredientId: document.data['ingredientID']));
      }
      return ingredientList;
    } else {
      return null;
    }
  }
}
