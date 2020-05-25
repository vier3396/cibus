import 'package:cibus/services/constants.dart';
import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'author_widget.dart';
import 'navigate_back_button.dart';

/*

Expanded(
                      child: Text(recipe.title ?? 'title',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: Text(
                        '${recipe.time ?? '?'} minutes',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

 */

//TODO fixa så att det går att gå fram och tillbaka ordentligt, steps krånglar.
//TODO fixa så att när man submittar så ska man få en bekräftelse/snackbar
//TODO fixa så att ingredients skrivs med id i en array så att man enkelt kan göra queries
//TODO Städa upp

class RecipePreview extends StatefulWidget {
  int index;
  @override
  _RecipePreviewState createState() => _RecipePreviewState();
  final bool preview;

  RecipePreview({this.preview, this.index});
}

class _RecipePreviewState extends State<RecipePreview> {
  void getRecipe({user, database}) async {}

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);
    //print(' recipe ID in recipe: ${Provider.of<Recipe>(context, listen: false).recipeId}');
    getRecipe(user: user, database: database);
    final popProvider = Provider.of<Recipe>(context);

    return Consumer<Recipe>(builder: (context, recipe, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            /*
            Container(
              padding: EdgeInsets.only(left: 12, top: 165),
              height: 250,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(recipe.title ?? 'title',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
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
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                      recipe.imageURL ?? kDefaultRecipePic),
                ),
              ),
            ),
             */
            Stack(
              children: <Widget>[
                Container(
                  height: 250,
                  child: Image(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        recipe.imageURL ?? kDefaultRecipePic),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  top: 110.0,
                  left: 20.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 1.5,
                    alignment: Alignment.bottomLeft,
                    child: Expanded(
                      child: Text(recipe.title ?? 'title',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  right: 20.0,
                  child: Text(
                    '${recipe.time ?? '?'} min',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Positioned(
                  top: 30.0,
                  left: 0.0,
                  child: NavigateBackButton(),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: widget.preview
                      ? EditButton()
                      : AuthorWidget(
                          userId: Provider.of<Recipe>(context).userId),
                ),
              ],
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
              margin: EdgeInsets.only(top: 230),
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height - 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                recipe.listOfSteps[index] ??
                                                    'step',
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
                  Divider(
                    color: kCoral,
                  ),
                  widget.preview
                      ? SubmitButton()
                      : Column(
                          children: <Widget>[
                            Text(
                              'Did you enjoy the recipe?',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            //TODO: FÅR DEM INTE I CENTER??
                            AddStarButtons(
                                recipeID: recipe.recipeId,
                                user: user,
                                myRating:
                                    Provider.of<Recipe>(context).yourRating),
                          ],
                        ),
                  widget.preview
                      ? Text('')
                      : Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Ink(
                              color: kCoral,
                              child: Text(
                                'Report Abuse',
                                style: TextStyle(
                                  color: kCoral,
                                ),
                              ),
                            ),
                            onTap: () {
                              final popProvider =
                                  Provider.of<Recipe>(context, listen: false);

                              String recipeId =
                                  Provider.of<Recipe>(context, listen: false)
                                      .recipeId;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return makeAlertDialog(
                                      recipeId: recipeId,
                                      context: context,
                                      database: database);
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  AlertDialog makeAlertDialog(
      {String recipeId, DatabaseService database, BuildContext context}) {
    return AlertDialog(
      title: Text('Report'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Do you want to report this recipe to the CIBUS Police?')
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor: kCoral,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            textColor: kCoral,
            onPressed: () {
              database.reportRecipe(recipeId: recipeId);
              Navigator.of(context).pop();
            },
            child: Text('Report'))
      ],
    );
  }
}

class AddStarButtons extends StatelessWidget {
  String recipeID;
  User user;
  int myRating;
  AddStarButtons({this.user, this.myRating, this.recipeID});

  Widget build(BuildContext context) {
    myRating = myRating ?? 0;
    return ButtonBar(
      // stars for rating, the _currentRating should be linked to each recipe's rating
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.star,
            color: myRating >= 1 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            print(recipeID);
            myRating = 1;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating, userId: user.uid);
            DatabaseService().updateRatings(
              recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
              rating: myRating,
              userId: user.uid,
            );
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            color: myRating >= 2 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 2;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);

            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            color: myRating >= 3 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 3;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);
            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            color: myRating >= 4 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 4;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);

            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
        GestureDetector(
          child: Icon(
            Icons.star,
            color: myRating >= 5 ? Colors.amberAccent : Colors.grey,
          ),
          onTap: () {
            myRating = 5;
            Provider.of<Recipe>(context, listen: false)
                .addYourRating(rating: myRating);

            DatabaseService().updateRatings(
                rating: myRating,
                recipeId: Provider.of<Recipe>(context, listen: false).recipeId,
                userId: user.uid);
          },
        ),
      ],
    );
  }
}

class RatingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text(
        Provider.of<Recipe>(context).rating ?? 'Not yet rated',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<Recipe>(context, listen: false).setListOfStepsToZero();
        Navigator.pop(context);
      },
      child: Text(
        'edit',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        User user = Provider.of<User>(context, listen: false);
        DatabaseService database = DatabaseService(uid: user.uid);
        String username = await database.getUsername();
        Provider.of<Recipe>(context, listen: false)
            .addUserIdAndUsername(uid: user.uid, username: username);
        database.uploadRecipe(Provider.of<Recipe>(context, listen: false));
        // send it here to avoid overwrite loss
        // Provider.of<Recipe>(context, listen: false).dispose();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MyPageView();
            },
          ),
        );
        //TODO: reset?? och fixa snackbar
        // formKey.currentState.reset();
        setState(() {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Your recipe is now uploaded!'),
              duration: Duration(seconds: 3),
            ),
          );
        });
      },
      child: Text(
        'submit',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
      ),
    );
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
