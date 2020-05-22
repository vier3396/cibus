import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cibus/services/recipeList.dart';

//TODO fixa så att det går att gå fram och tillbaka ordentligt, steps krånglar.
//TODO fixa så att när man submittar så ska man skickas till homepage
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
  List<String> textList = ['step 1', 'step 2', 'step3', 'step 4'];

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
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 130),
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(recipe.title ?? 'title',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500)),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
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
                      image: CachedNetworkImageProvider(recipe.imageURL ??
                          'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/blank_profile_picture.png?alt=media&token=49efb712-d543-40ca-8e33-8c0fdb029ea5')),
                ),
              ),
              Positioned(
                  top: 40,
                  left: 10,
                  child: widget.preview
                      ? EditButton()
                      : AddStarButtons(
                          recipeID: recipe.recipeId,
                          user: user,
                          myRating: Provider.of<Recipe>(context).yourRating)),
              Positioned(
                top: 40,
                right: 10,
                child: widget.preview ? SubmitButton() : AuthorWidget(),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
                margin: EdgeInsets.only(top: 200),
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
                    if (widget.preview)
                      SizedBox()
                    else
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Ink(
                                color: kCoral,
                                child: Text(
                                  'Report Abuse',
                                  style: TextStyle(
                                    color: kCoral,
                                  ),
                                )),
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
                          )),
                  ],
                ),
              ),
            ],
          ),
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
            Text('Do you want to report this recipe to the Cibus-Police')
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

class AuthorWidget extends StatelessWidget {
  //TODO implement userPage
  //TODO save userName to recipe when creating
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserPage(username: Provider.of<Recipe>(context).username)));

      },
      child: Text(
        Provider.of<Recipe>(context).username ?? 'userName',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}

Future<UserData> getUser(String username) async {
  return await DatabaseService().getUserData(username);
}

class UserPage extends StatelessWidget {
  String username;
  UserPage({this.username});



  @override
  Widget build(BuildContext context) {
    return Scaffold();
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

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //TODO lägga till någon form av popup i stilen great job
        User user = Provider.of<User>(context, listen: false);
        DatabaseService database = DatabaseService(uid: user.uid);
        String username = await database.getUsername();
        Provider.of<Recipe>(context, listen: false)
            .addUserIdAndUsername(uid: user.uid, username: username);
        database.uploadRecipe(Provider.of<Recipe>(context, listen: false));
        // send it here to avoid overwrite loss
        print("Success");

        // Provider.of<Recipe>(context, listen: false).dispose();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MyPageView();
            },
          ),
        );
        // formKey.currentState.reset();
      },
      child: Text(
        'submit',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
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
