import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import '../../services/recipe.dart';
import 'popup_body_recipe_individual.dart';

const topMarginPopupIndividualRecipe = 0.0;

class PopupBodyRecipes extends StatefulWidget {
  @override
  _PopupBodyRecipesState createState() => _PopupBodyRecipesState();
}

class _PopupBodyRecipesState extends State<PopupBodyRecipes> {
  List<Recipe> recipes = [];
  //Recipe(
  //      title: "Recipe 1",
  //      description: description1,
  //      listOfSteps: listOfStepsRecipe1,
  //      imageFile: "assets/recipe1.jpg",
  //      time: 30,
  //      rating: 3.5,
  //    ),
  //    Recipe(
  //      title: "Recipe 2",
  //      description: description2,
  //      listOfSteps: listOfStepsRecipe2,
  //      imageFile: "assets/recipe2.jpg",
  //      time: 120,
  //      rating: 4,
  //    ),
  //    Recipe(
  //      title: "Kladdkaka med annansgrädde",
  //      description: description3,
  //      listOfSteps: listOfStepsRecipe3,
  //      imageFile: "assets/recipe3.jpg",
  //      time: 90,
  //      rating: 5,
  //    ),
  //    Recipe(
  //      title: "Recipe 4",
  //      description: description4,
  //      listOfSteps: listOfStepsRecipe4,
  //      imageFile: "assets/recipe4.jpg",
  //      time: 40,
  //      rating: 5,
  //    ),
  //    Recipe(
  //      title: "Recipe 5",
  //      description: description5,
  //      listOfSteps: listOfStepsRecipe5,
  //      imageFile: "assets/recipe5.jpg",
  //      time: 50,
  //      rating: 1,
  //    )
  //  ];
  //
  //  static String description1 = "This recipe is awsome";
  //  static String description2 = "My moms recipe";
  //  static String description3 = "Homemade and crazy good!";
  //  static String description4 = "OK recipe";
  //  static String description5 = "Hello I'm a recipe. Blabla Blabla Blabla Blab";
  //
  //  static List<String> listOfStepsRecipe1 = ["Step 1","Step 2","Step 3"];
  //  static List<String> listOfStepsRecipe2 = ["Step 1","Step 2","Step 3", "Step 4"];
  //  static List<String> listOfStepsRecipe3 = ["Step 1","Step 2","Step 3", "Step 4", "Step 5"];
  //  static List<String> listOfStepsRecipe4 = ["Step 1","Step 2","Step 3", "Step 4", "Step 5", "Step 6"];
  //  static List<String> listOfStepsRecipe5 = ["Step 1","Step 2"];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PopupBodyIndividualRecipe(recipe: recipes[index]),
                ),
              );
            },
            title: Text(
              recipes[index].title,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            leading: GFAvatar(
              shape: GFAvatarShape.square,
              size: GFSize.LARGE,
              backgroundImage: AssetImage(recipes[index].imageURL),
            ),
            subtitle: Text(recipes[index].description),
            trailing: Column(
              children: <Widget>[
                Text((recipes[index].time).toString() + " min"),
                Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                ),
                Text((recipes[index].rating).toString()),
              ],
            ),
          ));
        });
  }
}
