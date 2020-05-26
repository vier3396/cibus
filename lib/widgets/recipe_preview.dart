import 'package:cibus/services/constants.dart';
import 'package:cibus/widgets/submit_recipe_button.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'add_start_buttons.dart';
import 'author_widget.dart';
import 'edit_recipe_button.dart';
import 'navigate_back_button.dart';

//TODO further refactor widgets?

class RecipePreview extends StatefulWidget {
  final int index;
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
    getRecipe(user: user, database: database);

    return Consumer<Recipe>(builder: (context, recipe, child) {
      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
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
                    bottom: 35.0,
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
                    bottom: 35.0,
                    right: 20.0,
                    child: Text(
                      '${recipe.time ?? '?'} min',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  widget.preview
                      ? Text('')
                      : Positioned(
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
                margin: EdgeInsets.only(top: 220),
                constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height - 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Text(
                          recipe.description,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
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
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 4.0, bottom: 10.0),
                                  child: Text(
                                    'Recipe steps',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0),
                                  ),
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
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "Step ${index + 1}",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 15.0, top: 0),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                child: Text(
                                                  recipe.listOfSteps[index] ??
                                                      'step',
                                                  textAlign: TextAlign.left,
                                                ),
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
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: kCoral,
                    ),
                    widget.preview
                        ? Expanded(
                            flex: 1,
                            child: Container(
                              child: SubmitButton(),
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.all(10.0),
                            ),
                          )
                        : Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Did you enjoy the recipe?',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        SizedBox(),
                                        AddStarButtons(
                                            recipeID: recipe.recipeId,
                                            user: user,
                                            myRating: Provider.of<Recipe>(context)
                                                .yourRating),
                                        SizedBox(),
                                      ],
                                    )
                                  ],
                                ),
                                InkWell(
                                  child: Ink(
                                    color: kCoral,
                                    child: Text(
                                      'Report Abuse',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  onTap: () {
                                    String recipeId = Provider.of<Recipe>(
                                            context,
                                            listen: false)
                                        .recipeId;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ReportRecipeAlertDialog(
                                            recipeId: recipeId,
                                            context: context,
                                            database: database);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  AlertDialog ReportRecipeAlertDialog(
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
