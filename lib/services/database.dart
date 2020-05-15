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

  Future updateAverageRating({String recipeId}) async {
    double averageRating = await getAverageRating(recipeId: recipeId);
    recipeCollection.document(recipeId).setData({"rating": averageRating});
    return null;
  }

  Future updateRatings({int ratings, String recipeId, String userId}) async {
    Map<String, int> ratingsMap = {userId: ratings};
    return await recipeCollection
        .document(recipeId)
        .collection("newRatings")
        .document(userId)
        .setData(ratingsMap);
  }

  Future<int> getYourRating({
    String recipeId,
    String userId,
  }) async {
    QuerySnapshot querySnapshot = await recipeCollection
        .document(recipeId)
        .collection("newRatings")
        .getDocuments();
    final doc = querySnapshot.documents;
    int value = doc[0].data[userId];
    print("value i getyorrating " + value.toString());
    if (value == null) {
      print("myrating: 0");
      return 0;
    } else {
      print("myrating " + value.toString());
      return value;
    }
  }

  Future<double> getAverageRating({String recipeId}) async {
    QuerySnapshot querySnapshot = await recipeCollection
        .document(recipeId)
        .collection("newRatings")
        .getDocuments();
    final doc = querySnapshot.documents;
    double sumRating = 0;
    if (doc.length > 0) {
      for (DocumentSnapshot snap in doc) {
        snap.data.forEach((key, value) => sumRating += value);
      }
      return sumRating / doc.length;
    } else {
      return null;
    }
  }

  Future<bool> isUsernameTaken({String username}) async {
//    final _query = await userCollection
//        .where('username', isEqualTo: username)
//        .limit(1).snapshots();
//    print(_query.toString());

    final result = await Firestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .getDocuments();
    /*.then((value) {
      value.documents.forEach((result) {
        print(result.data);
      });
    });*/
    print(result.documents.isNotEmpty); //isEmpty
    return result.documents.isNotEmpty;
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        description: snapshot.data['description'],
        age: snapshot.data['age'],
        username: snapshot.data['username'],
        profilePic: snapshot.data['profilePic'],
        isEmail: snapshot.data['isEmail']);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<Map> getIngredient(String ingredient) async {
    Map mapWithNameAndId = {'ingredientName': ' ', 'ingredientId': ' '};
    if (ingredient != '' && ingredient != null) {
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
    List<String> ingredientIdList = [];
    List<DocumentSnapshot> recipeList = [];
    for (Ingredient ingredient in ingredientList) {
      ingredientIdList.add(ingredient.ingredientId);
    }
    var result = await recipeCollection
        .where('ingredientsArray', arrayContainsAny: ingredientIdList)
        .getDocuments();
    if (result.documents.isNotEmpty) {
      final documents = result.documents;
      for (DocumentSnapshot document in documents) {
        recipeList.add(document);
      }
      return recipeList;
    }
    return null;
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

    Map<String, int> ratingsMap = {};
    await recipeCollection.add(ratingsMap);
    await recipeCollection
        .document(recipe.recipeId)
        .collection('newRatings')
        .document(uid)
        .setData(ratingsMap);
    recipe.setRecipeId(result.documentID);
    print('result');
    print(result);
  }
}
