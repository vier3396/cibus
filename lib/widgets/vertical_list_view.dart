import 'package:cibus/services/recipe.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/widgets/show_rating.dart';

TextStyle textStyleTitle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
);

class VerticalListView extends StatefulWidget {
  final String title;
  List<Recipe> recipes;
  bool myOwnUserPage;

  VerticalListView({this.title, this.recipes, this.myOwnUserPage});

  @override
  _VerticalListViewState createState() => _VerticalListViewState();
}

class _VerticalListViewState extends State<VerticalListView> {
  final DatabaseService database = DatabaseService();

  int get recipeCount {
    return widget.recipes.length;
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.recipes[0].title);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        ChangeNotifierProvider<Recipe>(
          create: (context) => Recipe(),
          child: Container(
            height: 500.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: recipeCount,
              itemBuilder: (BuildContext context, int index) {
                //Recipe currentRecipe = recipes[index];
                return GestureDetector(
                  onTap: () {
                    Provider.of<Recipe>(context, listen: false)
                        .addRecipeProperties(widget.recipes[index]);

                    final recipeProvider =
                        Provider.of<Recipe>(context, listen: false);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: recipeProvider,
                          child: RecipePreview(
                            preview: false,
                          ),
                        );
                      }),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: 210.0,
                    //height: 200,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  height: 180.0,
                                  width: 180.0,
                                  image: NetworkImage(
                                      widget.recipes[index].imageURL ??
                                          kDefaultRecipePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              widget.myOwnUserPage
                                  ? IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return makeAlertDialog(
                                                recipeId: widget
                                                    .recipes[index].recipeId,
                                                context: context,
                                                database: database,
                                                index: index,
                                              );
                                            });
                                        //  database.removeRecipe(
                                        //  currentRecipe.recipeId,
                                        //  );
                                      })
                                  : SizedBox(),
                              //TODO fixa denna knapp
                              /*
                              Positioned(
                                right: 2.0,
                                bottom: 2.0,
                                child: FavoriteButton(),
                              ),

                               */
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 200.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.recipes[index].title ??
                                        'Could not find title',
                                    style: textStyleTitle,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.recipes[index].description ??
                                          'Could not find description',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  //TODO: funkar inte
                                  ShowRating(
                                      rating:
                                          widget.recipes[index].averageRating ??
                                              0,
                                      imageHeight: 20.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog makeAlertDialog({
    String recipeId,
    DatabaseService database,
    BuildContext context,
    int index,
  }) {
    return AlertDialog(
      title: Text('Delete'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text('Do you want to delete this recipe?')],
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
              //recipes.removeAt(index);
              database.removeRecipe(recipeId: recipeId);
              Navigator.of(context).pop();
              setState(() {
                widget.recipes.removeAt(index);
              });
            },
            child: Text('Delete'))
      ],
    );
  }
}
