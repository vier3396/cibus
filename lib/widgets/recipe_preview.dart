import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';

//TODO fixa så att det går att gå fram och tillbaka ordentligt, steps krånglar.
//TODO fixa så att när man submittar så ska man skickas till homepage
//TODO fixa så att ingredients skrivs med id i en array så att man enkelt kan göra queries
//TODO Städa upp

class RecipePreview extends StatefulWidget {
  @override
  _RecipePreviewState createState() => _RecipePreviewState();
}

class _RecipePreviewState extends State<RecipePreview> {
  List<String> textList = ['step 1', 'step 2', 'step3', 'step 4'];

  @override
  Widget build(BuildContext context) {
    return Consumer<Recipe>(builder: (context, recipe, child) {
      return Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 130),
                height: 219,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(recipe.title ?? 'title',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500)),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          '${recipe.time ?? '?'} minutes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(recipe.imageURL ??
                          'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/images%2F2020-05-08%2011%3A32%3A16.330607.png?alt=media&token=1e4bff1d-c08b-4afa-a1f3-a975e46e89c5')),
                ),
              ),
              Positioned(
                top: 30,
                left: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'edit',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 10,
                child: InkWell(
                  onTap: () {
                    User user = Provider.of<User>(context, listen: false);
                    recipe.addUserId(user.uid);
                    DatabaseService(uid: user.uid).uploadRecipe(recipe);
                    // send it here to avoid overwrite loss
                    print("Success");
                    // formKey.currentState.reset();
                    //TODO: clear all fields
                    Navigator.pop(context);
                  },
                  child: Text(
                    'submit',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
                margin: EdgeInsets.only(top: 180),
                constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height - 219),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Ingredients',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                top: 15.0,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Text(
                                    '${recipe.ingredients[index].quantity ?? 'ingredient'} ${recipe.ingredients[index].quantityType} ${recipe.ingredients[index].ingredientName}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  margin: EdgeInsets.only(bottom: 18.0),
                                );
                              },
                              itemCount: recipe.ingredients.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Recipe steps',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 15.0),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "Step ${index + 1}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15.0, top: 0),
                                          child: Text(
                                            recipe.listOfSteps[index] ?? 'step',
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: recipe.listOfSteps.length,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
//Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Container(
//                                        margin:
//                                            EdgeInsets.only(top: 8, left: 8),
//                                        child: Text(
//                                          'Step ${index + 1}',
//                                          style: TextStyle(
//                                              fontSize: 20.0,
//                                              fontWeight: FontWeight.w500),
//                                        )),
//                                    Container(
//                                      padding: EdgeInsets.only(
//                                          left: 15,
//                                          bottom: 5.0,
//                                          right: 15,
//                                          top: 5.0),
//                                      decoration: BoxDecoration(
//                                          border:
//                                              Border.all(color: Colors.black54),
//                                          borderRadius: BorderRadius.all(
//                                              Radius.circular(20.0))),
//                                      child: Text(
//                                        textList[index],
//                                        style: TextStyle(
//                                            fontSize: 20.0,
//                                            fontWeight: FontWeight.w400),
//                                      ),
//                                      margin: EdgeInsets.only(top: 3.0),
//                                    ),
//                                  ],
//                                );
