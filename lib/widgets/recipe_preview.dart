import 'package:flutter/cupertino.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/submit_recipe_button.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'add_start_buttons.dart';
import 'author_widget.dart';
import 'edit_recipe_button.dart';
import 'favorite_button.dart';
import 'navigate_back_button.dart';

//TODO: OVERFLOW

const kShadowList = [
  Shadow(
    offset: Offset(0.1, 0.0),
    blurRadius: 6.0,
    color: Colors.grey,
  )
];

class RecipePreview extends StatefulWidget {
  final int index;
  @override
  _RecipePreviewState createState() => _RecipePreviewState();
  final bool preview;

  RecipePreview({this.preview, this.index});
}

class _RecipePreviewState extends State<RecipePreview> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);

    return Consumer<Recipe>(builder: (context, recipe, child) {
      return Scaffold(
        key: _scaffoldKey,
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
                  /* TITLE ON PICTURE
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
                                //shadows: kShadowList,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                   */
                  widget.preview
                      ? Text('')
                      : Positioned(
                          top: 40.0,
                          left: 0.0,
                          child: NavigateBackButton(),
                        ),
                  Positioned(
                    bottom: 35,
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
                    height: MediaQuery.of(context).size.height - 210),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(child: Text(recipe.title ?? 'title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)),
                                    Text(
                                      '${recipe.time ?? '?'} min',
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(right: 10, top: 5, bottom: 10),
                                        child: Text(
                                          recipe.description ??
                                              'Cannot find description',
                                        ),
                                      ),
                                    ),
                                    widget.preview
                                        ? Text('')
                                        : FavoriteButton(),
                                  ],
                                ),
                              ],
                            ),
                            /* Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(recipe.title ?? 'title'),
                                Text(
                                  recipe.description ?? 'Cannot find description',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                              Text(
                                '${recipe.time ?? '?'} min',
                                style: TextStyle(),
                              ),
                              widget.preview
                                  ? Text('')
                                  : FavoriteButton(),
                            ],
                            ),
                             */
                          ),
                        ],
                      ),
                    ),
                    /*
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(recipe.title ?? 'title',
                                    style: TextStyle()),
                                Flexible(
                                  child: Text(
                                    recipe.description ?? 'Cannot find description',
                                    style: TextStyle(),
                                  ),
                                ),
                              ],
                            ),
                            Column(children: <Widget>[
                              Text(
                                '${recipe.time ?? '?'} min',
                                style: TextStyle(),
                              ),
                              widget.preview
                                  ? Text('')
                                  : FavoriteButton(),
                            ],)
                          ],
                        ),
                      ),
                    ),

                     */
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: Text(
                                          '${recipe.ingredients[index].quantity ?? 'ingredient'} ${recipe.ingredients[index].quantityType} ${recipe.ingredients[index].ingredientName}',
                                        ),
                                        margin: EdgeInsets.only(bottom: 12.0),
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
                                      EdgeInsets.only(left: 10.0, bottom:0.0),
                                  child: Text(
                                    'Recipe steps',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(top: 10.0),
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
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Did you enjoy the recipe?',
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      SizedBox(),
                                      AddStarButtons(
                                          recipeID: recipe.recipeId,
                                          user: user,
                                          myRating:
                                              Provider.of<Recipe>(context)
                                                  .yourRating),
                                      SizedBox(),
                                    ],
                                  ),
                                SizedBox(height: 10,),
                                  Expanded(
                                    child: InkWell(
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
                                  ), 
                                ],
                              ),
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
              _displaySnackBar(context);
            },
            child: Text('Report'))
      ],
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: kCoral,
      content: Text("Recipe reported. The CIBUS admins will have a look!"),
      duration: Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
